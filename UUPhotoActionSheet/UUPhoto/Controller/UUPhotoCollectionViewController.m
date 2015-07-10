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
                                               UICollectionViewDataSource >

@property (nonatomic, strong, getter = getCollectionView) UICollectionView *collectionView;
@property (nonatomic, strong, getter = getToolBarView) UUToolBarView *toolBarView;

@end

@implementation UUPhotoCollectionViewController
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
    
    [self.navigationController pushViewController:UUPhotoBrowserViewController.new animated:YES];
}

#pragma mark - Event Response

- (void)onClickCancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onClickPreview:(id)sender{

    [self.navigationController pushViewController:UUPhotoBrowserViewController.new animated:YES];
}

- (void)onClickSend:(id)sender{
    
    
}

#pragma mark - Private Method

- (void)scrollToSelectedItem{
    
    NSInteger groupIndex = [UUAssetManager sharedInstance].currentGroupIndex;
    for (UUWaitImage *obj in [UUAssetManager sharedInstance].selectdPhotos) {
        
        if (obj.indexPath.section == groupIndex) {
            
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:obj.indexPath.row inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:NO];
            return;
        }
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
        
        [[UUAssetManager sharedInstance] getPhotoListOfGroupByIndex:[UUAssetManager sharedInstance].currentGroupIndex result:^(NSArray *r) {
//            [[UUImageManager sharedInstance] startCahcePhotoThumbWithSize:CGSizeMake(size, size)];
            [_collectionView reloadData];
            if ([UUAssetManager sharedInstance].previewIndex>=0) {
                //                JFPhotoBrowserViewController *photoBrowser = [[JFPhotoBrowserViewController alloc] initWithPreview];
                //                photoBrowser.delegate = self.navigationController;
                //                [self.navigationController pushViewController:photoBrowser animated:YES];
            }
            
            [self scrollToSelectedItem];
        }];
    }
    
    return _collectionView;
}

- (UUToolBarView *)getToolBarView{

    if (!_toolBarView) {
        
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) -50, ScreenWidth, 50);
        _toolBarView = [[UUToolBarView alloc] initWithFrame:frame];
        [_toolBarView addPreviewTarget:self action:@selector(onClickPreview:)];
        [_toolBarView addSendTarget:self action:@selector(onClickSend:)];
        
        _toolBarView.backgroundColor = COLOR_WITH_RGB(250,250,250,1);
        
        _toolBarView.layer.borderWidth = 1;
        _toolBarView.layer.borderColor = COLOR_WITH_RGB(224,224,224,1).CGColor;
    }
    
    return _toolBarView;
}

@end
