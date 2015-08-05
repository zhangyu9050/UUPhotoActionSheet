//
//  UUPhotoCollectionViewController.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUPhotoCollectionViewController.h"
#import "UUPhoto-Import.h"
#import "UUPhoto-Macros.h"

@interface UUPhotoCollectionViewController() < UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UUPhotoBrowserDelegate >

@property (nonatomic, strong, getter = getCollectionView) UICollectionView *collectionView;
@property (nonatomic, strong, getter = getToolBarView) UUToolBarView *toolBarView;

@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, assign) NSInteger jumpPage;

@end

@implementation UUPhotoCollectionViewController

-(void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (_isPreview) [[UUAssetManager sharedInstance] markFilterPreviewObject];
    
    _isPreview = NO;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configUI];
    [self configNavigationItem];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle

- (void)configUI{
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolBarView];
}

- (void)configNavigationItem{
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor   = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlackTranslucent;
    
    
    self.navigationItem.title = @"相册";
    UIBarButtonItem *barCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onClickCancel:)];
    
    self.navigationItem.rightBarButtonItem = barCancel;
    
}


#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[UUAssetManager sharedInstance] getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UUThumbnailCollectionCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UUThumbnailCollectionCell cellReuseIdentifier]
                                                     forIndexPath:indexPath];
    
    [cell setContentWithIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _jumpPage = indexPath.row;
    
    UUPhotoBrowserViewController *controller;
    controller = [[UUPhotoBrowserViewController alloc] init];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UUPhotoBrowser Delegate

- (BOOL)isCheckMaxSelectedFromPhotoBrowser:(UUPhotoBrowserViewController *)browser{

    NSInteger max = [UUAssetManager sharedInstance].maxSelected;
    
    if ([UUAssetManager sharedInstance].selectdPhotos.count >= max) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您最多只能选择%d张图片",(int)max]
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确认", nil];
        
        [alter show];
    }
    
    return [UUAssetManager sharedInstance].selectdPhotos.count >= max ? YES : NO;
}

- (void)displayImageWithIndex:(NSUInteger)index selectedChanged:(BOOL)selected{

    if (_isPreview) {
        
        index = [[UUAssetManager sharedInstance] markPreviewObjectWithIndex:index selecte:selected];
        
    }else{
    
        if (selected) {
            
            [[UUAssetManager sharedInstance] addObjectWithIndex:index];
            
        }else [[UUAssetManager sharedInstance] removeObjectWithIndex:index];
    }
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (UIImage *)displayImageWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser{

    if (_isPreview) return [[UUAssetManager sharedInstance] getImagePreviewAtIndex:index type:2];
    
    return [[UUAssetManager sharedInstance] getImageAtIndex:index type:2];
}

- (NSInteger)numberOfPhotosFromPhotoBrowser:(UUPhotoBrowserViewController *)browser{

    if (_isPreview) return [UUAssetManager sharedInstance].selectdPhotos.count;
    
    return [UUAssetManager sharedInstance].assetPhotos.count;
}

- (BOOL)isSelectedPhotosWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser{

    if (_isPreview) return [[UUAssetManager sharedInstance] isSelectdPreviewWithIndex:index];
    
    return [[UUAssetManager sharedInstance] isSelectdPhotosWithIndex:index];
}

- (NSInteger)jumpIndexFromPhotoBrowser:(UUPhotoBrowserViewController *)browser{

    return _jumpPage;
}

#pragma mark - Event Response

- (void)onClickCancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
       
        [[UUAssetManager sharedInstance].selectdPhotos removeAllObjects];
    }];
}

- (void)onClickPreview:(id)sender{

    _jumpPage = 0;
    _isPreview = YES;
    UUPhotoBrowserViewController *controller;
    controller = [[UUPhotoBrowserViewController alloc] init];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private Method

- (void)scrollToSelectedItem{
    
    NSInteger index = [[UUAssetManager sharedInstance] currentGroupFirstIndex];
    
    if (index > 0) {

        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];

    }
    
}

#pragma mark - Getters And Setters

- (UICollectionView *)getCollectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 3;
        NSInteger size = [UIScreen mainScreen].bounds.size.width / 4 -1;
        if (size % 2 != 0) size -= 1;
        
        flowLayout.itemSize = CGSizeMake(size, size);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGRect frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame) -50);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[UUThumbnailCollectionCell class]
            forCellWithReuseIdentifier:[UUThumbnailCollectionCell cellReuseIdentifier]];
        
        [[UUAssetManager sharedInstance] getPhotoListOfGroupByIndex:[UUAssetManager sharedInstance].currentGroupIndex
                                                             result:^(NSArray *obj) {
            
            [_collectionView reloadData];
            
            [self scrollToSelectedItem];
        }];
    }
    
    return _collectionView;
}

- (UUToolBarView *)getToolBarView{

    if (!_toolBarView) {
        
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) -50, ScreenWidth, 50);
        _toolBarView = [[UUToolBarView alloc] initWithWhiteColor];
        [_toolBarView addPreviewTarget:self action:@selector(onClickPreview:)];
        _toolBarView.frame = frame;
    }
    
    return _toolBarView;
}

@end
