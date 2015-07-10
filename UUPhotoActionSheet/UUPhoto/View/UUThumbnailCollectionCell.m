//
//  UUThumbnailCollectionCell.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUThumbnailCollectionCell.h"
#import "UUPhoto-Import.h"

@interface UUThumbnailCollectionCell()

@property (nonatomic, strong, getter = getImageThumbnails) UIImageView *imgThumbnails;
@property (nonatomic, strong, getter = getImageSelected) UIImageView *imgSelected;

@property (nonatomic, assign) BOOL isCheckSelected;

@end

@implementation UUThumbnailCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    
    return self;
}

#pragma mark - life cycle

- (void)configUI{
    
    [self addSubview:self.imgThumbnails];
    [self addSubview:self.imgSelected];
}

#pragma mark - Delegate

#pragma mark - Custom Deledate

#pragma mark - Event Response

#pragma mark - Public Methods

+ (NSString *)cellReuseIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void)setContentWithIndexPath:(NSIndexPath *)indexPath{

    self.imgThumbnails.image = [[UUAssetManager sharedInstance] getImageAtIndex:indexPath.row type:1];
}

#pragma mark - Private Methods

- (void)setIsCheckSelected:(BOOL)isCheckSelected{
    
    
    if (isCheckSelected) {
        
        _imgSelected.image = [UIImage imageNamed:@"ImageSelectedOn"];
        
        _imgSelected.transform = CGAffineTransformMakeScale(.5f, .5f);
        [UIView animateWithDuration:.3f
                              delay:0
             usingSpringWithDamping:.5f
              initialSpringVelocity:.5f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             _imgSelected.transform = CGAffineTransformIdentity;
                             
                         } completion:nil];
        
    } else {
        
        _imgSelected.image = [UIImage imageNamed:@"ImageSelectedOff"];
    }
    
    _isCheckSelected = isCheckSelected;
}

#pragma mark - Getters And Setters

- (UIImageView *)getImageThumbnails{
    
    if (!_imgThumbnails) {
        
        _imgThumbnails = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgThumbnails.contentMode = UIViewContentModeScaleAspectFill;
        _imgThumbnails.clipsToBounds = YES;
    }
    
    return _imgThumbnails;
}


- (UIImageView *)getImageSelected{
    
    if (!_imgSelected) {
        
        _imgSelected = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) -30, 4, 26, 26)];
        _imgSelected.contentMode = UIViewContentModeScaleAspectFill;
        _imgSelected.userInteractionEnabled = YES;
        _imgSelected.layer.cornerRadius = 13;
        _imgSelected.layer.borderWidth = 1;
        _imgSelected.layer.masksToBounds = YES;
        
    }
    
    return _imgSelected;
}


@end
