//
//  UUPhoto-Macros.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#ifndef UUPhotoActionSheet_UUPhoto_Macros_h
#define UUPhotoActionSheet_UUPhoto_Macros_h

//创建单例
#ifndef SHARED_SERVICE
#define SHARED_SERVICE(ServiceName) \
+(instancetype)sharedInstance \
{ \
static ServiceName * sharedInstance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[ServiceName alloc] init]; \
}); \
return sharedInstance; \
}
#endif

//是否是iOS 7 以上版本
#define OSVersionIsAtLeastiOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

#define ApplicationWindow     [UIApplication sharedApplication].delegate.window

//屏幕宽度高度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//图片路径
#define IMAGE_PATH_WITH_NAME(NAME) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NAME]

//颜色
#define COLOR_WITH_RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

//十进制颜色
#define COLOR_WITH_RGB(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

//十进制颜色转十六进制颜色
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
