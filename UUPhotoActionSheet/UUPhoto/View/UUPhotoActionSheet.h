//
//  UUPhotoActionSheet.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNotificationSendPhotos @"NotificationSendPhotos"

@class UUPhotoActionSheet;
@protocol UUPhotoActionSheetDelegate < NSObject >

- (void)actionSheetDidFinished:(NSArray *)obj;

@end

@interface UUPhotoActionSheet : UIView

- (instancetype)initWithMaxSelected:(NSInteger )maxSelected
                          weakSuper:(id)weakSuper;

- (void)showAnimation;

@property (nonatomic, weak) id<UUPhotoActionSheetDelegate> delegate;

@end


