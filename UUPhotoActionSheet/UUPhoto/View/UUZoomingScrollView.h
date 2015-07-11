//
//  UUZoomingScrollView.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUZoomingScrollView : UIScrollView

- (void)displayImage:(UIImage *)img;

- (void)prepareForReuse;

- (void)addImageTarget:(id)target action:(SEL)action;

@end
