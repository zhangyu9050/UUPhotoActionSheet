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

- (NSInteger)numberOfPhotosFromPhotoBrowser:(UUPhotoBrowserViewController *)browser;

- (NSInteger)jumpIndexFromPhotoBrowser:(UUPhotoBrowserViewController *)browser;

- (BOOL)isSelectedPhotosWithIndex:(NSInteger)index fromPhotoBrowser:(UUPhotoBrowserViewController *)browser;

- (BOOL)isCheckMaxSelectedFromPhotoBrowser:(UUPhotoBrowserViewController *)browser;

- (void)displayImageWithIndex:(NSUInteger)index selectedChanged:(BOOL)selected;

@end

@interface UUPhotoBrowserViewController : UIViewController

@property (nonatomic, weak) id<UUPhotoBrowserDelegate> delegate;

@end



