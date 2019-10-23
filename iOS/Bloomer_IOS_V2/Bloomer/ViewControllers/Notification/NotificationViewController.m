//
//  NotificationViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "NotificationViewController.h"

#define CELL_HEIGHT 60

@interface NotificationViewController ()
{
    UserDefaultManager* userDefaultManager;
    out_profile_fetch* profileData;
    NSString* notificationID;
    NSInteger offset;
    NSMutableArray* dataFormaketing;

    NSString* deepLink;
    
    NSMutableArray* nomalMaketing;
    
    NSInteger idPoupNoti;
    NSInteger typePopupNoti;
    
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nomalMaketing = [[NSMutableArray alloc] init];
    
    deepLink = @"";
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    _imagePhotoAPI = [[image_photo alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    self.notificationData = [[NSMutableArray alloc] init];
    notificationID = @"";
    
    offset = 0;
    /*
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[MKNumberBadgeView class]])
        {
            _badgeNumber = (MKNumberBadgeView *)view;
            break;
        }
    }
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[TabBarView class]])
        {
            _tabbar = (TabBarView*)view;
            break;
        }
    }
    
    [_badgeNumber setValue:0];
    */
    [userDefaultManager saveNotificationNumber:0];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateShowingNofitication];
    
    [self initNavigationBar];
    [self loadNotiMaketing];

    __weak NotificationViewController *weakSelf = self;
    [_notificationTableView addPullToRefreshWithActionHandler:^{
        [weakSelf pullToRefresh];
    }];
    
    [_notificationTableView addInfiniteScrollingWithActionHandler:^{
        if (weakSelf)
        {
            [weakSelf handleInfiniteScrolling];
        }
    }];
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    notificationID = @"";
//    [_notificationData removeAllObjects];
//    [self loadNotiMaketing];
//}

-(void) checkingBonus
{
    if([userDefaultManager getIsEventPayment] == true)
    {
        [self.BonusInfoView setHidden:false];
        self.iconBonus.layer.cornerRadius = self.iconBonus.frame.size.width / 2;
        self.iconBonus.clipsToBounds = TRUE;
        self.iconBonus.image = [UIImage imageNamed:@"app-icon-40"];
        self.BonusInfoView.layer.masksToBounds = NO;
        self.BonusInfoView.layer.shadowOffset = CGSizeMake(0, 1);
        self.BonusInfoView.layer.shadowRadius = 2;
        self.BonusInfoView.layer.shadowOpacity = 0.5;
        self.BonusInfoView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.BonusInfoView.bounds].CGPath;
        
        NSError *err = nil;
        _ContentBonus.numberOfLines = 0;
        NSString *htmlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<font style='font-size:12px;font-family:SourceSansPro-Light'>%@</font>",[userDefaultManager getNotiEventContent]]];
        _ContentBonus.attributedText =
        [[NSAttributedString alloc]
         initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
         options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
         documentAttributes: nil
         error: &err];
        if(err)
            NSLog(@"Unable to parse label text: %@", err);
        
    }
    else
    {
        [self.BonusInfoView setHidden:true];
        
        NSLayoutConstraint* NewTableCostraint = [NSLayoutConstraint constraintWithItem:_notificationTableView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1
                                                                              constant:0];
        [self.view addConstraint:NewTableCostraint];
        [self.view layoutIfNeeded];
    }

    

}

//- (void)viewWillAppear:(BOOL)animated {
//    [_badgeNumber setFrame:CGRectMake(223, 18, 60, 20)];
//}

- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController == self);
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Notifications", nil)];
}

- (void) touchSettingsButton
{
//    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[SettingsViewController class]])
//    {
//        [self.navigationController popViewControllerAnimated:TRUE];
//    }
//    else
//    {
//        SettingsViewController *view;
//        if (IS_IPHONE_5)
//        {
//            view = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//        }
//        else
//            if (IS_IPHONE_4)
//            {
//                view = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_ip4" bundle:nil];
//            }
        
//        view.hidesBottomBarWhenPushed = TRUE;
//        [self.navigationController pushViewController:view animated:TRUE];
//    }
}

-(void) loadNotiMaketing
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_NotiMarketing *request = [[API_NotiMarketing alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if(data.status) {
            JSON_PopUpMarketing *model = (JSON_PopUpMarketing*)json;
            dataFormaketing = model.popUps;
            
            BOOL isPin = false;
            
            for(NSInteger i = 0; i < dataFormaketing.count; i++)
            {
                PopUpMarketing *popUp = (PopUpMarketing*)[dataFormaketing objectAtIndex:i];

                if(popUp.type == 2 || popUp.type == 4)
                {
                    idPoupNoti = popUp.ID;
                    typePopupNoti = popUp.type;
                    [self.BonusInfoView setHidden:false];
                    self.iconBonus.layer.cornerRadius = self.iconBonus.frame.size.width / 2;
                    self.iconBonus.clipsToBounds = TRUE;
                    self.iconBonus.image = [UIImage imageNamed:@"app-icon-40"];
//                    self.BonusInfoView.layer.masksToBounds = NO;
//                    self.BonusInfoView.layer.shadowOffset = CGSizeMake(0, 1);
//                    self.BonusInfoView.layer.shadowRadius = 2;
//                    self.BonusInfoView.layer.shadowOpacity = 0.5;
//                    self.BonusInfoView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.BonusInfoView.bounds].CGPath;
                    
                    NSError *err = nil;
                    _ContentBonus.numberOfLines = 0;
                    NSString *htmlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<font style='font-size:14px;font-family:SourceSansPro-Bold'>%@</font>", popUp.bodyText]];
                    _ContentBonus.attributedText =
                    [[NSAttributedString alloc]
                     initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                     documentAttributes: nil
                     error: &err];
                    _ContentBonus.textColor = [UIColor whiteColor];
                    if(err)
                        NSLog(@"Unable to parse label text: %@", err);
                    deepLink = popUp.bodyLink;
                    isPin = true;
                    _labelSeeMore.text = NSLocalizedString(@"Notification.seeMorePinPopup",);
                    
                }
                else if(popUp.type == 1)
                {
                    notification* temp = [[notification alloc] init];
                    
                    temp.normalMaketNoti = [[normal_maketing_noti alloc] init];
                    
                    temp.type = NOTIFICATION_TYPE_NORMAL_MARKET;
                    
                    temp.timestamp = [popUp.startDate timeIntervalSince1970] * 1000;
                    
                    temp.message = popUp.bodyText;
                    
                    temp.normalMaketNoti.deepLink = popUp.bodyLink;
                    
                    [nomalMaketing addObject:temp];
                }
                
            }
            
            if(isPin == false)
            {
                [self.BonusInfoView setHidden:true];
                
                NSLayoutConstraint* NewTableCostraint = [NSLayoutConstraint constraintWithItem:_notificationTableView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeTop
                                                                                    multiplier:1
                                                                                      constant:0];
                [self.view addConstraint:NewTableCostraint];
                [self.view layoutIfNeeded];
            }
        }
        [self loadNotificationUsingAPI];
    } ErrorHandlure:^(NSError *error) {
        [_notificationTableView.pullToRefreshView stopAnimating];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [self loadNotificationUsingAPI];
    }];
}
- (IBAction)exitNotification:(id)sender {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_DeletePopupNoti *request = [[API_DeletePopupNoti alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_id:[userDefaultManager getDeviceToken] noti_id:idPoupNoti addType:typePopupNoti];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if(data.status) {
            [self.BonusInfoView setHidden:true];
            
            NSLayoutConstraint* NewTableCostraint = [NSLayoutConstraint constraintWithItem:_notificationTableView
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1
                                                                                  constant:0];
            [self.view addConstraint:NewTableCostraint];
            [self.view layoutIfNeeded];
        }else
        {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }
    }ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
    
    

}

- (void)loadNotificationUsingAPI
{
    API_Notification_Fetch *notificationAPI = [[API_Notification_Fetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                         device_token:[userDefaultManager getDeviceToken]
                                                                                      notification_id:notificationID];
    [notificationAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
         [_notificationTableView.infiniteScrollingView stopAnimating];
        out_notification_fetch * data = (out_notification_fetch *) jsonObject;
        [_notificationTableView.pullToRefreshView stopAnimating];
        if (response.status)
        {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            
            if (offset == 0)
            {
                [self addNormalNoti:data.notifications];

                [data.notifications enumerateObjectsUsingBlock:^(notification*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_notificationTableView beginUpdates];
                    [_notificationData addObject:obj];
                    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [_notificationTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [_notificationTableView endUpdates];
                }];
                
                offset += 10;
            }
            else
            {
                if (data.notifications.count != 0)
                {
                    [self addNormalNoti:data.notifications];
                    
                    [data.notifications enumerateObjectsUsingBlock:^(notification*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [_notificationTableView beginUpdates];
                        [_notificationData addObject:obj];
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_notificationData.count-1 inSection:0];
                        [_notificationTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [_notificationTableView endUpdates];
                    }];
                    
                    if (data.notifications.count != 10)
                        offset -= 10 - data.notifications.count;
                    
                    offset += 10;
                }
            }
            //        notificationID = ((notification*)[data.notifications lastObject]).notification_id;
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [_notificationTableView.pullToRefreshView stopAnimating];
    }];
}

-(void) addNormalNoti:(NSMutableArray*) notifications
{
    NSInteger n = nomalMaketing.count;
    for(NSInteger i = n - 1; i >= 0; i--)
    {
        notification*temp = (notification*)[nomalMaketing objectAtIndex:i];
        NSInteger m = notifications.count;
        for(NSInteger j = 0; j < m ; j ++)
        {
            notification* temp2 = (notification*)[notifications objectAtIndex:j];
            if(temp.timestamp > temp2.timestamp)
            {
                [notifications insertObject:temp atIndex:j];
                [nomalMaketing removeObjectAtIndex:i];
                break;
            }
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _notificationData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Notification";
    
    NotificationTableViewCell *cell = (NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.delegate = self;
    
    notification *temp = (notification *)[_notificationData objectAtIndex:indexPath.row];
    
    cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2;
    cell.avatar.clipsToBounds = TRUE;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp/1000];
    cell.time.text = [date timeAgo];
    
    switch (temp.type) {
        case NOTIFICATION_TYPE_FLOWER_PHOTO:
        {
            cell.noti = temp;
            
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.photoContent.giver_avatar]];
            
            cell.contentWidth.constant = 1.0 * [UIScreen mainScreen].bounds.size.width / 320 * 216;
            [cell layoutIfNeeded];
            [cell.photo setHidden:NO];
            [cell.photo sd_setImageWithURL:[NSURL URLWithString:temp.photoContent.photo_url]];
            
            [cell.AvatarButton setHidden:false];
            [cell.ContentButton setHidden:false];
            [cell.imageButton setHidden:false];
            cell.myNavigationController = self.navigationController;
        }
            break;
        case NOTIFICATION_TYPE_FLOWER_RACE:
        {
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.raceContent.giver_avatar]];
            [cell.LinkImage setHidden:NO];
        }
            break;
        case NOTIFICATION_TYPE_FLOWER_AVATAR:
        {
            cell.noti = temp;
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatarContent.giver_avatar]];
            
            [cell.AvatarButton setHidden:false];
            
            cell.myNavigationController = self.navigationController;
            
            break;
        }
        case NOTIFICATION_TYPE_FLOWER_DAILY:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_COMMENT:
        {
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.commentContent.commenter_avatar]];
            
            cell.contentWidth.constant = 1.0 * [UIScreen mainScreen].bounds.size.width / 320 * 220;
            [cell layoutIfNeeded];
            [cell.photo setHidden:NO];
            [cell.photo sd_setImageWithURL:[NSURL URLWithString:temp.commentContent.photo_url]];
            break;
        }
        case NOTIFICATION_TYPE_TOP_RANK:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_SPECIAL_RACE_OPENED:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_EVENT_RACE_OPENED:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_SPONSOR_RACE_OPENED:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_MONTHLY_CLOSED_1DAY:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            [cell.content setText:[NSString stringWithFormat:NSLocalizedString(@"The monthly Contests finish tomorrow! Get some flowers!",)]];
            break;
        }
        case NOTIFICATION_TYPE_UNLOCK_CHAT:
        {
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.chatContent.model_avatar]];
            
            cell.contentWidth.constant = 1.0 * [UIScreen mainScreen].bounds.size.width / 320 * 220;
            [cell layoutIfNeeded];
            [cell.ChatIcon setHidden:NO];
            cell.ChatIcon.image = [UIImage imageNamed:@"Btn_Chattoothers"];
        }
            break;
        case NOTIFICATION_TYPE_LEADERBOARD_RESULT:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            [cell.content setText:[NSString stringWithFormat:NSLocalizedString(@"Check out the results of %@ for all the Contest!",),temp.leadrerboardResultContent.monthly_time]];
        }
            break;
        case NOTIFICATION_TYPE_TOP_COUNTRY:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            cell.contentWidth.constant = 1.0 * [UIScreen mainScreen].bounds.size.width / 320 * 170;
            [cell layoutIfNeeded];
            cell.shareView.hidden = false;
            cell.myNavigationController = self.navigationController;
            cell.noti = temp;
            [cell setShareState:!temp.topCountry.is_share];
            break;
        }
        case NOTIFICATION_TYPE_WELCOME_GSB:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            cell.contentWidth.constant = 1.0 * [UIScreen mainScreen].bounds.size.width / 320 * 170;
            [cell layoutIfNeeded];
            cell.shareView.hidden = false;
            cell.myNavigationController = self.navigationController;
            cell.noti = temp;
            [cell setShareState:!temp.welcomeGSB.is_share];
            break;
        }
        case NOTIFICATION_TYPE_INVITEE_RECEIVE_FLOWER:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_INVITER_RECEIVE_FLOWER:
        {
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.inviterReceive.avatar]];
            break;
        }
            
        case NOTIFICATION_TYPE_SHARE:
        {
            
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        case NOTIFICATION_TYPE_PAYMENT:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
        default:
        {
            cell.avatar.image = [UIImage imageNamed:@"app-icon-40"];
            break;
        }
    }
    
    NSError *err = nil;
    NSString *htmlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<font style='font-size:12px;font-family:SourceSansPro-Light'>%@</font>", temp.message]];
    cell.content.attributedText =
    [[NSAttributedString alloc]
     initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    notification *temp = (notification*)[_notificationData objectAtIndex:indexPath.row];
    switch (temp.type) {
        case NOTIFICATION_TYPE_FLOWER_RACE:
        {
            /// Open New List Of Notification.
            FlowerGiverViewController *viewController = [[FlowerGiverViewController alloc] initWithNibName:@"FlowerGiverViewController" bundle:nil];
            viewController.notificationKey = temp.raceContent.noti_key;
            viewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:viewController animated:true];
            
            break;
        }
            break;
        case NOTIFICATION_TYPE_FLOWER_AVATAR:
        {
            FlowerGiverViewController *viewController = [[FlowerGiverViewController alloc] initWithNibName:@"FlowerGiverViewController" bundle:nil];
            viewController.notificationKey = @"profile";
            viewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:viewController animated:true];
            
             break;
        }
            break;
        case NOTIFICATION_TYPE_COMMENT:
        {
            FullPictureViewController *view;
            view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
            
            gallery* gallerypost = [[gallery alloc]init];
            gallerypost.post_id = temp.commentContent.post_id;
            gallerypost.photo_url = [temp.commentContent.photo_url stringByReplacingOccurrencesOfString:@"-s." withString:@"-l."];//temp.commentContent.photo_url;
            
            view.post_id = temp.commentContent.post_id;
            view.isScrollingEnabled = FALSE;
            view.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
            view.currentIndex = 0;
            
            [self.navigationController pushViewController:view animated:TRUE];
            break;
        }
        case NOTIFICATION_TYPE_TOP_RANK:
        {
            RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            view.key = temp.topRankContent.race_key;
            view.hidesBottomBarWhenPushed = FALSE;
            [self.navigationController pushViewController:view animated:YES];
            
            break;
        }
        case NOTIFICATION_TYPE_SPECIAL_RACE_OPENED:
        {
            RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            view.key = temp.specialContent.race_key;
            view.gender = [userDefaultManager getGender];
            view.hidesBottomBarWhenPushed = FALSE;
            [self.navigationController pushViewController:view animated:YES];
//            [AppDelegate setSelectedIndexTabbar:1];
            break;
        }
        case NOTIFICATION_TYPE_EVENT_RACE_OPENED:
        {
            RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            view.key = temp.eventContent.race_key;
            view.gender = [userDefaultManager getGender];
            view.hidesBottomBarWhenPushed = FALSE;
            [self.navigationController pushViewController:view animated:YES];
//            [AppDelegate setSelectedIndexTabbar:1];
            break;
        }
        case NOTIFICATION_TYPE_SPONSOR_RACE_OPENED:
        {
            RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            view.key = temp.sponsorContent.race_key;
            view.gender = [userDefaultManager getGender];
           view.hidesBottomBarWhenPushed = FALSE;
            [self.navigationController pushViewController:view animated:YES];
//            [AppDelegate setSelectedIndexTabbar:1];
            break;
        }
        case NOTIFICATION_TYPE_MONTHLY_CLOSED_1DAY:
        {
            RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            view.key = temp.monthlyContent.race_key;
            view.hidesBottomBarWhenPushed = FALSE;
            [self.navigationController pushViewController:view animated:YES];
//            [AppDelegate setSelectedIndexTabbar:1];
            break;
        }
        case NOTIFICATION_TYPE_UNLOCK_CHAT:
        {
            NotificationTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            API_ProfileFetch *api = [[API_ProfileFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] andUserId:@(temp.chatContent.model_ID).stringValue];
            
            [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
                out_profile_fetch * data = (out_profile_fetch *) json;
                ChatViewController *view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                view.uid = temp.chatContent.model_ID;
                view.screen_name = temp.chatContent.model_name;
//                view.isBlock = data.is_block_chat;
//                view.isBlocked = data.is_blocked_chat;
                view.isChat = true;
                
                UIImageView * imgAvatar = [[UIImageView alloc] initWithImage:cell.avatar.image];
                [view setReceiverAvatar:imgAvatar];
                
                view.hidesBottomBarWhenPushed = TRUE;
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                [self.navigationController pushViewController:view animated:TRUE];

            } ErrorHandlure:^(NSError * error) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }];
            
            
        }
            break;
        case NOTIFICATION_TYPE_LEADERBOARD_RESULT:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.leadrerboardResultContent.result_link]];
            break;
//        case NOTIFICATION_TYPE_TOP_COUNTRY:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.topCountry.url]];
//            break;
//        case NOTIFICATION_TYPE_WELCOME_GSB:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp.welcomeGSB.url]];
//            break;
        case NOTIFICATION_TYPE_INVITER_RECEIVE_FLOWER:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            view.uid = temp.inviterReceive.uid;
            view.hidesBottomBarWhenPushed = NO;
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case NOTIFICATION_TYPE_FLOWER_DAILY:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            MyProfileViewController* view = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
            [_tabbar snapbackFlowerIconToTabbar];
            
            [self.navigationController pushViewController:view animated:TRUE];
        }
            break;
        case NOTIFICATION_TYPE_NORMAL_MARKET:
        {
            if([temp.normalMaketNoti.deepLink isEqualToString:@""]) return;
            BrowserViewController *browserview = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
            browserview.urlString = temp.normalMaketNoti.deepLink;
            browserview.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:browserview animated:true];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    notification *temp = (notification*)[_notificationData objectAtIndex:indexPath.row];
    /*
    NSString * htmlString = [NSString stringWithFormat:@"<font style='font-size:18px'>%@</font>", temp.message];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    CGFloat height = [attrStr boundingRectWithSize:CGSizeMake(250, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    CGFloat finalHeight = CELL_HEIGHT - 30 + height;
    
    if (finalHeight > CELL_HEIGHT)
        return finalHeight + 10;
    
    return CELL_HEIGHT;
     */
    return 90;
}

- (void) pullToRefresh{
    notificationID = @"";

    API_NotiMarketing *request = [[API_NotiMarketing alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if(data.status) {
            JSON_PopUpMarketing *model = (JSON_PopUpMarketing*)json;
            dataFormaketing = model.popUps;
            
            BOOL isPin = false;
            
            for(NSInteger i = 0; i < dataFormaketing.count; i++)
            {
                PopUpMarketing *popUp = (PopUpMarketing*)[dataFormaketing objectAtIndex:i];
                
                if(popUp.type == 2 || popUp.type == 4)
                {
                    idPoupNoti = popUp.ID;
                    typePopupNoti = popUp.type;
                    [self.BonusInfoView setHidden:false];
                    self.iconBonus.layer.cornerRadius = self.iconBonus.frame.size.width / 2;
                    self.iconBonus.clipsToBounds = TRUE;
                    self.iconBonus.image = [UIImage imageNamed:@"app-icon-40"];
                    
                    NSError *err = nil;
                    _ContentBonus.numberOfLines = 0;
                    NSString *htmlString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<font style='font-size:14px;font-family:SourceSansPro-Bold'>%@</font>", popUp.bodyText]];
                    _ContentBonus.attributedText =
                    [[NSAttributedString alloc]
                     initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                     documentAttributes: nil
                     error: &err];
                    _ContentBonus.textColor = [UIColor whiteColor];
                    if(err)
                        NSLog(@"Unable to parse label text: %@", err);
                    deepLink = popUp.bodyLink;
                    isPin = true;
                    _labelSeeMore.text = NSLocalizedString(@"Notification.seeMorePinPopup",);
                    
                }
                else if(popUp.type == 1)
                {
                    notification* temp = [[notification alloc] init];
                    
                    temp.normalMaketNoti = [[normal_maketing_noti alloc] init];
                    
                    temp.type = NOTIFICATION_TYPE_NORMAL_MARKET;
                    
                    temp.timestamp = [popUp.startDate timeIntervalSince1970] * 1000;
                    
                    temp.message = popUp.bodyText;
                    
                    temp.normalMaketNoti.deepLink = popUp.bodyLink;
                    
                    [nomalMaketing addObject:temp];
                }
                
            }
            
            if(isPin == false)
            {
                [self.BonusInfoView setHidden:true];
                
                NSLayoutConstraint* NewTableCostraint = [NSLayoutConstraint constraintWithItem:_notificationTableView
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.view
                                                                                     attribute:NSLayoutAttributeTop
                                                                                    multiplier:1
                                                                                      constant:0];
                [self.view addConstraint:NewTableCostraint];
                [self.view layoutIfNeeded];
            }
        }
        offset = 0;
        [_notificationData removeAllObjects];
        [_notificationTableView reloadData];
        [self loadNotificationUsingAPI];
    } ErrorHandlure:^(NSError *error) {
        [_notificationTableView.pullToRefreshView stopAnimating];
    }];
}


- (void)handleInfiniteScrolling
{
    if (_notificationData.count != 0)
    {
        notification *temp = (notification*)[_notificationData objectAtIndex:_notificationData.count - 1];
        notificationID = temp.notification_id;
    }
    else
    {
        notificationID = @"";
    }
    
    [self loadNotificationUsingAPI];
   
}

- (IBAction)OpenShop:(id)sender {
    if([deepLink isEqualToString:@""]) return;
    BrowserViewController *browserview = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserview.urlString = deepLink;
    browserview.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserview animated:true];
    
}

//MARK: - NotificationCellDelegate
- (void)shareNotificationSuccess:(NSString *)notificationID type:(NotificationType)type{
    [_notificationData enumerateObjectsUsingBlock:^(notification *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.notification_id isEqualToString:notificationID]) {
            switch (type) {
                case NOTIFICATION_TYPE_TOP_COUNTRY:
                    [obj.topCountry setIs_share:YES];
                    break;
                case NOTIFICATION_TYPE_WELCOME_GSB:
                    [obj.welcomeGSB setIs_share:YES];
                    break;
                default:
                    break;
            }
            *stop = YES;
        }
    }];
    
}

@end
