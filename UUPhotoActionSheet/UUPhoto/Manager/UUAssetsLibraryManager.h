//
//  UUAssetsLibraryManager.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/12.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum{

    kUUASSET_PHOTO_THUMBNAIL = 100,
    kUUASSET_PHOTO_ASPECT_THUMBNAIL,
    kUUASSET_PHOTO_SCREEN_SIZE,
    kUUASSET_PHOTO_FULL_RESOLUTION
    
}UUAssetsImageType;

typedef void(^CommonBlockCompletion)(NSArray *obj);

@interface UUAssetsLibraryManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  获取指定分组下所有图片
 *
 *  @param nGroupIndex
 *  @param completionCallback
 */
- (void)getPhotoListOfGroupByIndex:(NSInteger)groupIndex
                        completion:(CommonBlockCompletion)completionCallback;


- (UIImage *)getImageAtIndex:(NSInteger)index type:(UUAssetsImageType )type;

- (NSInteger)getGroupCount;

- (NSInteger)getPhotoCountOfCurrentGroup;

@end
