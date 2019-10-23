//
//  CommentViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/28/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "CommentViewController.h"
#import "FullPictureViewController.h"
#import "AppDelegate.h"
#import "AppHelper.h"

#define CAPTION_VIEW_HEIGHT 50
#define CELL_HEIGHT 60

@interface CommentViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSString* comment_id;
    Spinner *spinner;
    NSString* s_placeholder;
    BOOL isReloadParent;

}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    self.imagePhotoAPI = [[image_photo alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    self.commentData = [[NSMutableArray alloc] init];
    self.isLoading = false;
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[TabBarView class]])
        {
            _tabbar = (TabBarView *)view;
            break;
        }
    }
    
    self.commentTextView.layer.cornerRadius = self.commentTextView.frame.size.height / 2;
    self.commentTextView.clipsToBounds = TRUE;
    self.doneButton.layer.cornerRadius = self.doneButton.frame.size.height / 2;
    self.doneButton.clipsToBounds = TRUE;

    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:CommentTableViewCell.cellIdentifier];
    
    spinner = ((AppDelegate *)[UIApplication sharedApplication].delegate).spinner;
    
    s_placeholder = NSLocalizedString(@"Say something...", @"Say something...") ;
    [_commentTextView setPlaceholder:s_placeholder];
    isReloadParent = false;
    [self setUpLoadMoreView];
    [self initNavigationBar];
    [self loadCommentUsingAPI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.badgeNumber removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.badgeNumber];
    
    if ([_parentView isKindOfClass:[FullPictureViewController class]] && isReloadParent)
    {
        FullPictureViewController *view = (FullPictureViewController*)_parentView;
        [view loadContentPost];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Comments", @"Comments")];
}

- (void)showLoadMoreView:(BOOL)isHidden {
    [self.loadMoreView setHidden:isHidden];
}

- (void)setUpLoadMoreView {
    self.loadMoreView.layer.cornerRadius = self.loadMoreView.frame.size.height / 2;
    self.loadMoreView.layer.masksToBounds = NO;
    
    self.loadMoreView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loadMoreView.layer.shadowOffset = CGSizeMake(0, 5.0f);
    self.loadMoreView.layer.shadowRadius = 1.5f;
    self.loadMoreView.layer.shadowOpacity = 0.2;

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousComments)];
    [singleFingerTap setNumberOfTapsRequired:1];
    
    [self.loadMoreView addGestureRecognizer:singleFingerTap];
}

- (void)loadPreviousComments {
    if (_commentData.count > 0 && self.isLoading == false) {
        self.isLoading = true;
        comment* lastComment = (comment *)_commentData[0];
        [self loadCommentUsingAPIByCommentID:lastComment.comment_id];
    }
}

- (float)calculateLabelHeight:(NSString*)text font:(UIFont*)font lineBreakMode:(NSLineBreakMode)mode
{
    if (SYSTEM_VERSION_LESS_THAN(@"7")){
        CGSize maximumLabelSize = CGSizeMake(242, FLT_MAX);
        CGSize expectedLabelSize = [text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:mode];
        
        return expectedLabelSize.height;
    } else {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:text
                                        attributes:@{NSFontAttributeName: font}];
        CGRect expectedLabelSize = [attributedText boundingRectWithSize:(CGSize){242, CGFLOAT_MAX}
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                context:nil];
        return expectedLabelSize.size.height;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = CommentTableViewCell.cellIdentifier;
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    comment *temp = (comment *)[_commentData objectAtIndex:indexPath.row];
    
    cell.labelContent.text = temp.content;
    cell.labelName.text = temp.name;
    cell.labelUsername.text = temp.username;
    [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
    
    cell.uid = temp.uid;
    cell.navigationController = self.navigationController;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CommentTableViewCell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.post_UserID == profileData.uid)
    {
        return YES;
    }
    else
    {
        comment *temp = (comment*)[_commentData objectAtIndex:indexPath.row];
        
        if (temp.uid == profileData.uid)
        {
            return true;
        }
        
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_commentData.count > 0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
        comment *temp = (comment*)[_commentData objectAtIndex:indexPath.row];
        comment_id = temp.comment_id;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Are you sure you want to delete this comment?",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"No",nil)
                                              otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
        [alert dismissWithClickedButtonIndex:0 animated:TRUE];
        [alert show];
    }
}

- (void)scrollToBottom
{
    if (self.commentData.count > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        API_Post_Comment_Delete *deleteCommentAPI = [[API_Post_Comment_Delete alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                            device_token:[userDefaultManager getDeviceToken]
                                                                                                 post_id:_post_id
                                                                                              comment_id:comment_id];
        [deleteCommentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                for (comment* com in self.commentData)
                {
                    if (com.comment_id == comment_id)
                    {
                        [self.commentData removeObject:com];
                        [self.tableView reloadData];
                        [self scrollToBottom];
                        break;
                    }
                }
                isReloadParent = true;
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
                if (response.code == 480)
                {
                    [self reloadPreviousPage];
                }
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
        
    }
}


- (void)loadCommentUsingAPI
{
    [self loadCommentUsingAPIByCommentID:@""];
}

- (void)loadCommentUsingAPIByCommentID:(NSString*)commentID
{
    [spinner startAnimating];
    
    API_PostComment_Fetch *commentAPI = [[API_PostComment_Fetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                              device_token:[userDefaultManager getDeviceToken]
                                                                                   post_id:_post_id
                                                                                comment_id:commentID];
    
    
    [commentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_post_comment_fetch * data = (out_post_comment_fetch *) jsonObject;
        if (response.status)
        {
            [self showLoadMoreView:data.isFinal];
            self.isLoading = false;
            if( data.comments.count > 0)
            {
                //                _commentData = data.comments;
                NSMutableArray *reversedCopy = [[[data.comments reverseObjectEnumerator] allObjects] mutableCopy];
                NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [reversedCopy count])];
                [_commentData insertObjects:reversedCopy atIndexes:indexSet];
                
                [_tableView reloadData];
                [self scrollToBottom];
                [_tableView layoutIfNeeded];
            }
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
            
            if (response.code == 480)
            {
                [self reloadPreviousPage];
            }
        }
        
        [spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (IBAction)touchDoneButton:(id)sender {
    
    NSString *content = [_commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![content isEqualToString:@""])
    {
        [_doneButton setEnabled:FALSE];
        
        post_comment *params = [[post_comment alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:_post_id comment:content];
        if (params) {
            API_PostComment *postCommentAPI = [[API_PostComment alloc] initWithParam:params];
            [postCommentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                out_post_comment * data = (out_post_comment *) jsonObject;
                if (response.status)
                {
                    isReloadParent = true;
                    comment *com = [[comment alloc] init];
                    com.comment_id = data.comment_id;
                    com.name = profileData.name;
                    com.content = _commentTextView.text;
                    com.uid = profileData.uid;
                    com.username = profileData.username;
                    com.avatar = profileData.avatar;
                    [_commentData addObject:com];
                    [_tableView reloadData];
                    
                    _commentTextView.text = @"";
                    
                    [_tableView scrollRectToVisible:CGRectMake(_tableView.contentSize.width - 1,_tableView.contentSize.height - 1, 1, 1) animated:YES];
                }
                else
                {
                    [AppHelper showMessageBox:nil message:response.message];
                    
                    if (response.code == 480)
                    {
                        [self reloadPreviousPage];
                    }
                }
                
                [_doneButton setEnabled:TRUE];
            } ErrorHandlure:^(NSError *error) {
                [_doneButton setEnabled:TRUE];
            }];
            
        }
        
    }
}

- (IBAction)handleTapOnTableView:(id)sender {
    [self.view endEditing:TRUE];
}

- (int)getCurrentTimeStamp
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *resultDate =  [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    int timestamp = [resultDate timeIntervalSince1970];
    
    return timestamp;
}

- (void)reloadPreviousPage
{
//    UIViewController *previousView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
//
//    [self.navigationController popToViewController:previousView animated:TRUE];
    
//    UINavigationController *navigation = [self.tabBarController.viewControllers objectAtIndex:1];
//    MyProfileViewController *view = (MyProfileViewController*)[navigation.viewControllers firstObject];
//    [view loadDataBasedOnButtonIndex:0];
    [self.navigationController popToRootViewControllerAnimated:true];
}

#pragma mark - TextView : input comment
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text containsString:s_placeholder]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    if([textView.text length] == 0)
    {
        textView.text = s_placeholder;
        textView.textColor = [UIColor lightGrayColor];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text containsString:s_placeholder]){
        textView.text = [textView.text substringFromIndex:[s_placeholder length]];
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

// MARK: - UIKeyboard Show & Hide Notification
- (void)keyboardWillShow: (NSNotification *) notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    CGFloat keyboardHeight = keyboardSize.height;
    
    if (@available(iOS 11.0, *)) {
        keyboardHeight -= self.view.safeAreaInsets.bottom;
    }
    
    self.commentViewBottomMargin.constant = keyboardHeight;
    [self.commentView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.commentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.tableView scrollRectToVisible:CGRectMake(self.tableView.contentSize.width - 1, self.tableView.contentSize.height - 1, 1, 1) animated:YES];
    }];
}

- (void)keyboardWillHide: (NSNotification *) notification
{
    self.commentViewBottomMargin.constant = 0;
    [self.commentView setNeedsUpdateConstraints];
    
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.commentView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
@end
