//
//  SocketManager.h
//  Bloomer
//
//  Created by Tan Tan on 8/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestfulResponse.h"
#import <SocketRocket/SocketRocket.h>
#import "NSString+Extension.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "message.h"
#import "UserDefaultManager.h"

typedef void(^IsConnectedResponse)(NSError *error);

@interface SocketManager : NSObject <SRWebSocketDelegate>

+ (instancetype) shareInstance;

@property (copy,nonatomic) IsConnectedResponse isConnectedResponse;;
@property (copy,nonatomic) void (^onAuthenSuccess)() ;
@property (copy,nonatomic) void (^onMessageReceive)(message * data) ;
@property (copy,nonatomic) void (^onHistoryMessages)(ChatStatus * status, NSMutableArray * data, NSString * roomID, NSInteger remain_flower) ;
@property (copy,nonatomic) void (^onMessageSendResponse)(ChatStatus * status,BOOL send) ;

@property (copy,nonatomic) void (^onBlockEventResponse)(ChatStatus * status) ;
@property (copy,nonatomic) void (^onUnBlockEventResponse)(BOOL status) ;

@property (assign,nonatomic) BOOL authenticated ;

- (void) establishConnection;
- (void) closeConnection;
- (BOOL) IsConnected;
- (void) handleNetworkReachability;

- (void) connectToServerWithAccessToken:(NSString *) accessToken DeviceToken:(NSString *) deviceToken UserID:(NSInteger) uid;

- (void) getMessageHistoryWithSenderID:(NSInteger) senderID ReceiverID:(NSInteger) receiverID RoomID:(NSString *) roomID mID:(NSString *) mID;

- (void) sendMessageWithSenderID:(NSInteger) senderID ReceiverID:(NSInteger) receiverID Content:(NSString *) content Resource:(NSInteger) resource;

- (void) blockChatWithID:(NSInteger) uID ReceiverID:(NSInteger) receiverID;
- (void) unBlockChatWithID:(NSInteger) uID ReceiverID:(NSInteger) receiverID;
- (void) seenMessageWithID:(NSInteger) uID SenderID:(NSInteger) senderID RoomID:(NSString *) roomID mID:(NSString *) mID;

@end
