//
//  UUZoomingScrollView.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUZoomingScrollView.h"
#import "UUPhoto-Macros.h"

@interface UUZoomingScrollView() < UIScrollViewDelegate >

@property (nonatomic, strong, getter = getImagePhoto) UIImageView *imgPhoto;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation UUZoomingScrollView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self configUI];
    }
    
    return self;
}

- (void)dealloc{

    _imgPhoto.image = nil;
    _singleTap = nil;
    _imgPhoto = nil;
}

- (void)configUI{

    self.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.imgPhoto];
    self.scrollEnabled = NO;
}

- (void)displayImage:(UIImage *)img{
    
    if (_imgPhoto.image == nil) {
        
        // Reset
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeMake(0, 0);
        
        if (img) {
            
            // Set image
            _imgPhoto.image = img;
            
            // Setup photo frame
            CGRect photoImageViewFrame;
            photoImageViewFrame.origin = CGPointZero;
            photoImageViewFrame.size = img.size;
            _imgPhoto.frame = photoImageViewFrame;
            self.contentSize = photoImageViewFrame.size;
            
            // Set zoom to minimum zoom
            [self setMaxMinZoomScalesForCurrentBounds];
        }
    
        [self setNeedsLayout];
    }
    
    
}

#pragma mark - Private Modeh

- (void)layoutSubviews {
    
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imgPhoto.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_imgPhoto.frame, frameToCenter))
        _imgPhoto.frame = frameToCenter;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_imgPhoto.image == nil) return;
    
    // Reset position
    _imgPhoto.frame = CGRectMake(0, 0, _imgPhoto.frame.size.width, _imgPhoto.frame.size.height);
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _imgPhoto.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
    CGFloat maxScale = 3;
    
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
    }
    
    // Layout
    [self setNeedsLayout];
    
}

- (void)prepareForReuse{
    
    _imgPhoto.image = nil;
    self.tag = NSUIntegerMax;
}

- (CGFloat)initialZoomScaleWithMinScale {
    
    CGFloat zoomScale = self.minimumZoomScale;
    
    if (_imgPhoto) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _imgPhoto.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imgPhoto;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    self.scrollEnabled = YES; // reset
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)addImageTarget:(id)target action:(SEL)action {
    
    [_singleTap addTarget:target action:action];
}

#pragma mark - Getters And Setters

- (UIImageView *)getImagePhoto{
    
    if (!_imgPhoto) {
        
        _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgPhoto.contentMode = UIViewContentModeCenter;
        _imgPhoto.backgroundColor = [UIColor blackColor];
        _imgPhoto.userInteractionEnabled = YES;
        
        _singleTap = [[UITapGestureRecognizer alloc] init];
        [_imgPhoto addGestureRecognizer:_singleTap];
    }
    
    return _imgPhoto;
}

@end
