//
//  ChatListViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChatListViewController.h"
#import "AppDelegate.h"
#import "POP.h"
#import "UIColor+Extension.h"
#import "FlowerPersonView.h"
#import "UILabel+Extension.h"
#import "FlowerRelationViewController.h"
#import "AppHelper.h"
#import "ChatSettingViewController.h"

static const CGFloat EMOJI_MAX_SIZE = 28;
#define GIVER_LIMIT 5
#define ROOM_LIMIT 20
#define EXPAND_VIEW_HEIGHT 135
#define COLLAPSE_VIEW_HEIGHT 35
#define MESSAGE_EMPTY_VIEW_HEIGHT 100

@interface ChatListViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    
    NSMutableArray *giverListByRecently;
    NSMutableArray *giverListByFlower;
    NSMutableArray *receiverListByRecently;
    NSMutableArray *receiverListByFlower;
    NSMutableArray *followerList;
    NSMutableArray *followingList;
    
    NSMutableArray *giverViewFlowerPersonViews;
    NSMutableArray *receiverViewFlowerPersonViews;
    
    NSString *targetRoomID;
    room *targetRoom;
    BOOL hasNoRoom;
}
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    _roomsData = [[NSMutableArray alloc] init];
    giverListByRecently = [[NSMutableArray alloc] init];
    giverListByFlower = [[NSMutableArray alloc] init];
    receiverListByRecently = [[NSMutableArray alloc] init];
    receiverListByFlower = [[NSMutableArray alloc] init];
    giverViewFlowerPersonViews = [[NSMutableArray alloc] init];
    receiverViewFlowerPersonViews = [[NSMutableArray alloc] init];
    followerList = [[NSMutableArray alloc] init];
    followingList = [[NSMutableArray alloc] init];

    hasNoRoom = true;
    
    self.segmentControl.layer.cornerRadius = self.segmentControl.frame.size.height / 2;
    self.segmentControl.layer.borderWidth = 1.5;
    self.segmentControl.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
    self.segmentControl.clipsToBounds = true;
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.chatBadgeNumber setValue:0];
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[TabBarView class]])
        {
            _tabbar = (TabBarView*)view;
            break;
        }
    }
    
    [self initNavigationBar];
    _imagePhotoAPI = [[image_photo alloc] init];
    
    [self.roomTableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreRooms];
    }];
    
     [self loadRooms:@"" limit:ROOM_LIMIT];
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        [self loadFollower:@"time"];
        [self loadFollowing:@"time"];
    }
    else
    {
        [self loadFollower:@"flower"];
        [self loadFollowing:@"flower"];
    }
    
    if (![[SocketManager shareInstance] IsConnected]) {
         [[SocketManager shareInstance] handleNetworkReachability];
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLanguage];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.badgeNumber removeFromSuperview];
    
    [[SocketManager shareInstance] setIsConnectedResponse:^(NSError * error) {
        if (error) {
            [TTMessageView showMessageUnderNavBar:self Message:[AppHelper getLocalizedString:@"Socket.Error"]];
        }
    }];
    
    [[SocketManager shareInstance] setOnMessageReceive:^(message * data) {
        [self updateRoomWithMessage:data];
    }];
    
    [[SocketManager shareInstance] setOnMessageSendResponse:^(ChatStatus *status, BOOL success) {
        
    }];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.badgeNumber];
}


- (void)setupLanguage
{
    [self.labelTitleGiverView setText:[AppHelper getLocalizedString:@"chat.latestGivers"]];
    [self.labelTitleReceiverView setText:[AppHelper getLocalizedString:@"chat.latestReceivers"]];
    [self.labelMessages setText:NSLocalizedString(@"chat.messages", nil)];
    [self.labelEmptyMessage setText:NSLocalizedString(@"chat.emptymessage", nil)];
    [self.labelNoGiver setText:NSLocalizedString(@"chat.nogiver", nil)];
    [self.labelNoReceiver setText:NSLocalizedString(@"chat.noreceiver", nil)];
    [self.segmentControl setTitle:NSLocalizedString(@"chat.byflower", nil) forSegmentAtIndex:1];
    [self.segmentControl setTitle:NSLocalizedString(@"chat.recently", nil) forSegmentAtIndex:0];
}

- (void)loadRooms:(NSString*)roomID limit:(NSInteger)limit
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Rooms_Fetch *roomAPI = [[API_Rooms_Fetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] room_id:roomID limit:limit];
    [roomAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_rooms_fetch * data = (out_rooms_fetch *) jsonObject;
        if (response.status)
        {
            self.roomsData = data.roomsData;
            
            CGRect headerViewFrame = self.headerView.frame;
            
            if (self.roomsData.count != 0)
            {
                if (!hasNoRoom)
                {
                    headerViewFrame.size.height -= MESSAGE_EMPTY_VIEW_HEIGHT;
                    //                self.messageViewHeight.constant -= MESSAGE_EMPTY_VIEW_HEIGHT;
                    hasNoRoom = true;
                }
            }
            else
            {
                if (hasNoRoom)
                {
                    headerViewFrame.size.height += MESSAGE_EMPTY_VIEW_HEIGHT;
                    //                self.messageViewHeight.constant += MESSAGE_EMPTY_VIEW_HEIGHT;
                    hasNoRoom = false;
                }
            }
            
            [self.messageEmptyView setHidden:(self.roomsData.count != 0)];
            self.headerView.frame = headerViewFrame;
            [self.roomTableView reloadData];
        }
        else
        {
            
        }
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];

    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        CGRect headerViewFrame = self.headerView.frame;
        
        headerViewFrame.size.height += MESSAGE_EMPTY_VIEW_HEIGHT;
        
        [self.messageEmptyView setHidden:(self.roomsData.count != 0)];
        self.headerView.frame = headerViewFrame;
        [self.roomTableView reloadData];
    }];
    
}

- (void)loadFollower:(NSString*)sortType
{
    API_Profile_FollowerFetches *api = [[API_Profile_FollowerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] limit:GIVER_LIMIT sort:sortType];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_follower_fetches * data = (out_follower_fetches *) jsonObject;
        if (response.status)
        {
            if (data.followerList.count != 0)
            {
                self.giverEmptyView.hidden = true;
                
                if (self.segmentControl.selectedSegmentIndex == 0)
                {
                    giverListByRecently = data.followerList;
                }
                else
                {
                    giverListByFlower = data.followerList;
                }
                
                followerList = data.followerList;
                [self initGiverList:followerList];
            }
            else
            {
                self.giverEmptyView.hidden = false;
            }
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
         self.giverEmptyView.hidden = false;
    }];
}

- (void)loadFollowing:(NSString*)sortType
{
    API_Profile_FollowingFetches *api = [[API_Profile_FollowingFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] limit:GIVER_LIMIT sort:sortType];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_following_fetches * data = (out_following_fetches *) jsonObject;
        if (response.status)
        {
            if (data.followingList.count != 0)
            {
                self.receiverEmptyView.hidden = true;
                
                if (self.segmentControl.selectedSegmentIndex == 0)
                {
                    receiverListByRecently = data.followingList;
                }
                else
                {
                    receiverListByFlower = data.followingList;
                }
                
                followingList = data.followingList;
                [self initReceiverList:followingList];
            }
            else
            {
                self.receiverEmptyView.hidden = false;
            }
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        self.receiverEmptyView.hidden = false;
    }];

}

- (void)initGiverList:(NSMutableArray*)giverList
{
    CGFloat viewWidth = 60;
    NSInteger totalElements = giverList.count + 1;
    
    for (UIView* view in giverViewFlowerPersonViews)
    {
        [view removeFromSuperview];
    }
    
    [giverViewFlowerPersonViews removeAllObjects];
    
    for (NSInteger i = 0; i < totalElements; i++)
    {
        FlowerPersonView *flowerPersonView = (FlowerPersonView*)[[[NSBundle mainBundle] loadNibNamed:@"FlowerPersonView" owner:self options:nil] objectAtIndex:0];
        flowerPersonView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentViewGiverView addSubview:flowerPersonView];
        [giverViewFlowerPersonViews addObject:flowerPersonView];
        
        if (i == 0)
        {
            [self setupConstraintsForView:flowerPersonView previousView:nil isFirstView:true parentView:self.contentViewGiverView width:viewWidth spacing:10];
        }
        else
        {
            UIView *previousView = [giverViewFlowerPersonViews objectAtIndex: i - 1];
            [self setupConstraintsForView:flowerPersonView previousView:previousView isFirstView:false parentView:self.contentViewGiverView width:viewWidth spacing:10];
        }
        
        if (i == totalElements - 1)
        {
            flowerPersonView.othersView.hidden = false;
            flowerPersonView.labelName.text = [AppHelper getLocalizedString:@"chat.others"];
            flowerPersonView.button.tag = 0;
            
            [flowerPersonView.button addTarget:self action:@selector(touchButtonOthers:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            follower *data = (follower*)[giverList objectAtIndex:i];
            [flowerPersonView.avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
            flowerPersonView.labelName.text = data.name;
            [flowerPersonView.labelFlower setFlowers:data.flower imageString:@"Icon_Flower_Black"];
            flowerPersonView.labelFlower.hidden = data.flower > 0 ? NO : YES;
            flowerPersonView.button.tag = i * 2;
            
            [flowerPersonView.button addTarget:self action:@selector(touchButtonProfile:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.contentViewGiverViewWidth.constant = totalElements * viewWidth + ((totalElements + 1) * 10);
}

- (void)initReceiverList:(NSMutableArray*)receiverList
{
    CGFloat viewWidth = 60;
    NSInteger totalElements = receiverList.count + 1;

    for (UIView* view in receiverViewFlowerPersonViews)
    {
        [view removeFromSuperview];
    }
    
    [receiverViewFlowerPersonViews removeAllObjects];
    
    for (NSInteger i = 0; i < totalElements; i++)
    {
        FlowerPersonView *flowerPersonView = (FlowerPersonView*)[[[NSBundle mainBundle] loadNibNamed:@"FlowerPersonView" owner:self options:nil] objectAtIndex:0];
        flowerPersonView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentViewReceiverView addSubview:flowerPersonView];
        [receiverViewFlowerPersonViews addObject:flowerPersonView];
        
        if (i == 0)
        {
            [self setupConstraintsForView:flowerPersonView previousView:nil isFirstView:true parentView:self.contentViewReceiverView width:viewWidth spacing:10];
        }
        else
        {
            UIView *previousView = [receiverViewFlowerPersonViews objectAtIndex: i - 1];
            [self setupConstraintsForView:flowerPersonView previousView:previousView isFirstView:false parentView:self.contentViewReceiverView width:viewWidth spacing:10];
        }
        
        if (i == totalElements - 1)
        {
            flowerPersonView.othersView.hidden = false;
            flowerPersonView.labelName.text = [AppHelper getLocalizedString:@"chat.others"];
            flowerPersonView.button.tag = 1;
            
            [flowerPersonView.button addTarget:self action:@selector(touchButtonOthers:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            follower *data = (follower*)[receiverList objectAtIndex:i];
            [flowerPersonView.avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
            flowerPersonView.labelName.text = data.name;
            [flowerPersonView.labelFlower setFlowers:data.flower imageString:@"Icon_Flower_Black"];
            flowerPersonView.labelFlower.hidden = data.flower > 0 ? NO : YES;
            flowerPersonView.button.tag = i * 2 + 1;
            
            [flowerPersonView.button addTarget:self action:@selector(touchButtonProfile:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.contentViewReceiverWidth.constant = totalElements * viewWidth + ((totalElements + 1) * 10);
}

- (void)setupConstraintsForView:(UIView*)view previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView parentView:(UIView*)parentView width:(CGFloat)width spacing:(CGFloat)spacing
{
    NSLayoutConstraint *leftMargin = [[NSLayoutConstraint alloc] init];
    
    if (isFirstView)
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
    }
    else
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeRight multiplier:1 constant:spacing];
    }
    
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    
    [parentView addConstraints:@[topMargin, leftMargin, bottomMargin]];
    [view addConstraint:widthConstraint];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Chat", nil)];
    
    UIBarButtonItem *buttonSettings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon_Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(touchButtonSettings)];
    self.navigationItem.rightBarButtonItem = buttonSettings;
}

- (void)touchNotificationButton
{
    NotificationViewController *view = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    view.hidesBottomBarWhenPushed = TRUE;
    
    [self.navigationController pushViewController:view animated:TRUE];
}


- (void)loadMoreRooms
{
    NSString *lastRoomID = @"";
    
    if (self.roomsData.count != 0)
    {
        room *lastRoom = (room*)[self.roomsData lastObject];
        lastRoomID = lastRoom.room_id;
    }
    
    API_Rooms_Fetch *roomAPI = [[API_Rooms_Fetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] room_id:lastRoomID limit:ROOM_LIMIT];
    [roomAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [self.roomTableView.infiniteScrollingView stopAnimating];
        out_rooms_fetch * data = (out_rooms_fetch *) jsonObject;
        if (response.status)
        {
            [data.roomsData enumerateObjectsUsingBlock:^(room * obj, NSUInteger idx, BOOL * _Nonnull stop) {

                [self.roomTableView beginUpdates];
                [self.roomsData addObject:obj];
                NSIndexPath * index = [NSIndexPath indexPathForRow:self.roomsData.count- 1 inSection:0];
                [self.roomTableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                [self.roomTableView endUpdates];
            }];
            
        }
        
    } ErrorHandlure:^(NSError *error) {
         [self.roomTableView.infiniteScrollingView stopAnimating];
    }];

}

- (void) updateRoomWithMessage:(message *) message{
    if (message) {
        __block BOOL isExits = NO;
        [self.roomsData enumerateObjectsUsingBlock:^(room * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.room_id isEqualToString:message.room_id]) {
                obj.resource = message.resource;
                obj.body = message.body;
                obj.read = message.read;
                obj.timestamp = message.timestamp;
                [self.roomTableView beginUpdates];
                NSIndexPath * idx = [NSIndexPath indexPathForRow:[self.roomsData indexOfObject:obj] inSection:0];
                [self.roomTableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationNone];
                [self.roomTableView endUpdates];
                [self.roomsData removeObject:obj];
                [self.roomsData insertObject:obj atIndex:0];
                [self.roomTableView moveRowAtIndexPath:idx toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
                isExits = YES;
                *stop = YES;
            }
        }];
        
        if (!isExits) {
            room * newRoom = [[room alloc] init];
            newRoom.room_id = message.room_id;
            newRoom.screen_name = message.name;
            newRoom.avatar = message.avatar;
            newRoom.resource = message.resource;
            newRoom.body = message.body;
            newRoom.read = message.read;
            newRoom.timestamp = message.timestamp;
            newRoom.uid = message.sender_id;
            
            [self.roomsData insertObject:newRoom atIndex:0];
            
            [self.roomTableView beginUpdates];
            NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.roomTableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            [self.roomTableView endUpdates];
        }
    }
}

#pragma mark - UITableView
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor whiteColor] icon:[UIImage imageNamed:@"button_delete"] title:NSLocalizedString(@"Delete",nil) colorTitle:[UIColor colorWithRed:178/255.0 green:34/255.0 blue:37/255.0 alpha:1.0] ];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor whiteColor] icon:[UIImage imageNamed:@"icon_mark"] title:NSLocalizedString(@"Read",nil) colorTitle:[UIColor colorWithRed:178/255.0 green:34/255.0 blue:37/255.0 alpha:1.0] ];
    
    return rightUtilityButtons;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            NSLog(@"Delete button was pressed");
            NSIndexPath *cellIndexPath = [self.roomTableView indexPathForCell:cell];
            // update on server
            room *temp = (room*)[_roomsData objectAtIndex:cellIndexPath.row];
            targetRoom = temp;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"Are you sure you want to delete this chat?", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"No",nil)
                                                  otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
            [alert dismissWithClickedButtonIndex:0 animated:TRUE];
            [alert show];
            
            break;
        }
        case 1:
        {
            // Delete button was pressed
             NSLog(@"Read button was pressed");
            NSIndexPath *cellIndexPath = [self.roomTableView indexPathForCell:cell];
            // update on server
            room *temp = (room*)[_roomsData objectAtIndex:cellIndexPath.row];
            if(temp.read)
                return;
            targetRoom = temp;
            API_Room_MarkRead *api = [[API_Room_MarkRead alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] roomID:targetRoom.room_id];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if (response.status)
                {
                    
                    NSInteger index = [_roomsData indexOfObject:targetRoom];
                    room * readRoom =(room*) [_roomsData objectAtIndex:index];
                    readRoom.read = TRUE;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    SWTableViewCell *cell =( SWTableViewCell*)[self.roomTableView cellForRowAtIndexPath:indexPath];
                    [cell hideUtilityButtonsAnimated:YES];
                    
                    [self.roomTableView reloadData];
                    targetRoom = nil;
                    
                    //Update notiNumber in MyProfileVC
                    NSInteger notiNumber = [userDefaultManager getChatNotificationNumber] - 1;
                    [userDefaultManager saveChatNotificationNumber:notiNumber];
                }else{
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
            
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        API_Room_Delete *deleteCommentAPI = [[API_Room_Delete alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] roomID:targetRoom.room_id];
        [deleteCommentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                NSInteger index = [_roomsData indexOfObject:targetRoom];
                [_roomsData removeObjectAtIndex:index];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                
                [self.roomTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                targetRoom = nil;
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _roomsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ChatList";
    
    ChatListTableViewCell *cell = (ChatListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ChatListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    room *temp = (room *)[_roomsData objectAtIndex:indexPath.row];

    if ([temp.screen_name isKindOfClass:[NSNull class]])
    {
        temp.screen_name = @"";
    }
    
    if ([temp.user_name isKindOfClass:[NSNull class]])
    {
        temp.user_name = @"";
    }
    
    cell.name.text = temp.screen_name;
//    cell.username.text = temp.user_name;
    cell.rightUtilityButtons = [self rightButtons];
    
    cell.delegate = self;
    
    long long nFlower = [temp.body longLongValue] ;
    
    if (temp.body != nil)
    {
        switch (temp.resource) {
            case RES_TYPE_TEXT:{
                cell.message.text = temp.body;
//                [self replaceEmojiKeyByImageInLabel:cell.message];
            }
                break;
            case RES_TYPE_GIVE_FLOWER:
            {
                if(temp.sender_id != [userDefaultManager getUserProfileData].uid){
                    [cell.message setText:[NSString stringWithFormat:NSLocalizedString(@"%@ gave you %@ %@",nil), temp.screen_name, temp.body, nFlower>1?NSLocalizedString(@"flowers",nil):NSLocalizedString(@"flower",nil)]];
                } else {
                    [cell.message setText:[NSString stringWithFormat:NSLocalizedString(@"You gave %@ %@ to %@",nil),temp.body,nFlower>1?NSLocalizedString(@"flowers",nil):NSLocalizedString(@"flower",nil),temp.screen_name]];
                }
                
            }
                break;
            case RES_TYPE_STICKER:{
                if(temp.sender_id != [userDefaultManager getUserProfileData].uid){
                    [cell.message setText:[NSString stringWithFormat:NSLocalizedString(@"%@ sent a sticker",nil), temp.screen_name]];
                } else {
                    [cell.message setText:NSLocalizedString(@"You sent a sticker",nil)];
                }
            }
               
                break;
            default:
                break;
        }
        
    }
    else
    {
        cell.message.text = NSLocalizedString(@"Chat Unlocked!",nil);
    }
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp / 1000];
    cell.time.text = [date timeAgo];
    
    if (temp.read == 1)
    {
        [cell.notificationDot setHidden:TRUE];
        cell.message.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:13];
    }
    else
    {
        [cell.notificationDot setHidden:FALSE];
        cell.message.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:13];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    room *temp = (room*)[_roomsData objectAtIndex:indexPath.row];
    if (temp.read == 0) {
        temp.read = 1;
        NSInteger notiNumber = [userDefaultManager getChatNotificationNumber] - 1;
        [userDefaultManager saveChatNotificationNumber:notiNumber];
    }
    
    [self.roomTableView beginUpdates];
    NSIndexPath * idx = [NSIndexPath indexPathForRow:[self.roomsData indexOfObject:temp] inSection:0];
    [self.roomTableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationNone];
    [self.roomTableView endUpdates];
    ChatListTableViewCell *cell = (ChatListTableViewCell *)[_roomTableView cellForRowAtIndexPath:indexPath];
    [self gotoChatWithRoom:temp andAvatar:cell.avatar];
}

#pragma mark - Touch Events
- (IBAction)editChatSetting:(id)sender {
    ChatSettingViewController *view = [[ChatSettingViewController alloc] initWithNibName:@"ChatSettingViewController" bundle:nil];
    view.numFlower = [userDefaultManager getChatSetting];
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchViewAll:(id)sender {
    FlowerGiversListViewController *view = [[FlowerGiversListViewController alloc] initWithNibName:@"FlowerGiversListViewController" bundle:nil];
    view.mainView = self;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)gotoChatWithRoom:(room*) roomInfo andAvatar:(UIImageView*)avatar{

    ChatViewController *view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    view.delegate = self;
    view.uid = roomInfo.uid;
    view.roomID = roomInfo.room_id;
    view.screen_name = roomInfo.screen_name;
    //        view.isBlock = data.is_block_chat;
    //        view.isBlocked = data.is_blocked_chat;
    view.receiverAvatar = avatar;
    view.isChat = roomInfo.is_chat;
    view.blockMessage = roomInfo.blockMessage;
    view.destinationView = self;
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];

}

- (IBAction)touchTopGivers:(UIButton*)sender
{
    if(followerList.count <=0)
        return;
    follower *item = (follower *)[followerList objectAtIndex:sender.tag];
    UserProfileViewController *view;
    
    view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = item.uid;
    self.hidesBottomBarWhenPushed = FALSE;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)segmentControlValueChanged:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        [self.labelTitleGiverView setText:[AppHelper getLocalizedString:@"chat.latestGivers"]];
        [self.labelTitleReceiverView setText:[AppHelper getLocalizedString:@"chat.latestReceivers"]];
        
        if (giverListByRecently.count > 0)
        {
            followerList = giverListByRecently;
            followingList = receiverListByRecently;
            [self initGiverList:followerList];
            [self initReceiverList:followingList];
        }
        else
        {
            [self loadFollower:@"time"];
            [self loadFollowing:@"time"];
        }
    }
    else
    {
        [self.labelTitleGiverView setText:[AppHelper getLocalizedString:@"chat.topgivers"]];
        [self.labelTitleReceiverView setText:[AppHelper getLocalizedString:@"chat.topreceivers"]];
        
        if (giverListByFlower.count > 0)
        {
            followerList = giverListByFlower;
            followingList = receiverListByFlower;
            [self initGiverList:followerList];
            [self initReceiverList:followingList];
        }
        else
        {
            [self loadFollower:@"flower"];
            [self loadFollowing:@"flower"];
        }
    }
}

- (IBAction)touchButtonCollapse:(id)sender
{
    UIButton *button = (UIButton*)sender;
    CGRect headerViewFrame = self.headerView.frame;

    if (button.tag == 0)
    {
        if (self.giverViewHeight.constant == EXPAND_VIEW_HEIGHT)
        {
            self.giverViewHeight.constant = COLLAPSE_VIEW_HEIGHT;
            headerViewFrame.size.height -= EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            self.flowerViewHeight.constant -= EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            [button setImage:[UIImage imageNamed:@"Icon_Expand"] forState:UIControlStateNormal];
        }
        else
        {
            self.giverViewHeight.constant = EXPAND_VIEW_HEIGHT;
            headerViewFrame.size.height += EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            self.flowerViewHeight.constant += EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            [button setImage:[UIImage imageNamed:@"Icon_Collapse"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if (self.receiverViewHeight.constant == EXPAND_VIEW_HEIGHT)
        {
            self.receiverViewHeight.constant = COLLAPSE_VIEW_HEIGHT;
            headerViewFrame.size.height -= EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            self.flowerViewHeight.constant -= EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            [button setImage:[UIImage imageNamed:@"Icon_Expand"] forState:UIControlStateNormal];
        }
        else
        {
            self.receiverViewHeight.constant = EXPAND_VIEW_HEIGHT;
            headerViewFrame.size.height += EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            self.flowerViewHeight.constant += EXPAND_VIEW_HEIGHT - COLLAPSE_VIEW_HEIGHT;
            [button setImage:[UIImage imageNamed:@"Icon_Collapse"] forState:UIControlStateNormal];
        }
    }
    
    self.headerView.frame = headerViewFrame;
    self.roomTableView.tableHeaderView = self.headerView;
}

// MARK: - Selectors
- (void)touchButtonSettings
{
    ChatSettingViewController *view = [[ChatSettingViewController alloc] initWithNibName:@"ChatSettingViewController" bundle:nil];
    view.numFlower = [userDefaultManager getChatSetting];
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)touchButtonOthers:(id)sender
{
    UIButton *button = (UIButton*)sender;
    FlowerRelationViewController *flowerRelationViewController = [[FlowerRelationViewController alloc] initWithNibName:@"FlowerRelationViewController" bundle:nil];
    flowerRelationViewController.tabIndex = self.segmentControl.selectedSegmentIndex;
    
    if (button.tag == 0)
    {
        flowerRelationViewController.isFollower = true;
    }
    else
    {
        flowerRelationViewController.isFollower = false;
    }
    
    [self.navigationController pushViewController:flowerRelationViewController animated:true];
}

- (void)touchButtonProfile:(id)sender
{
    UIButton *button = (UIButton*)sender;
    follower *data = [[follower alloc] init];
    FlowerPersonView *flowerPersonView = [[FlowerPersonView alloc] init];
    
    if (button.tag % 2 == 0)
    {
        data = (follower*)[followerList objectAtIndex:button.tag / 2];
        flowerPersonView = (FlowerPersonView*)[giverViewFlowerPersonViews objectAtIndex:button.tag / 2];
    }
    else
    {
        data = (follower*)[followingList objectAtIndex:(button.tag - 1) / 2];
        flowerPersonView = (FlowerPersonView*)[receiverViewFlowerPersonViews objectAtIndex:(button.tag - 1) / 2];
    }
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_ProfileFetch *api = [[API_ProfileFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] andUserId:@(data.uid).stringValue];
    
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        ChatViewController *view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        view.delegate = self;
        view.uid = data.uid;
        view.screen_name = data.name;
        view.isChat = data.is_chat;
        view.receiverAvatar = flowerPersonView.avatar;
        view.hidesBottomBarWhenPushed = TRUE;
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [self.navigationController pushViewController:view animated:TRUE];

    } ErrorHandlure:^(NSError * error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
    

}

//MARK: - ChatViewControllerDelegate
- (void)chatViewController_UpdateListMessageWith:(message *)message{
    
    API_Rooms_Fetch *roomAPI = [[API_Rooms_Fetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] room_id:@"" limit:ROOM_LIMIT];
    [roomAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_rooms_fetch * data = (out_rooms_fetch *) jsonObject;
        if (response.status)
        {
            [self.roomsData removeAllObjects];
            self.roomsData = data.roomsData;
            [self.roomTableView reloadData];
        }
        
    } ErrorHandlure:^(NSError *error) {
        
    }];
    
}

- (void)chatViewController_DeleteRoomWithID:(NSString *)roomID{
    [self.roomsData enumerateObjectsUsingBlock:^(room * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.room_id isEqualToString:roomID]) {
            NSIndexPath * index = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.roomTableView beginUpdates];
            [self.roomsData removeObject:obj];
            [self.roomTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            [self.roomTableView endUpdates];
            
            *stop = YES;
        }
    }];
}

@end
