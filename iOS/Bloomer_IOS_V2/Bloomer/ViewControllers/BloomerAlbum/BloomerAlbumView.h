//
//  BloomerAlbumView.h
//  Bloomer
//
//  Created by Steven on 6/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloomerAlbumView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
