//
//  UUAssetManager.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUAssetManager.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"

@interface UUAssetManager()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray  *assetGroups;

@property (nonatomic, strong) ALAsset         *selectdAsset;

@end

@implementation UUAssetManager

SHARED_SERVICE(UUAssetManager);


- (instancetype)init{
    
    if (self = [super init]) {
        
        _selectdPhotos = [[NSMutableArray alloc] init];
        
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [_assetsLibrary writeImageToSavedPhotosAlbum:nil
                                            metadata:nil
                                     completionBlock:^(NSURL *assetURL, NSError *error) {
                                     }];
        
    }
    
    return self;
}

- (void)getGroupList:(void (^)(NSArray *))result{
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        if (group == nil){
            
            result(_assetGroups);
            return;
        }
        
        [_assetGroups insertObject:group atIndex:0];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error){
        
        NSLog(@"Error : %@", [error description]);
    };
    
    _assetGroups = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock:assetGroupEnumberatorFailure];
}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result{
    
    _assetPhotos = [[NSMutableArray alloc] init];
    [alGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [alGroup enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
        
        if(alPhoto == nil){
            
            result(_assetPhotos);
            return;
        }
        
        [_assetPhotos insertObject:alPhoto atIndex:0];
    }];
}

- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result{
    
    [self getPhotoListOfGroup:_assetGroups[nGroupIndex] result:^(NSArray *aResult) {
        
        result(_assetPhotos);
        
    }];
}

- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
            {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                
                [group enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
                    
                    if(alPhoto == nil){
                        
                        result(_assetPhotos);
                        return;
                    }
                    
                    [_assetPhotos addObject:alPhoto];
                }];
            }
        };
        
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err)
        {
            NSLog(@"Error : %@", [err description]);
            error(err);
        };
        
        _assetPhotos = [[NSMutableArray alloc] init];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:assetGroupEnumerator
                                    failureBlock:assetGroupEnumberatorFailure];
    });
}

- (NSInteger)getGroupCount{
    
    return _assetGroups.count;
}

- (NSInteger)getPhotoCountOfCurrentGroup{
    
    return _assetPhotos.count;
}

- (NSInteger)getSelectedPhotoCount{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected == %d", YES];
    NSArray *results = [_selectdPhotos filteredArrayUsingPredicate:predicate];
    
    return results.count;
}

- (void)clearData{
    
    [_selectdPhotos removeAllObjects];
    [_assetGroups removeAllObjects];
    [_assetPhotos removeAllObjects];
    
    _selectdPhotos = nil;
    
    _assetGroups   = nil;
    _assetPhotos   = nil;
}

#pragma mark - utils

- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;
    
    if (nType == ASSET_PHOTO_THUMBNAIL)
        iRef = [asset thumbnail];
    else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL)
        iRef = [asset aspectRatioThumbnail];
    else if (nType == ASSET_PHOTO_SCREEN_SIZE)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (nType == ASSET_PHOTO_FULL_RESOLUTION)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            iRef = [asset.defaultRepresentation fullResolutionImage];
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        }
        else
        {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            CIContext *context = [CIContext contextWithOptions:nil];
            CGImageRef cgimage = [context createCGImage:image fromRect:[image extent]];
            UIImage *iImage = [UIImage imageWithCGImage:cgimage scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    return [UIImage imageWithCGImage:iRef];
}

- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType
{
    return [self getImageFromAsset:(ALAsset *)_assetPhotos[nIndex] type:nType];
}

- (UIImage *)getImagePreviewAtIndex:(NSInteger)nIndex type:(NSInteger)nType
{
    UUAssetPhoto *obj = _selectdPhotos[nIndex];
    return [self getImageFromAsset:(ALAsset *)obj.asset type:nType];
}

- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex
{
    return _assetPhotos[nIndex];
}

- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex
{
    return _assetGroups[nIndex];
}

- (NSArray *)sendSelectedPhotos:(NSInteger )type{

    NSMutableArray *sendArray = [NSMutableArray array];
    for (UUAssetPhoto *obj in _selectdPhotos) {
        
        UIImage *image = [self getImageFromAsset:obj.asset type:type];
        
        [sendArray addObject:image];
    }
    
    [_selectdPhotos removeAllObjects];
    
    return sendArray;
}

- (void)addObjectWithIndex:(NSInteger )index{
    
    
    UUAssetPhoto *model = [[UUAssetPhoto alloc] initWithGroup:_currentGroupIndex
                                                        index:index
                                                        asset:_assetPhotos[index]];

    [_selectdPhotos addObject:model];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateSelected object:nil];
}

- (void)removeObjectWithIndex:(NSInteger )index{
    
    NSString *groupIndex = [NSString stringWithFormat:@"%ld-%ld",(long)_currentGroupIndex,(long)index];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupIndex == %@", groupIndex];
    NSArray *results = [_selectdPhotos filteredArrayUsingPredicate:predicate];
    
    if (results.count > 0) {
        
        UUAssetPhoto *model = results[0];
        [_selectdPhotos removeObject:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateSelected object:nil];
    }
}

- (void)markFilterPreviewObject{

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected == %d", YES];
    NSArray *results = [_selectdPhotos filteredArrayUsingPredicate:predicate];
    
    [_selectdPhotos removeAllObjects];
    [_selectdPhotos addObjectsFromArray:results];
}

- (NSInteger )markPreviewObjectWithIndex:(NSInteger )index selecte:(BOOL)selecte{
    
    UUAssetPhoto *model = _selectdPhotos[index];
    model.isSelected = selecte;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateSelected object:nil];
    
    return model.index;
}

- (BOOL)isSelectdPreviewWithIndex:(NSInteger )index{

    UUAssetPhoto *model = _selectdPhotos[index];
    return model.isSelected;
}

- (BOOL)isSelectdPhotosWithIndex:(NSInteger )index{

    NSString *groupIndex = [NSString stringWithFormat:@"%ld-%ld",(long)_currentGroupIndex,(long)index];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupIndex == %@", groupIndex];
    NSArray *results = [_selectdPhotos filteredArrayUsingPredicate:predicate];
    
    if (results.count > 0) {
        
        UUAssetPhoto *model = results[0];
        return model.isSelected;
    }
    
    return NO;
}

- (NSInteger )currentGroupFirstIndex{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %ld", (long)_currentGroupIndex];
    NSArray *results = [_selectdPhotos filteredArrayUsingPredicate:predicate];
    
    if (results.count > 0) {
        
        UUAssetPhoto *model = results[0];
        return model.index;
    }
    
    return 0;
}

@end

/****************************************************
 *  
 *  Model
 
 *
 ****************************************************/

@interface UUAssetPhoto()

@property (nonatomic, assign) NSInteger group;

@end

@implementation UUAssetPhoto


- (instancetype)initWithGroup:(NSInteger )group
                        index:(NSInteger )index
                        asset:(ALAsset *)asset{

    if (self = [super init]) {
        
        _group = group;
        _index = index;
        _asset = asset;
        _isSelected = YES;
        
        _groupIndex = [NSString stringWithFormat:@"%ld-%ld",(long)group,(long)index];
    }
    
    return self;
}

@end
