//
//  UUPhotoActionSheet.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUPhotoActionSheet;
@protocol UUPhotoActionSheetDelegate < NSObject >

- (void)imagePickerDidFinished:(UUPhotoActionSheet *)obj;

- (void)imagePickerDidCancel:(UUPhotoActionSheet *)obj;

@end

@interface UUPhotoActionSheet : UIView

- (instancetype)initWithFrame:(CGRect)frame weakSuper:(id)weakSuper;

- (void)showAnimation;

@property (nonatomic, weak) id<UUPhotoActionSheetDelegate> delegate;

@end


