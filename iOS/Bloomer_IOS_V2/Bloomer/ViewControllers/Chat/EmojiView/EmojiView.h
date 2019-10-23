//
//  EmojiView.h
//  Bloomer
//
//  Created by VanLuu on 3/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *tabScrollView;
@property (weak, nonatomic) IBOutlet UIView *tabContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentViewWidth;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;

//Emoji
@property (strong, nonatomic) NSArray *emojiTags;
@property (strong, nonatomic) NSArray *emojiImages;
@property (strong, nonatomic) NSMutableDictionary *stickerList;
@property (nonatomic, weak) UIResponder <UITextInput> *targetTextInput;
@property (strong, nonatomic) NSMutableArray *hashTags;

- (void)initEmojiKeyBoardImage:(UIView*)tabContentView animatedLine:(UIView*)animatedLine animatedLineLeftMargin:(NSLayoutConstraint*)animatedLineLeftMargin;

@end
