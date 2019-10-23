//
//  UploadingPicturesViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/17/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "UploadingPicturesViewController.h"
#import "MyProfileViewController.h"
#import "AppDelegate.h"

@interface UploadingPicturesViewController ()
{
    UserDefaultManager *userDefaultManager;
    CGRect backupFrameEditorField;
    CGFloat textViewHeight;
    NSString *photoID;
    NSMutableArray *payloads;
}
@end

@implementation UploadingPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    payloads = [[NSMutableArray alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    _uploadedPhoto.image = _chosenImage;
    
    _uploadedPhoto.clipsToBounds = TRUE;
    
//    [self initNavigationBar];
    
    textViewHeight = _editorField.frame.size.height;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.badgeNumber removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.badgeNumber];
}

- (void) initNavigationBar
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Uploading", nil)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)touchDoneButton
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Avatar_Attached *photoAPI = [[API_Avatar_Attached alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] image:_chosenImage];
    [photoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached * data = (out_avatar_attached *) jsonObject;
        if (response.status)
        {
            
            payload *temp = [[payload alloc] initWithPhotoID:data.photo_id caption:_editorField.text tags:_tag];
            
            [payloads addObject:temp];
            
            post_create *params = [[post_create alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] payloads:payloads];
            if (params) {
                API_PostCreate *postCreateAPI = [[API_PostCreate alloc] initWithParam:params];
                [postCreateAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        if ([_parentView isKindOfClass:[MyProfileViewController class]])
                        {
                            MyProfileViewController *view = (MyProfileViewController *)_parentView;
                            [view pullToRefresh];
                        }
                        
                        [self.navigationController popToViewController:_parentView animated:TRUE];
                    }
                    
                    [_uploadButton setEnabled:TRUE];
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                } ErrorHandlure:^(NSError *error) {
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                    [_uploadButton setEnabled:TRUE];
                }];
            }
            

        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];

}

- (IBAction)touchUploadButton:(id)sender {
//    [_uploadButton setEnabled:FALSE];
//    photo_attached_using *photoAPI = [[photo_attached_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]
//                                                                          device_token:[userDefaultManager getDeviceToken]
//                                                                                 image:_uploadedPhoto.image
//                                                                                  type:[self contentTypeForImageData:UIImagePNGRepresentation(_uploadedPhoto.image)]];
//    photoAPI.myDelegate = self;
//    [photoAPI connect];
}

- (IBAction)handlSingleTap:(id)sender {
    [self.view endEditing:TRUE];
}

//- (void)textViewDidChange:(UITextView *)txtView
//{
//    float height = txtView.contentSize.height;
//    
//    if (height > textViewHeight)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            txtView.frame = CGRectMake(txtView.frame.origin.x, txtView.frame.origin.y, txtView.frame.size.width, height);
//            _uploadedPhoto.frame = CGRectMake(_uploadedPhoto.frame.origin.x, _editorField.frame.size.height + _editorField.frame.origin.y, _uploadedPhoto.frame.size.width, _uploadedPhoto.frame.size.height);
//            [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, _uploadedPhoto.frame.size.height + _editorField.contentSize.height + 40)];
//        }];
//    }
//}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    if ([_editorField.text isEqualToString:@"Write your caption here..."])
//    {
//        _editorField.text = @"";
//    }
//
//    [_editorField setTextColor:[userDefaultManager colorFromHexString:@"4A4A4A"]];
//
//    return TRUE;
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    if ([_editorField.text isEqualToString:@""])
//    {
//        _editorField.text = @"Write your caption here...";
//        [_editorField setTextColor:[userDefaultManager colorFromHexString:@"C9C9C9"]];
//    }
//
//    return TRUE;
//}


//- (void)getDataPhoto_attached:(out_avatar_attached *)data
//{
//    if ([data getStt])
//    {
//        photoID = data.photo_id;
//        
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
//                                                        message:data.getMegs
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

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
    int timestamp = [resultDate timeIntervalSince1970];
    
    return timestamp;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.view endEditing:TRUE];
}

@end
