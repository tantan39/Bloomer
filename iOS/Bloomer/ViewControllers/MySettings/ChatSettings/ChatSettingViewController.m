//
//  ChatSettingViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChatSettingViewController.h"

@interface ChatSettingViewController () <FlowerMenuPopupViewDelegate> {
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    FlowerMenuPostPopupViewController *flowerPopup;
}

@property (assign, nonatomic) BOOL justOpenedPopUp;

@end

@implementation ChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    self.justOpenedPopUp = false;
    
    [self initSlider];
    [self initNavigationBar];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Settings.chatSettings", nil)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadSliderValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSlider {
//    sliderControl = [[SEFilterControl alloc] initWithFrame:_sliderView.frame titles:[NSArray arrayWithObjects:@"1", @"10", @"100", @"1.000", @"10.000",NSLocalizedString(@"Others", nil)  ,nil]];
    [self.sliderControl setTitles:[NSArray arrayWithObjects:@"1", @"10", @"100", @"1.000", @"10.000",NSLocalizedString(@"Others", nil), nil]];
    UIColor* progressColor  = [UIColor colorWithRed:0.89 green:0.31 blue:0.31 alpha:1.0];
    [self.sliderControl setBackgroundPathColor:progressColor];
    [self.sliderControl setProgressColor:progressColor];
    [self.sliderControl.handler setImage:[UIImage imageNamed:@"Icon_Flower_Holder_Chat_Settings"] forState:UIControlStateNormal];
    [self.sliderControl.handler setFrame:CGRectMake(self.sliderControl.handler.frame.origin.x, self.sliderControl.handler.frame.origin.y - 10, self.sliderControl.handler.frame.size.width, self.sliderControl.handler.frame.size.height)];
    self.sliderControl.handler.handlerColor = [UIColor darkGrayColor];
    self.sliderControl.handler.shadow = FALSE;
    
    UIColor* titleColor  = [UIColor colorWithRed:0.89 green:0.31 blue:0.31 alpha:1.0];
    [self.sliderControl setTitlesColor:titleColor];
    [self.sliderControl setTitlesFont:[UIFont fontWithName:@"SourceSansPro-Light" size:16]];
    
    //point
    [self.sliderControl setDisplayCirclePoint:YES];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void)loadSliderValue
{
    _numFlower = [userDefaultManager getChatSetting];
    _numberFlower.text = [NSString stringWithFormat:NSLocalizedString(@"ChatSetting.flowerToUnlock",nil),_numFlower];
    [_labelDescription setText:[NSString stringWithFormat:[AppHelper getLocalizedString:@"ChatSetting.friendsNeedFlower"],_numFlower]];
    
    switch (_numFlower) {
        case 1:
            [self.sliderControl setSelectedIndex:0 animated:TRUE];
            break;
        case 10:
            [self.sliderControl setSelectedIndex:1 animated:TRUE];
            break;
        case 100:
            [self.sliderControl setSelectedIndex:2 animated:TRUE];
            break;
        case 1000:
            [self.sliderControl setSelectedIndex:3 animated:TRUE];
            break;
        case 10000:
            [self.sliderControl setSelectedIndex:4 animated:TRUE];
            break;
        default:
            [self.sliderControl setSelectedIndex:5 animated:TRUE];
    }
    //add selector after load value for Slider
    [self.sliderControl addTarget:self action:@selector(SliderControlValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)SliderControlValueChanged
{
    if(self.sliderControl.selectedIndex == 5)
    {
        if (!self.justOpenedPopUp)
        {
            flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPostPopupViewController" bundle:nil];
            
            flowerPopup.parentView = self;
            flowerPopup.isFirstRank = FALSE;
            
            [flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
            flowerPopup.delegate = self;
            self.justOpenedPopUp = true;
        }
    }
    else
    {
        if(_numFlower != pow(10, self.sliderControl.selectedIndex))
        {
            _numFlower =pow(10, self.sliderControl.selectedIndex);
            _numberFlower.text = [NSString stringWithFormat:NSLocalizedString(@"ChatSetting.flowerToUnlock",nil),_numFlower];
            [_labelDescription setText:[NSString stringWithFormat:[AppHelper getLocalizedString:@"ChatSetting.friendsNeedFlower"],_numFlower]];
            
            setting_update *params = [[setting_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] chatting:_numFlower];
            
            [self requestSettingUpdateWithData:params];
        }
    }
}

- (void) requestSettingUpdateWithData:(setting_update *)data{

    if (data) {
        API_Setting_Update * api = [[API_Setting_Update alloc] initWithParams:data];
        [api postRequest:^(BaseJSON *json, RestfulResponse *objStatus) {
            
            if (objStatus.status){
                [userDefaultManager saveChatSetting:_numFlower];
                [flowerPopup removeAnimate];
            }else{
                [AppHelper showMessageBox:nil message:objStatus.message];
            }
            
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}


-(void)didEndEditing:(NSInteger)nFlower isCanel:(BOOL)isCanel
{
    if (!isCanel)
    {
        _numFlower = nFlower;
        _numberFlower.text = [NSString stringWithFormat:NSLocalizedString(@"ChatSetting.flowerToUnlock",nil),_numFlower];
        [_labelDescription setText:[NSString stringWithFormat:[AppHelper getLocalizedString:@"ChatSetting.friendsNeedFlower"],_numFlower]];
        
        setting_update *params = [[setting_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] chatting:_numFlower];
        [self requestSettingUpdateWithData:params];
    }
    else
    {
        [self loadSliderValue];
    }
    
    self.justOpenedPopUp = false;
}

@end
