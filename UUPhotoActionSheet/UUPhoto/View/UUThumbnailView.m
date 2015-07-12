//
//  UUThumbnailView.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUThumbnailView.h"
#import "UUPhoto-Import.h"
#import "UUPhoto-Macros.h"

@interface UUThumbnailView()< UICollectionViewDelegate,
                              UICollectionViewDataSource >

@property (nonatomic, strong, getter = getCollectionView) UICollectionView *collectionView;


@end

@implementation UUThumbnailView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    
    return self;
}

#pragma mark - life cycle

- (void)configUI{
    
    [self addSubview:self.collectionView];
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
    
    UUThumbnailCollectionCell *cell;
    cell = (UUThumbnailCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setContentSelected];
    
}


#pragma mark - Custom Deledate

#pragma mark - Event Response

#pragma mark - Public Methods

- (void)reloadView{

    [_collectionView reloadData];
}

#pragma mark - Private Methods

#pragma mark - Getters And Setters

- (UICollectionView *)getCollectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 4;
        flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 4.0f, 5.0f, 4.0f);

        flowLayout.itemSize = CGSizeMake(105, 180);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = COLOR_WITH_RGB(230,231,234,1);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[UUThumbnailCollectionCell class]
            forCellWithReuseIdentifier:[UUThumbnailCollectionCell cellReuseIdentifier]];
        
        
        [[UUAssetManager sharedInstance] getGroupList:^(NSArray *obj) {
        
            [[UUAssetManager sharedInstance] getPhotoListOfGroupByIndex:[UUAssetManager sharedInstance].currentGroupIndex result:^(NSArray *obj) {
                
                [_collectionView reloadData];
                
            }];
        }];
        
        
    }
    
    return _collectionView;
}

@end
