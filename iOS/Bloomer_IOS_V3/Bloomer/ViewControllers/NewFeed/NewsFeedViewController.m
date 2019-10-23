//
//  NewFeedViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/21/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "NewsFeedViewController.h"

@interface NewsFeedViewController () {

    UIBarButtonItem *cameraBarButton;
    UIBarButtonItem *notiBarButton;
    UISearchBar *searchbar;
    NewsFeedSearchCustomView * searchView;
}
@property (assign,atomic) BOOL isNotFound;
@end

@implementation NewsFeedViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageMenuCustomView.delegate = self;
    [self setupCollectionView];
    
    [self createBarButton];
    [self addSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    UITextField *textField = [searchbar valueForKey:@"_searchField"];
//    CGRect frame = textField.frame;
//    frame.size.height = 30;
//    textField.frame = frame;
//    [searchbar layoutIfNeeded];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:[CommunityCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[CommunityCollectionViewCell cellIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[BloomerNewsCollectionViewCell nibName] bundle:nil] forCellWithReuseIdentifier:[BloomerNewsCollectionViewCell cellIdentifier]];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
}

- (void) addSearchBar {
    searchbar = [[UISearchBar alloc] init];
    [searchbar sizeToFit];
    searchbar.delegate = self;
    [searchbar setupSearchBar];
    searchbar.searchBarStyle = UISearchBarStyleProminent;
    [searchbar customizeGrayThemeSearchBar];
    searchbar.placeholder = NSLocalizedString(@"WinnersClub.searchPlaceHolder",);
    searchbar.tintColor = [UIColor rgb:68 green:68 blue:68];
    searchbar.tintColor = [UIColor grayColor];

    UITextField *textField = [searchbar valueForKey:@"_searchField"];
    textField.tintColor = [UIColor rgb:119 green:119 blue:119];
    textField.backgroundColor = [UIColor rgb:244 green:244 blue:244];
    
    if (@available(iOS 11.0, *)) {
        [searchbar.heightAnchor constraintEqualToConstant:44].active = TRUE;
    }
    
    self.navigationItem.titleView = searchbar;
    [self.navigationItem.titleView sizeToFit];
    [searchbar layoutIfNeeded];
}

- (void) createBarButton {
    cameraBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_edit_avatar"] style:UIBarButtonItemStylePlain target:self action:@selector(touchCamera)];
    notiBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_edit_avatar"] style:UIBarButtonItemStylePlain target:self action:@selector(touchNoti)];
    [self addBarButton];
}

- (void) addBarButton {
    self.navigationItem.leftBarButtonItem = cameraBarButton;
    self.navigationItem.rightBarButtonItem = notiBarButton;
}

- (void) collapseSearch {
    [UIView animateWithDuration:0.8 animations:^{
        [self addBarButton];
        
//        [self->searchbar layoutIfNeeded];
//        [self.navigationItem.titleView sizeToFit];
//        [self.navigationItem.titleView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [searchbar setShowsCancelButton:FALSE];
        }
    }];
}


- (void) expandableSearch {
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationItem.leftBarButtonItem  = nil;
        self.navigationItem.rightBarButtonItem  = nil;
        [searchbar setShowsCancelButton:TRUE];
        [self.navigationItem.titleView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if(finished) {
            [searchbar becomeFirstResponder];
        }
    }];
}

- (void) touchCamera {
    [self expandableSearch];
}

- (void) touchNoti {
    
}

- (void) setHeaderTable: (BOOL) isSet {
//    if (isSet) {
//        UIView *headerNotFound = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
//        UILabel *label = [[UILabel alloc] initWithFrame:headerNotFound.bounds];
//        [headerNotFound addSubview:label];
//        label.text = @"Không tìm thấy";
//        label.font = [UIFont fontWithName:@"SFProText-Regular" size: 16];
//        label.backgroundColor = UIColor.redColor;
//        label.textAlignment = NSTextAlignmentCenter;
//        [headerNotFound sizeToFit];
//        self.searchTableView.tableHeaderView = headerNotFound;
//    } else {
//        self.searchTableView.tableHeaderView = nil;
//    }
//    [self.searchTableView.tableHeaderView layoutIfNeeded];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CommunityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CommunityCollectionViewCell cellIdentifier] forIndexPath:indexPath];
        return cell;
    }
    
    BloomerNewsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BloomerNewsCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.pageMenuCustomView.lineViewLeftPaddingConstraint.constant = offsetX / 2 - 8;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSInteger index = targetContentOffset -> x / self.view.bounds.size.width;
    NSIndexPath * idx = [NSIndexPath indexPathForRow:index inSection:0 ];
    [self.pageMenuCustomView.collectionView selectItemAtIndexPath:idx animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)menuSelectedIndex:(NSInteger)index{
    NSIndexPath * idx = [NSIndexPath indexPathForRow:index inSection:0 ];
    [self.collectionView scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self setHeaderTable:FALSE];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self collapseSearch];
    [searchBar endEditing:YES];
    [searchView removeFromSuperview];

}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self expandableSearch];
    
    searchView = [[NewsFeedSearchCustomView alloc] init];
    searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:searchView];
    [AppHelper setupFullStretchConstraintsForView:searchView parentView:self.view];
    
    [searchView setAlpha:0];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [searchView setAlpha:1];
        
    } completion:nil];
    
    
//    [self setHeaderTable:TRUE];
    
   
    return TRUE;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
//    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
//
//    self.searchResultTableViewBottomMargin.constant = keyboardSize.height;
//    [self.searchTableView setNeedsUpdateConstraints];
//
//    [UIView animateWithDuration:time delay:0 options:option animations:^{
//        [self.searchTableView layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    
}

@end
