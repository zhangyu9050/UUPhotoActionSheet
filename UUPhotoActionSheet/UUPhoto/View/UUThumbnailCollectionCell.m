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

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isCheckSelected;

@end

@implementation UUThumbnailCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    
    return self;
}

- (void)prepareForReuse{

    [super prepareForReuse];
    
    _imgThumbnails.image = nil;
    _isCheckSelected = NO;
    
}

#pragma mark - life cycle

- (void)configUI{
    
    [self addSubview:self.imgThumbnails];
    [self addSubview:self.imgSelected];
}

#pragma mark - Delegate

#pragma mark - Custom Deledate

#pragma mark - Event Response

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture{
    
    CGPoint location = [gesture locationInView:self];
    
    if ([self isContainsPointWithPoint:location]) {
        
        [self setContentSelected];
    }
}

#pragma mark - Public Methods

+ (NSString *)cellReuseIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void)setContentWithIndexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;
    
    self.imgThumbnails.image = [[UUAssetManager sharedInstance] getImageAtIndex:indexPath.row type:1];
    
    [self setIsCheckSelected:[[UUAssetManager sharedInstance] isSelectdPhotosWithIndex:indexPath.row]];

}

- (void)setContentSelected{

    NSInteger max = [UUAssetManager sharedInstance].maxSelected;
    if (!_isCheckSelected && [UUAssetManager sharedInstance].selectdPhotos.count >= max) {
    
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您最多只能选择%d张图片",(int)max]
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确认", nil];
        
        [alter show];
        return;
    }
    
    if (!_isCheckSelected) {
        
        [[UUAssetManager sharedInstance] addObjectWithIndex:_indexPath.row];
        
        [self setIsCheckSelected:YES];
        
    }else{
        
        
        [[UUAssetManager sharedInstance] removeObjectWithIndex:_indexPath.row];
        
        [self setIsCheckSelected:NO];
    }

}

#pragma mark - Private Methods

- (BOOL )isContainsPointWithPoint:(CGPoint )location{
    
    CGFloat x = CGRectGetMinX(_imgSelected.frame)   -5;
    CGFloat y = CGRectGetMinY(_imgSelected.frame)   -5;
    CGFloat w = CGRectGetWidth(_imgSelected.frame)  +10;
    CGFloat h = CGRectGetHeight(_imgSelected.frame) +10;
    
    return CGRectContainsPoint(CGRectMake(x, y, w, h), location);
}

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
        _imgSelected.layer.masksToBounds = YES;
        _imgSelected.layer.cornerRadius = 13;
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        
        [_imgSelected addGestureRecognizer:singleRecognizer];
        
    }
    
    return _imgSelected;
}


@end
