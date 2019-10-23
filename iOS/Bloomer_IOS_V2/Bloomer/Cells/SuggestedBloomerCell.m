//
//  SuggestedBloomerCell.m
//  Bloomer
//
//  Created by Steven on 12/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "SuggestedBloomerCell.h"
#import "UserDefaultManager.h"
#import <UIKit+AFNetworking.h>
#import "UserProfileViewController.h"
#import "AppHelper.h"

@implementation SuggestedBloomerCell
{
    NSMutableArray *suggestedViews;
    UserDefaultManager *userDefaultManager;
    NSMutableArray *suggestedList;
}

+ (CGFloat)cellHeight
{
    return 230;
}

+ (NSString*)cellIdentifier
{
    return @"SuggestedBloomerCell";
}

+ (NSString*)nibName
{
    return @"SuggestedBloomerCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    suggestedViews = [[NSMutableArray alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    suggestedList = [[NSMutableArray alloc] init];
    
    self.labelSuggestedBloomerTitle.text = [AppHelper getLocalizedString:@"MyBloomer.suggestedBloomer"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadSuggestedList
{
    API_SuggestedList *api = [[API_SuggestedList alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        Json_SuggestedList * data = (Json_SuggestedList * ) jsonObject;
        if (response.status)
        {
            suggestedList = [data suggestedPeople];
            [self setupSuggestedList];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)setupSuggestedList
{
    self.contentViewWidth.constant = ([SuggestedPersonView viewSize].width + 5) * suggestedList.count;
    
    for (NSInteger i = 0; i < suggestedList.count; i++)
    {
        SuggestedPerson *suggestedPerson = (SuggestedPerson*)[suggestedList objectAtIndex:i];
        
        SuggestedPersonView *view = (SuggestedPersonView*)[[[NSBundle mainBundle] loadNibNamed:@"SuggestedPersonView" owner:self options:nil] objectAtIndex:0];
        view.tag = i;
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSuggestedPerson:)];
        [view addGestureRecognizer:tapGestureRecognizer];
        
        [self.scrollViewContentView addSubview:view];
        
        if (i == 0)
        {
            [self setupConstraintForSuggestedView:view previousView:self.scrollViewContentView isFirstView:true];
        }
        else
        {
            UIView *previousView = (UIView*)[suggestedViews objectAtIndex:i - 1];
            [self setupConstraintForSuggestedView:view previousView:previousView isFirstView:false];
        }
        
        [view layoutIfNeeded];
        
        view.labelName.text = suggestedPerson.name;
        view.labelUsername.text = suggestedPerson.username;
        [view.avatar setImageWithURL:[NSURL URLWithString:suggestedPerson.avatar]];
        
        [suggestedViews addObject:view];
    }
}

- (void)setupConstraintForSuggestedView:(UIView*)suggestedView previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:suggestedView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[SuggestedPersonView viewSize].width];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:suggestedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[SuggestedPersonView viewSize].height];
    
    [suggestedView addConstraints:@[widthConstraint, heightConstraint]];
    
    NSLayoutConstraint *leftMargin = [[NSLayoutConstraint alloc] init];
    
    if (isFirstView)
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:suggestedView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeLeading multiplier:1 constant:5];
    }
    else
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:suggestedView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeTrailing multiplier:1 constant:5];
    }
    
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:suggestedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollViewContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.scrollViewContentView addConstraints:@[leftMargin, topMargin]];
}

- (void)touchSuggestedPerson:(UITapGestureRecognizer*)gesture
{
    SuggestedPerson *suggestPerson = (SuggestedPerson*)[suggestedList objectAtIndex:gesture.view.tag];
    
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = suggestPerson.uid;
    
    [self.navigationController pushViewController:view animated:YES];
}



@end
