//
//  UUAssetManager.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3

@interface UUAssetManager : NSObject

@property (nonatomic, assign) NSInteger currentGroupIndex;
@property (nonatomic, assign) NSInteger previewIndex;
@property (nonatomic, assign) BOOL      bReverse;

@property (nonatomic, strong) NSMutableArray  *assetPhotos;
@property (nonatomic, strong) NSMutableArray  *selectdPhotos;
@property (nonatomic, strong) NSMutableArray  *selectdAssets;

+ (instancetype)sharedInstance;

// get album list from asset
- (void)getGroupList:(void (^)(NSArray *))result;
// get photos from specific album with ALAssetsGroup object
- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result;
// get photos from specific album with index of album array
- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result;
// get photos from camera roll
- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error;

- (NSInteger)getGroupCount;
- (NSInteger)getPhotoCountOfCurrentGroup;
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex;

- (void)clearData;

// utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage;
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType;
- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType;
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex;
- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex;


- (void)addObjectWithIndex:(NSInteger )index;
- (void)removeObjectWithIndex:(NSInteger )index;

@end

@interface UUWaitImage : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ALAsset *waitAsset;

@end
