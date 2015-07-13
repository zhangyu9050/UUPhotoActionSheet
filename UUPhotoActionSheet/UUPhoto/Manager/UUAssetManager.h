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

//可选最大数
@property (nonatomic, assign) NSInteger maxSelected;

@property (nonatomic, assign) NSInteger currentGroupIndex;

//当前Group图片数组
@property (nonatomic, strong) NSMutableArray  *assetPhotos;

//选中对象数组
@property (nonatomic, strong) NSMutableArray  *selectdPhotos;

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
- (NSInteger)getSelectedPhotoCount;
- (NSInteger)getPhotoCountOfCurrentGroup;

- (void)clearData;

// utils
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType;
- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType;
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex;
- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex;
- (UIImage *)getImagePreviewAtIndex:(NSInteger)nIndex type:(NSInteger)nType;

- (void)addObjectWithIndex:(NSInteger )index;
- (void)removeObjectWithIndex:(NSInteger )index;

//过滤未选择
- (void)markFilterPreviewObject;

//标记选择项
- (NSInteger )markPreviewObjectWithIndex:(NSInteger )index selecte:(BOOL)selecte;

- (BOOL)isSelectdPreviewWithIndex:(NSInteger )index;
- (BOOL)isSelectdPhotosWithIndex:(NSInteger )index;
- (NSArray *)sendSelectedPhotos:(NSInteger )type;
- (NSInteger )currentGroupFirstIndex;

@end

@interface UUAssetPhoto : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *groupIndex;

- (instancetype)initWithGroup:(NSInteger )group
                        index:(NSInteger )index
                        asset:(ALAsset *)asset;

@end
