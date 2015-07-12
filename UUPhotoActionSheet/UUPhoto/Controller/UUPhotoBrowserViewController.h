//
//  UUPhotoBrowserViewController.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class UUPhotoBrowserViewController;
@protocol UUPhotoBrowserDelegate < NSObject >

- (UIImage *)displayImageWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser;
- (BOOL)isSelectedPhotosWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser;
- (void)numberOfPhotosWithIndex:(NSUInteger)index selectedChanged:(BOOL)selected;

- (NSInteger)numberOfPhotosFromPhotoBrowser:(UUPhotoBrowserViewController *)browser;
- (NSInteger)currentIndexFromPhotoBrowser:(UUPhotoBrowserViewController *)browser;


@optional

- (void)photoBrowser:(UUPhotoBrowserViewController *)browser didShowPage:(NSInteger)page;


@end

@interface UUPhotoBrowserViewController : UIViewController

@property (nonatomic, weak) id<UUPhotoBrowserDelegate> delegate;

@end



