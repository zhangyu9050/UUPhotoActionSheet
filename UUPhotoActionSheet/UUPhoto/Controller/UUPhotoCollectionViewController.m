//
//  UUPhotoCollectionViewController.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUPhotoCollectionViewController.h"
#import "UUPhoto-Import.h"

@interface UUPhotoCollectionViewController() < UICollectionViewDelegate,
                                               UICollectionViewDataSource >

@property (nonatomic, strong, getter = getCollectionView) UICollectionView *collectionView;


@end

@implementation UUPhotoCollectionViewController
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle

- (void)configUI{
    
    [self.view addSubview:self.collectionView];
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
    
    cell.tag = indexPath.item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.navigationController pushViewController:UUPhotoBrowserViewController.new animated:YES];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //        _collectionView.backgroundColor = COLOR_WITH_RGB(235,235,235,1);
        
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

@end
