//
//  TTTextField.h
//  MessageView
//
//  Created by Tan Tan on 12/2/17.
//  Copyright © 2017 Tan Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@class TTTextField;
@protocol TTTextfieldDelegate<NSObject>
- (void) textFieldSelectedIndex:(NSInteger) index textfield:(TTTextField *) sender;
@end


@interface TTTextField : UITextField<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

- (void) setUnderline;

- (void) setUnderlineColor:(UIColor *) color;

- (void) setDatasource:(NSArray *) array inView:(UIView *) view;

@property (weak,nonatomic) id<TTTextfieldDelegate,UITextFieldDelegate> delegate;
@property (nonatomic, assign) BOOL isShow;

- (void) handleEventEdittingBegin;
- (void) handleEventEdittingEnd;

@end
