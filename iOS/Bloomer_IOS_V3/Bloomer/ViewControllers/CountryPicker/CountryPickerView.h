//
//  CountryPickerView.h
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"
#import "UIImageView+Extension.h"
@protocol CountryPickerDelegate

-(void)didSelectCountry:(Country *) country;

@end

@interface CountryPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) NSMutableArray* countryList;
@property (weak, nonatomic) id<CountryPickerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@end
