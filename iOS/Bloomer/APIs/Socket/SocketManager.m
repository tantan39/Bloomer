//
//  SocketManager.m
//  Bloomer
//
//  Created by Tan Tan on 8/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "SocketManager.h"
#import "NotificationHelper.h"
#define kTimeReconnect 5
@interface SocketManager(){
    BOOL isOpen;
    UserDefaultManager * userDefault;
}
@property (strong,nonatomic) SRWebSocket * socket;
@property (assign,nonatomic) BOOL internetConnection;

@end


@implementation SocketManager

+ (instancetype)shareInstance{
    static SocketManager * instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[SocketManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initWebSocket];
        userDefault = [[UserDefaultManager alloc] init];
    }
    return self;
}

- (void) initWebSocket{
    NSURL* url = [[NSURL alloc] initWithString:[APIDefine hostSocket]];
    self.socket = [[SRWebSocket alloc] initWithURL:url];
    self.socket.delegate = self;
}

- (void)setInternetConnection:(BOOL)internetConnection{
    if (internetConnection) {
        if (isOpen) {
            return;
        }
        [self reconnectWebSocket];
    }else{
         isOpen  = NO;
        [self closeConnection];
        if (self.isConnectedResponse) {
            self.isConnectedResponse(nil);
        }
    }
}

- (void) handleNetworkReachability {
    AFNetworkReachabilityManager * reachabilityManager = [AFNetworkReachabilityManager sharedManager];

    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.internetConnection = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.internetConnection = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.internetConnection = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.internetConnection = YES;
                break;
            default:
                break;
        }
    }];
    [reachabilityManager startMonitoring];
}

- (void) reconnectWebSocket{
    NSURL* url = [[NSURL alloc] initWithString:[APIDefine hostSocket]];
    self.socket = [[SRWebSocket alloc] initWithURL:url];
    self.socket.delegate = self;
    [self.socket open];
}

- (void)establishConnection{
    if (self.socket) {
        [self.socket open];
        return;
    }
    [self reconnectWebSocket];
}

- (void)closeConnection {
    [self.socket close];
    self.socket.delegate = nil;
    self.socket = nil;
    isOpen = NO;
    self.authenticated = NO;
}

- (BOOL) IsConnected {
    return isOpen;
}

//MARK:- SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    isOpen = NO;
    [self closeConnection];
    
    NSLog(@"didFailWithError %@",error.localizedDescription);
    self.authenticated = NO;
    if (self.isConnectedResponse) {
        self.isConnectedResponse(error);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeReconnect * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reconnectWebSocket];
    });
    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    if (self.socket && self.authenticated) {
        return;
    }
    isOpen = YES;
    self.socket = webSocket;
    
    [self connectToServerWithAccessToken:[userDefault getAccessToken] DeviceToken:[userDefault getDeviceToken] UserID:[[userDefault getUserProfileData] uid]];
    if (self.isConnectedResponse) {
        self.isConnectedResponse(nil);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)response{
    NSLog(@"receiveMessageWithParams %@",response);
    NSDictionary * json = [NSString convertDictionaryFromString:response];
    NSDictionary * data = [json objectForKey:k_Data];
    
    NSString * eventName = [json objectForKey:k_CMD];
    
    if ([eventName isEqualToString:[APIDefine errorEvent]]) {  //Error Event
        NSInteger code = [[data objectForKey:k_CODE] integerValue];
        switch (code) {
            case 101: //Authen fail
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeReconnect * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self connectToServerWithAccessToken:[userDefault getAccessToken] DeviceToken:[userDefault getDeviceToken] UserID:[[userDefault getUserProfileData] uid]];
                });
                break;
            }

                
            default:
                [AppHelper showMessageBox:nil message:[data objectForKey:k_MSG]];
                break;
        }
        
    } else if (([eventName isEqualToString:[APIDefine authenEvent]])) { // Authen Success
        NSString * status = [data objectForKey:k_STATUS];
        if ([status isEqualToString: k_Success]) {
            self.authenticated = YES;
            
            if (self.onAuthenSuccess) {
                self.onAuthenSuccess();
            }
        }
    } else if ([eventName isEqualToString:[APIDefine receiveMessageEvent]]){   //Incoming message
        message * obj = [[message alloc ] initWithJSON:data];
        [AppHelper handleMessageIncoming:obj];
        if (self.onMessageReceive) {
            self.onMessageReceive(obj);
        }
        
    }else if ([eventName isEqualToString:[APIDefine messageHistoryResponse]]){   //Fetch history message
        NSMutableArray * messages = [[NSMutableArray alloc] init];
        ChatStatus * status = [[ChatStatus alloc] initWithJSON:data];
        NSString * roomID = [data objectForKey:k_ROOM_ID];
        NSInteger remain_flower = [[data objectForKey:k_REMAIN_FLOWER] integerValue];
        
        for (NSDictionary * js in [data objectForKey:k_MSGS]) {
            message * obj = [[message alloc ] initWithJSON:js];
            [messages addObject:obj];
        }
        
        if (self.onHistoryMessages) {
            self.onHistoryMessages(status,messages,roomID,remain_flower);
        }

    }else if ([eventName isEqualToString:[APIDefine sendMessageResponse]]){   //Send message
        NSInteger iBlock = [[data objectForKey:k_BLOCK] integerValue];
        ChatStatus * status;
        BOOL send = NO;
        if (iBlock == 1 || iBlock == 2) {
            status = [[ChatStatus alloc] init];
            status.block = iBlock;
            status.msg =  [data objectForKey:k_MSG];
        }else{
            send = [[data objectForKey:k_SENT] boolValue];
        }
        
        
        if (self.onMessageSendResponse) {
            self.onMessageSendResponse(status,send);
        }
        
    }else if ([eventName isEqualToString:[APIDefine blockChatResponse]]){  //Block
        BOOL status = [[data objectForKey:k_STATUS] boolValue];
        ChatStatus * chatStatus = [[ChatStatus alloc] init];
        chatStatus.block =  [[data objectForKey:k_BLOCK] integerValue];
        chatStatus.msg = [data objectForKey:k_MSG];
        if (self.onBlockEventResponse) {
            self.onBlockEventResponse(chatStatus);
        }
    }else if ([eventName isEqualToString:[APIDefine unBlockChatResponse]]){ //Unblock
        BOOL status = [[data objectForKey:k_STATUS] boolValue];
        if (self.onUnBlockEventResponse) {
            self.onUnBlockEventResponse(status);
        }
    }

}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"didCloseWithCode %ld %@",(long)code,reason);
    
    [self closeConnection];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeReconnect * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reconnectWebSocket];
    });
}

//MARK:- Events
- (void)connectToServerWithAccessToken:(NSString *)accessToken DeviceToken:(NSString *)deviceToken UserID:(NSInteger) uid{

    if (isOpen) {
        NSDictionary * data = @{ k_ACCESS_TOKEN : accessToken,
                                 k_DEVICE_TOKEN : deviceToken,
                                 k_UID : [NSNumber numberWithInteger:uid]
                                 };
        
        NSDictionary * json = @{k_CMD : [APIDefine authenticateEvent],
                                k_Data : data };
        NSLog(@"%@ %@",[APIDefine authenticateEvent],json);
        NSString *jsonString = [NSString convertStringFromJSON:json];
        
        [self.socket send:jsonString];
    }

}

- (void)getMessageHistoryWithSenderID:(NSInteger)senderID ReceiverID:(NSInteger)receiverID RoomID:(NSString *)roomID mID:(NSString *)mID {
    if (isOpen) {
        NSDictionary * data = @{ k_UID : [NSNumber numberWithInteger:senderID],
                                 k_RECEIVER : [NSNumber numberWithInteger:receiverID],
                                 k_ROOM_ID : roomID,
                                 k_MID : mID
                                 };
        
        NSDictionary * json = @{k_CMD : [APIDefine messageHistoryRequest],
                                k_Data : data };
        
        NSString *jsonString = [NSString convertStringFromJSON:json];
        NSLog(@"%@ %@",[APIDefine messageHistoryRequest],json);
        [self.socket send:jsonString];
    }
}

- (void)sendMessageWithSenderID:(NSInteger)senderID ReceiverID:(NSInteger)receiverID Content:(NSString *)content Resource:(NSInteger)resource{
    if (isOpen) {
        NSDictionary * data = @{ k_UID : [NSNumber numberWithInteger:senderID],
                                 k_RECEIVER : [NSNumber numberWithInteger:receiverID],
                                 k_MSG : content,
                                 k_RESOURCE : [NSNumber numberWithInteger:resource]
                                 };
        
        NSDictionary * json = @{k_CMD : [APIDefine sendMessageEvent],
                                k_Data : data };
        
        NSString *jsonString = [NSString convertStringFromJSON:json];
        NSLog(@"%@ %@",[APIDefine sendMessageEvent],json);
        [self.socket send:jsonString];
    }
}

- (void)blockChatWithID:(NSInteger)uID ReceiverID:(NSInteger)receiverID{
    if (isOpen) {
        NSDictionary * data = @{
                                k_UID : [NSNumber numberWithInteger:uID],
                                k_RECEIVER : [NSNumber numberWithInteger:receiverID]
                                };
        
        NSDictionary * json = @{k_CMD : [APIDefine blockChatRequest],
                                k_Data : data
                                };
        NSString *jsonString = [NSString convertStringFromJSON:json];
        NSLog(@"%@ %@",[APIDefine blockChatRequest],json);
        [self.socket send:jsonString];
    }
}

- (void)unBlockChatWithID:(NSInteger)uID ReceiverID:(NSInteger)receiverID{
    if (isOpen) {
        NSDictionary * data = @{
                                k_UID : [NSNumber numberWithInteger:uID],
                                k_RECEIVER : [NSNumber numberWithInteger:receiverID]
                                };
        
        NSDictionary * json = @{k_CMD : [APIDefine unBlockChatRequest],
                                k_Data : data
                                };
        NSString *jsonString = [NSString convertStringFromJSON:json];
        NSLog(@"%@ %@",[APIDefine unBlockChatRequest],json);
        [self.socket send:jsonString];
    }
}

- (void)seenMessageWithID:(NSInteger)uID SenderID:(NSInteger)senderID RoomID:(NSString *)roomID mID:(NSString *)mID{
    if (isOpen) {
        NSDictionary * data = @{
                                k_UID : [NSNumber numberWithInteger:uID],
                                k_SENDER : [NSNumber numberWithInteger:senderID],
                                k_ROOM_ID : roomID,
                                k_MID : mID
                                };
        
        NSDictionary * json = @{k_CMD : [APIDefine receiveMessageEvent],
                                k_Data : data
                                };
        NSString *jsonString = [NSString convertStringFromJSON:json];
        NSLog(@"%@ %@",[APIDefine receiveMessageEvent],json);
        [self.socket send:jsonString];
    }
}


@end
