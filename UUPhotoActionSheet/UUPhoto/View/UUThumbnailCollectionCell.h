//
//  UUThumbnailCollectionCell.h
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUThumbnailCollectionCell : UICollectionViewCell

+ (NSString *)cellReuseIdentifier;

- (void)setContentWithIndexPath:(NSIndexPath *)indexPath;
- (void)setContentSelected;
@end
