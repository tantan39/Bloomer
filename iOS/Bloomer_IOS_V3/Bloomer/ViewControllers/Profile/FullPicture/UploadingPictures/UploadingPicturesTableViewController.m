//
//  UploadingPicturesTableViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/23/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import "UploadingPicturesTableViewController.h"
#import "MyProfileViewController.h"
#import "AppDelegate.h"
#import "UIColor+Extension.h"
#import "API_Avatar_RaceAttached.h"

@interface UploadingPicturesTableViewController () {
    UserDefaultManager *userDefaultManager;
    NSString *photoID;
    int count;
    int countCaptions;
    Spinner *spinner;
    NSMutableArray *payloads;
    NSMutableArray *photoIDs;
    CGRect keyboardRect;
}
@end

@implementation UploadingPicturesTableViewController
@synthesize tag, uploadPhotos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationController];
    
    count = 1;
    countCaptions = 0;
    userDefaultManager = [[UserDefaultManager alloc] init];
    payloads = [[NSMutableArray alloc] init];
    photoIDs = [[NSMutableArray alloc] init];
    
    if (uploadPhotos.count == 1)
    {
        _NameOfRace.text = [NSString stringWithFormat:NSLocalizedString(@"uploadOnePictureNameRace.Title", ), _name];
    }
    else
    {
        _NameOfRace.text = [NSString stringWithFormat:NSLocalizedString(@"uploadMultiplePictureNameRace.Title", ), _name];
    }
    
    if (!self.isCaptionEditting)
    {
        self.captions = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < uploadPhotos.count; i++)
        {
            [self.captions addObject:@""];
        }
    }
    
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
    [_ProgressUploadBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppHelper changeNavigationBarToRed:self.navigationController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)initNavigationController
{
    NSString *buttonDoneTitle = !self.isCaptionEditting ? NSLocalizedString(@"uploadPictureTableViewNext.Done",nil) : NSLocalizedString(@"Done",nil);
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:buttonDoneTitle style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    if (!self.isCaptionEditting)
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Uploading", nil) color:[UIColor colorFromHexString:@"#202021"]];
    }
    else
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"UploadingPicturesEdit.navigationName", nil) color:[UIColor colorFromHexString:@"#202021"]];
    }
}

- (void)loadTagsRace {
    API_RaceTagFetch *api = [[API_RaceTagFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                             device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_RaceTagsFetch *data = (JSON_RaceTagsFetch *)jsonObject;
            for (int i = 0; i < data.tagList.count; i++) {
                childs *temp = data.tagList[i];
                [tag addObject:temp.key];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}

- (void)touchDoneButton
{
    [_ProgressUploadBar setHidden:NO];
    [spinner startAnimating];
    
    if (!_isCaptionEditting)
    {
        [self postAvatarAttachedWith:0];
        
        if(![userDefaultManager getUserProfileData].isupload_avatar) {
            API_Avatar_RaceAttached *api = [[API_Avatar_RaceAttached alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] image:[uploadPhotos objectAtIndex:0] key:self.key];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                 [spinner stopAnimating];
            } ErrorHandlure:^(NSError *error) {
                [spinner stopAnimating];
            }];
        }
    }
    else
    {
        caption_post *param = [[caption_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:_postID caption:_captions[0]];
        if (param) {
            API_CaptionEdit *api = [[API_CaptionEdit alloc] initWithParams:param];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                 [spinner stopAnimating];
                if (response.status)
                {
                    if([_parentView isKindOfClass:[FullPictureViewController class]])
                    {
                        FullPictureViewController *view = (FullPictureViewController *)_parentView;
                        [view loadContentPost];
                    }
                    else if([_parentView isKindOfClass:[PhotoListViewController class]])
                    {
                        PhotoListViewController *view = (PhotoListViewController *)_parentView;
                        
                        [view changeDataAfterEdit:_captions[0] index:_indexForEdit];
                        
                    }
                    
                    [self.navigationController popToViewController:_parentView animated:TRUE];
                   
                }
                else
                {
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                [spinner stopAnimating];
            }];
        }
        
    }
}

- (void) postAvatarAttachedWith:(NSInteger ) index{
    API_Avatar_Attached *photoAPI = [[API_Avatar_Attached alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] image:[uploadPhotos objectAtIndex:index]];
    [photoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached * data = (out_avatar_attached *) jsonObject;
        if (response.status)
        {
            [photoIDs addObject:data.photo_id];
            
            if (count == uploadPhotos.count) {
                
                for (int i = 0; i < count; i++) {
                    NSString *ids = [photoIDs objectAtIndex:i];
                    NSString *cap = [_captions objectAtIndex:i];
                    payload *temp = [[payload alloc] initWithPhotoID:ids caption:cap tags:tag];
                    
                    [payloads addObject:temp];
                }
                
                post_create *params = [[post_create alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] payloads:payloads];
//                NSLog(@"param: %@", [params createStringJSON]);
                
                float percent = (float)count / uploadPhotos.count;
                [self.ProgressUploadBar setProgress:percent];
                
                if (params) {
                    API_PostCreate *postCreateAPI = [[API_PostCreate alloc] initWithParam:params];
                    [postCreateAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                         [spinner stopAnimating];
                        if (response.status)
                        {                            
                            if ([_parentView isKindOfClass:[MyProfileViewController class]])
                            {
                                MyProfileViewController* vc = (MyProfileViewController*)_parentView;
                                [vc pullToRefresh];
                                
                                PicturesRaceViewController *view = [[PicturesRaceViewController alloc] initWithNibName:@"PicturesRaceViewController" bundle:nil];
                                view.key = _key;
                                view.uid = [userDefaultManager getUserProfileData].uid;
                                view.status = 1;
                                view.raceName = _name;
                                view.parentMeView = _parentView;
                                
                                [self.navigationController pushViewController:view animated:true];
                                self.navigationController.viewControllers = @[self.parentView, view];
                            }
                        }
                        else
                        {
                            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
                            //                                                        message:data.getMegs
                            //                                                       delegate:self
                            //                                              cancelButtonTitle:@"OK"
                            //                                              otherButtonTitles:nil];
                            //        [alert show];
                        }
                        
                        
                        if ([_parentView isKindOfClass:[PicturesRaceViewController class]])
                        {
                            PicturesRaceViewController *view = (PicturesRaceViewController *)_parentView;
                            [view pullToRefresh];
                            [self.navigationController popToViewController:_parentView animated:TRUE];
                        }
                        
                        if ([self.parentView isKindOfClass:[RacesViewController class]])
                        {
                            [self.navigationController popToViewController:self.parentView animated:true];
                        }
                    } ErrorHandlure:^(NSError *error) {
                        [spinner stopAnimating];

                    }];
                }
                

            } else {
                float percent = (float)count / uploadPhotos.count;
                [self.ProgressUploadBar setProgress:percent];
                [self postAvatarAttachedWith:count];
                count++;
            }
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return uploadPhotos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(uploadPhotos.count == 1)
    {
        return 454;

    }
    else
    {
        return 124;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(uploadPhotos.count == 1)
    {
        NSString *identifier = @"Uploading";
        UploadingPictureTableViewCell *cell = (UploadingPictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"UploadingPictureTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.editorField.text = (NSString *)[_captions objectAtIndex:indexPath.row];
        cell.editorField.delegate = self;
        if(cell.editorField.text.length > 0)
        {
            [cell.lblPlaceholder setHidden:YES];
        }
        else
        {
            [cell.lblPlaceholder setHidden:false];
        }
        if(_isCaptionEditting && cell.editorField.text.length > 0){
            [cell.editorField becomeFirstResponder];
            [cell.lblPlaceholder setHidden:YES];
        }
        cell.photo.clipsToBounds = TRUE;
        cell.photo.image = [uploadPhotos objectAtIndex:indexPath.row];
            
        return cell;
    }
    else
    {
        NSString *identifier = @"UploadingMultiple";
        UploadPictureMultipleViewCell *cell = (UploadPictureMultipleViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"UploadPictureMultipleViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.editorField.text = (NSString*)[_captions objectAtIndex:indexPath.row];
        cell.index = indexPath.row;
        cell.myParentView = self;
        cell.editorField.delegate = self;
        if(cell.editorField.text.length > 0)
        {
            [cell.lblPlaceholder setHidden:YES];
        }
        else
        {
            [cell.lblPlaceholder setHidden:false];
        }
        if(_isCaptionEditting && cell.editorField.text.length > 0){
            [cell.editorField becomeFirstResponder];
            [cell.lblPlaceholder setHidden:YES];
        }
        

        cell.photo.clipsToBounds = TRUE;
        cell.photo.image = [uploadPhotos objectAtIndex:indexPath.row];
        
        return cell;
    }
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 1];
}

- (void) removingIndex:(NSInteger) index
{
    [uploadPhotos removeObjectAtIndex:index];
    [_locationIndex removeObjectAtIndex:index];
    [_captions removeObjectAtIndex:index];
    if(uploadPhotos.count == 1)
    {
        _NameOfRace.text = [NSString stringWithFormat:NSLocalizedString(@"uploadOnePictureNameRace.Title", ), _name];
    }
    else
    {
        _NameOfRace.text = [NSString stringWithFormat:NSLocalizedString(@"uploadMultiplePictureNameRace.Title", ), _name];
    }
    [_tableView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView
{
    for (int i = 0; i < _captions.count; i++)
    {
        UploadingPictureTableViewCell *cell = (UploadingPictureTableViewCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (cell.editorField == textView)
        {
            [_captions replaceObjectAtIndex:i withObject:textView.text];
            break;
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    for (int i = 0; i < _captions.count; i++)
    {
        UploadPictureMultipleViewCell *cell = (UploadPictureMultipleViewCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (cell.editorField == textView && uploadPhotos.count > 1)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [cell.lblPlaceholder setHidden:YES];
            break;
        }
        else if(uploadPhotos.count == 1)
        {
            [cell.lblPlaceholder setHidden:YES];
            break;
        }
    }
    //    NSLog(@"%@", textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    for (int i = 0; i < _captions.count; i++)
    {
        UploadPictureMultipleViewCell *cell = (UploadPictureMultipleViewCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (cell.editorField == textView && [textView.text length] == 0)
        {
            [cell.lblPlaceholder setHidden:NO];
            break;
        }
    }
    //    NSLog(@"%@", textView.text);
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
            break;
        case 0x42:
            return @"bmp";
        case 0x4D:
            return @"tiff";
    }
    return nil;
}

- (int)getCurrentTimeStamp
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *resultDate =  [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    int timestamp = [resultDate timeIntervalSince1970]/1000;
    
    return timestamp;
}


- (IBAction)handSingleTap:(id)sender {
//    [self.view endEditing:TRUE];
}

// MARK: - Selectors
- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    self.tableViewBottomMargin.constant = keyboardSize.height;
    [self.tableView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.tableViewBottomMargin.constant = 0;
    [self.tableView setNeedsUpdateConstraints];
    
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.tableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end
