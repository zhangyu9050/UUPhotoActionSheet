//
//  UUAssetManager.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUAssetManager.h"
#import "UUPhoto-Macros.h"

@interface UUAssetManager()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray  *assetGroups;

@property (nonatomic, strong) NSMutableArray  *waitArray;

@property (nonatomic, strong) NSMutableArray  *defaultAssets;
@property (nonatomic, strong) NSString        *originStr;
@property (nonatomic, strong) ALAsset         *selectdAsset;

@end

@implementation UUAssetManager

SHARED_SERVICE(UUAssetManager);


- (instancetype)init{
    
    if (self = [super init]) {
        
        _selectdPhotos = [[NSMutableArray alloc] init];
        _selectdAssets = [[NSMutableArray alloc] init];
        _waitArray = [[NSMutableArray alloc] init];
        
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [_assetsLibrary writeImageToSavedPhotosAlbum:nil
                                            metadata:nil
                                     completionBlock:^(NSURL *assetURL, NSError *error) {
                                     }];
        
    }
    
    return self;
}

- (void)setCameraRollAtFirst{
    
    for (ALAssetsGroup *group in _assetGroups){
        
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos){
            
            // send to head
            [_assetGroups removeObject:group];
            [_assetGroups insertObject:group atIndex:0];
            
            return;
        }
    }
}

- (void)getGroupList:(void (^)(NSArray *))result{
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        if (group == nil)
        {
            //            if (_bReverse)
            _assetGroups = [[NSMutableArray alloc] initWithArray:[[_assetGroups reverseObjectEnumerator] allObjects]];
            
            [self setCameraRollAtFirst];
            
            // end of enumeration
            result(_assetGroups);
            return;
        }
        
        [_assetGroups addObject:group];
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
        
        if(alPhoto == nil)
        {
            //            if (_bReverse) {
            if (_defaultAssets) {
                [_assetPhotos addObjectsFromArray:_defaultAssets];
                //                }
                
                [_defaultAssets addObject:@"camera"];
                
                _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
            }
            
            result(_assetPhotos);
            return;
        }
        
        [_assetPhotos addObject:alPhoto];
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
                    
                    if(alPhoto == nil)
                    {
                        //                        if (_bReverse)
                        _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
                        
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

- (NSDictionary *)getGroupInfo:(NSInteger)nIndex{
    
    return @{@"name"  : [_assetGroups[nIndex] valueForProperty:ALAssetsGroupPropertyName],
             @"count" : @([_assetGroups[nIndex] numberOfAssets])};
}

- (void)clearData{
    
    [_selectdAssets removeAllObjects];
    [_selectdPhotos removeAllObjects];
    [_defaultAssets removeAllObjects];
    
    _selectdPhotos = nil;
    _selectdAssets = nil;
    
    _defaultAssets = nil;
    _assetGroups   = nil;
    _assetPhotos   = nil;
}

- (NSMutableArray *)defaultAssets{
    
    if (!_defaultAssets) _defaultAssets = [[NSMutableArray alloc] init];
    return _defaultAssets;
}

- (NSMutableArray *)selectdAssets{
    
    if (!_selectdAssets) _selectdAssets = [[NSMutableArray alloc] init];
    return _selectdAssets;
}

- (NSMutableArray *)selectdPhotos{
    
    if (!_selectdPhotos) _selectdPhotos = [[NSMutableArray alloc] init];
    return _selectdPhotos;
}

#pragma mark - utils

- (UIImage *)getCroppedImage:(NSURL *)urlImage
{
    __block UIImage *iImage = nil;
    __block BOOL bBusy = YES;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        NSString *strXMP = rep.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            CGImageRef iref = [rep fullResolutionImage];
            if (iref)
                iImage = [UIImage imageWithCGImage:iref scale:1.0 orientation:(UIImageOrientation)rep.orientation];
            else
                iImage = nil;
        }
        else
        {
            // to get edited photo by photo app
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:rep.fullResolutionImage];
            
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
            
            iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)rep.orientation];
        }
        
        bBusy = NO;
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    [_assetsLibrary assetForURL:urlImage
                    resultBlock:resultblock
                   failureBlock:failureblock];
    
    while (bBusy)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    return iImage;
}

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

- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex
{
    return _assetPhotos[nIndex];
}

- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex
{
    return _assetGroups[nIndex];
}

- (void)addObjectWithIndex:(NSInteger )index{
    
    NSInteger section = _currentGroupIndex;
    
    UUWaitImage *model = [[UUWaitImage alloc] init];
    model.indexPath = [NSIndexPath indexPathForRow:index inSection:section];
    
    model.waitAsset = _assetPhotos[index];
    
    [_selectdPhotos addObject:model];
}

- (void)removeObjectWithIndex:(NSInteger )index{
    
    for (UUWaitImage *obj in _selectdPhotos) {
        
        if (index == obj.indexPath.row && obj.indexPath.section == _currentGroupIndex) {
            
            [_selectdPhotos removeObject:obj];
            return;
        }
    }
}

@end

@implementation UUWaitImage



@end
