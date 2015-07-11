//
//  UUAssetsLibraryManager.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/12.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUAssetsLibraryManager.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"

@interface UUAssetsLibraryManager()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray  *groupsArray;
@property (nonatomic, strong) NSMutableArray  *photosArray;

@end

@implementation UUAssetsLibraryManager

SHARED_SERVICE(UUAssetsLibraryManager);


- (instancetype)init{
    
    if (self = [super init]) {
        
        _groupsArray = [[NSMutableArray alloc] init];
        _photosArray = [[NSMutableArray alloc] init];
//        _waitArray = [[NSMutableArray alloc] init];
        
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [self configDefultGroupList];
//        [self getPhotoListOfGroupByIndex:0 completion:nil];
        
    }
    
    return self;
}

- (void)configDefultGroupList{
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        if (!group) return ;
            
        [_groupsArray addObject:group];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error){
        
        NSLog(@"Error : %@", [error description]);
    };
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock:assetGroupEnumberatorFailure];
}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)group
                 completion:(CommonBlockCompletion)completionCallback{

    [_photosArray removeAllObjects];
    
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    [group enumerateAssetsUsingBlock:^(ALAsset *allPhoto, NSUInteger index, BOOL *stop) {
        
        if(!allPhoto) {
        
            completionCallback(_photosArray);
            return ;
        }
            
        [_photosArray addObject:allPhoto];
        
    }];
}

- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(UUAssetsImageType )type{
    
    CGImageRef iRef = nil;

    switch (type) {
        case kUUASSET_PHOTO_THUMBNAIL:
            iRef = [asset thumbnail];
            break;
        case kUUASSET_PHOTO_ASPECT_THUMBNAIL:
            iRef = [asset aspectRatioThumbnail];
            break;
        case kUUASSET_PHOTO_SCREEN_SIZE:
            iRef = [asset.defaultRepresentation fullScreenImage];
            break;
    }
    
    return [UIImage imageWithCGImage:iRef];
}

#pragma mark - Public

- (void)getPhotoListOfGroupByIndex:(NSInteger)groupIndex
                        completion:(CommonBlockCompletion)completionCallback{
    
    [self getPhotoListOfGroup:_groupsArray[groupIndex] completion:^(NSArray *obj) {
     
        completionCallback(obj);
        
    }];
}

- (UIImage *)getImageAtIndex:(NSInteger)index type:(UUAssetsImageType )type{

    return [self getImageFromAsset:_photosArray[index] type:type];
}

- (NSInteger)getGroupCount{

    return _groupsArray.count;
}

- (NSInteger)getPhotoCountOfCurrentGroup{

    return _photosArray.count;
}

@end
