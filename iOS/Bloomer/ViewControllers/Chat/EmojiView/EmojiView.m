//
//  EmojiView.m
//  Bloomer
//
//  Created by VanLuu on 3/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "EmojiView.h"
#import "ChatViewController.h"
#import "StickerCell.h"
#import "NotificationHelper.h"

@implementation EmojiView
{
    NSMutableArray *stickerCollectionViews;
    NSMutableArray *stickers;
    NSMutableArray *tabBarButtons;
    NSMutableArray *stickerIcons;
}

@synthesize targetTextInput, stickerList, hashTags;

#pragma mark - view lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    stickerCollectionViews = [[NSMutableArray alloc] init];
    stickerList = [[NSMutableDictionary alloc] init];
    hashTags = [[NSMutableArray alloc] init];
    stickers = [[NSMutableArray alloc] init];
    tabBarButtons = [[NSMutableArray alloc] init];
    stickerIcons = [[NSMutableArray alloc] init];
    self.scrollView.delegate = self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addObservers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self addObservers];
    }
    return self;
}

- (void)initStickerList
{
    hashTags = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 65; i++) {
        NSString *bear = [NSString stringWithFormat:@"[sticker_%i]", i];
        [hashTags addObject:bear];
    }
    
    stickerList = [[NSMutableDictionary alloc] init];
    
    //int emojiID = 1;
    
    for (int i = 1; i <= 65; i++) {
        [stickerList setValue:[NSString stringWithFormat:@"%@%i", @"sticker_", i] forKey: [NSString stringWithFormat:@"[%@%i]",@"sticker_",i]];
        //emojiID++;
    }
    //NSLog(@"arrary: %@", stickerList);
}

- (void)initEmojiKeyBoardImage:(UIView*)tabContentView animatedLine:(UIView*)animatedLine animatedLineLeftMargin:(NSLayoutConstraint*)animatedLineLeftMargin
{
    self.animatedLine = animatedLine;
    self.animatedLineLeftMargin = animatedLineLeftMargin;
    self.tabContentView = tabContentView;
    
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Stickers" ofType:@"plist"]];
    NSArray *iconArray = [dictionary objectForKey:@"Sticker_Icons"];
    
    for (NSInteger i = 0; i < iconArray.count; i++)
    {
        [stickerIcons addObject:[iconArray objectAtIndex:i]];
    }
    
    for (NSInteger i = 0; i < dictionary.count - 1; i++)
    {
        NSString *stickersKey = [NSString stringWithFormat:@"Stickers_%ld", i + 1];
        NSArray *stickerArray = [dictionary objectForKey: stickersKey];
        
        for (NSInteger j = 0; j < stickerArray.count; j++)
        {
            NSString *hashtag = [NSString stringWithFormat:@"[%@]", stickerArray[j]];
            [hashTags addObject:hashtag];
            
            [stickerList setValue:stickerArray[j] forKey:hashtag];
        }
        
        [stickers addObject:stickerArray];
    }
    
    for (NSInteger i = 0; i < stickers.count; i++)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [collectionView registerNib:[UINib nibWithNibName:[StickerCell nibName] bundle:nil] forCellWithReuseIdentifier:[StickerCell cellIdentifier]];
        
        [self.scrollViewContentView addSubview:collectionView];
        [stickerCollectionViews addObject:collectionView];

        if (i == 0)
        {
            [self setupConstraintsForView:collectionView previousView:nil isFirstView:true parentView:self.scrollViewContentView width:width spacing:0 parentViewMargin:0];
        }
        else
        {
            UIView *previousView = [stickerCollectionViews objectAtIndex:i - 1];
            [self setupConstraintsForView:collectionView previousView:previousView isFirstView:false parentView:self.scrollViewContentView width:width spacing:0 parentViewMargin:0];
        }
        
        [collectionView reloadData];
    }
    
    self.scrollViewContentViewWidth.constant = width * stickers.count;
    
    [self initTabBar];
    [self.scrollViewContentView bringSubviewToFront:animatedLine];
    
//    UIButton *button = (UIButton*)[tabBarButtons firstObject];
    animatedLineLeftMargin.constant = 10;
}

- (void)initTabBar
{
    for (NSInteger i = 0; i < stickers.count; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.translatesAutoresizingMaskIntoConstraints = false;
        [button imageView].contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:[UIImage imageNamed:[stickerIcons objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [tabBarButtons addObject:button];
        [self.tabContentView addSubview:button];
        [self.tabContentView sendSubviewToBack:button];
        
        if (i == 0)
        {
            [self setupConstraintsForView:button previousView:nil isFirstView:true parentView:self.tabContentView width:self.tabContentView.frame.size.height spacing:10 parentViewMargin:5];
        }
        else
        {
            UIButton *previousButton = [tabBarButtons objectAtIndex:i - 1];
            [self setupConstraintsForView:button previousView:previousButton isFirstView:false parentView:self.tabContentView width:self.tabContentView.frame.size.height spacing:10 parentViewMargin:5];
        }
    }
}

- (void)setupConstraintsForView:(UIView*)view previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView parentView:(UIView*)parentView width:(CGFloat)width spacing:(CGFloat)spacing parentViewMargin:(CGFloat)margin
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

    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1 constant:margin];
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1 * margin];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    
    [parentView addConstraints:@[topMargin, leftMargin, bottomMargin]];
    [view addConstraint:widthConstraint];
}

- (void)addObservers {
    // Keep track of the textView/Field that we are editing
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidBegin:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidBegin:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidEnd:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidEnd:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidEndEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:nil];
    self.targetTextInput = nil;
}

- (void)animateLine:(CGFloat)x
{
    self.animatedLineLeftMargin.constant = x;
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - editingDidBegin/End

// Editing just began, store a reference to the object that just became the firstResponder
- (void)editingDidBegin:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[UIResponder class]])
    {
        if ([notification.object conformsToProtocol:@protocol(UITextInput)]) {
            self.targetTextInput = notification.object;
            return;
        }
    }
    
    // Not a valid target for us to worry about.
    self.targetTextInput = nil;
}

// Editing just ended.
- (void)editingDidEnd:(NSNotification *)notification {
    self.targetTextInput = nil;
}

#pragma mark - text replacement routines

// Check delegate methods to see if we should change the characters in range
- (BOOL)textInput:(id <UITextInput>)textInput shouldChangeCharactersInRange:(NSRange)range withString:(NSString *)string {
    if (textInput) {
        if ([textInput isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)textInput;
            if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                if ([textField.delegate textField:textField
                    shouldChangeCharactersInRange:range
                                replacementString:string]) {
                    return YES;
                }
            } else {
                // Delegate does not respond, so default to YES
                return YES;
            }
        } else if ([textInput isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)textInput;
            if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                if ([textView.delegate textView:textView
                        shouldChangeTextInRange:range
                                replacementText:string]) {
                    return YES;
                }
            } else {
                // Delegate does not respond, so default to YES
                return YES;
            }
        }
    }
    return NO;
}

// MARK: - Actions

- (void)touchTabBarButton:(UIButton*)sender
{
    [NotificationHelper postNotificationForSwitchingStickerKeyboard];
    [self.scrollView scrollRectToVisible:CGRectMake(sender.tag * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:true];
    
//    UIButton *button = (UIButton*)[tabBarButtons objectAtIndex:sender.tag];
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        [self animateLine: 10 + (offsetX / self.scrollView.frame.size.width * 50)];
    }
}

// Replace the text of the textInput in textRange with string if the delegate approves
- (void)textInput:(id <UITextInput>)textInput replaceTextAtTextRange:(UITextRange *)textRange withString:(NSString *)string {
    if (textInput) {
        if (textRange) {
            // Calculate the NSRange for the textInput text in the UITextRange textRange:
            int startPos                    = [textInput offsetFromPosition:textInput.beginningOfDocument
                                                                 toPosition:textRange.start];
            int length                      = [textInput offsetFromPosition:textRange.start
                                                                 toPosition:textRange.end];
            NSRange selectedRange           = NSMakeRange(startPos, length);
            
            if ([self textInput:textInput shouldChangeCharactersInRange:selectedRange withString:string]) {
                // Make the replacement:
                [textInput replaceRange:textRange withText:string];
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDatasource, Flowlayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger nColumn = 4;
    
    return CGSizeMake(screenWidth / nColumn, [StickerCell cellHeight] / 1.5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    for (NSInteger i = 0; i < stickerCollectionViews.count; i++)
    {
        if (collectionView == [stickerCollectionViews objectAtIndex:i])
        {
            NSMutableArray *stickerArray = (NSMutableArray*)[stickers objectAtIndex:i];
            return stickerArray.count;
        }
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCell *cell = (StickerCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[StickerCell cellIdentifier] forIndexPath:indexPath];
    
    for (NSInteger i = 0; i < stickerCollectionViews.count; i++)
    {
        if (collectionView == [stickerCollectionViews objectAtIndex:i])
        {
            NSMutableArray *stickerArray = (NSMutableArray*)[stickers objectAtIndex:i];
            
            cell.image.image = [UIImage imageNamed:[stickerArray objectAtIndex:indexPath.row]];
        }
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.targetTextInput)
    {
        for (NSInteger i = 0; i < stickerCollectionViews.count; i++)
        {
            if (collectionView == [stickerCollectionViews objectAtIndex:i])
            {
                NSInteger realIndex = indexPath.row;
                for (NSInteger j = i - 1; j >= 0; j--)
                {
                    NSMutableArray *stickerArray = (NSMutableArray*)[stickers objectAtIndex:j];
                    realIndex += stickerArray.count;
                }
                
                NSString *hashtag = [hashTags objectAtIndex:realIndex];
                
                UITextRange *selectedTextRange = self.targetTextInput.selectedTextRange;
                if (selectedTextRange) {
                    [self textInput:self.targetTextInput replaceTextAtTextRange:selectedTextRange withString:hashtag];
                }
            }
        }
    }
}

@end
