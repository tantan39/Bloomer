//
//  CountryPickerView.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "CountryPickerView.h"

@interface CountryPickerView () {
    NSInteger selectedRow;
}
@end

@implementation CountryPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.view = [[NSBundle mainBundle] loadNibNamed:@"CountryPickerView" owner:self options:nil][0];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    [self animateFromAlpha:0 toAlpha:1 completion:nil];
}

#pragma mark UIPickerViewDataSource implement
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countryList.count;
}

#pragma mark UIPickerViewDelegate implement
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(51, 3, 245, 24)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [view addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 40, 24)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [view addSubview:flagView];
    }
    
    Country *country = (Country*)[self.countryList objectAtIndex:row];
    ((UILabel *)[view viewWithTag:1]).text = [NSString stringWithFormat:@"(%@) %@",country.countryCode,country.countryName];
    if ([country.countryFlag isKindOfClass: NSString.class]) {
        [((UIImageView *)[view viewWithTag:2]) setImageWithURL:[NSURL URLWithString:country.countryFlag]];
    }

    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedRow = row;
}

- (IBAction)doneButton_OnClick:(id)sender {
    if(self.delegate) {
        Country *country = (Country*)[self.countryList objectAtIndex:selectedRow];
        [self.delegate didSelectCountry:country];
    }
    [self animateFromAlpha:1 toAlpha:0 completion:^{
        [self removeFromSuperview];
    }];
}

- (IBAction)touchOutsidePicker:(id)sender {
    [self animateFromAlpha:1 toAlpha:0 completion:^{
        [self removeFromSuperview];
    }];
}

-(void)animateFromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha completion:(void(^)())completionBlock {
    [self setAlpha:fromAlpha];
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:toAlpha];
    } completion:^(BOOL finished) {
        if(finished && completionBlock != nil)
            completionBlock();
    }];
}

-(UIPickerView*)getPickerView {
    return (UIPickerView*)[self.view viewWithTag:0];
}

@end
