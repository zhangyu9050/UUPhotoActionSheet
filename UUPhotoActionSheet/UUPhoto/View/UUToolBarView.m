//
//  UUToolBarView.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUToolBarView.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"

@interface UUToolBarView()

@property (nonatomic, strong, getter = getButtonSend) UIButton *btnSend;
@property (nonatomic, strong, getter = getButtonPreview) UIButton *btnPreview;
@property (nonatomic, strong, getter = getLabelNumber) UILabel *lblNumOfSelect;


@end

@implementation UUToolBarView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    
    return self;
}

#pragma mark - life cycle

- (void)configUI{
    
    [self addSubview:self.btnSend];
    [self addSubview:self.btnPreview];
    [self addSubview:self.lblNumOfSelect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationUpdateSelected:)
                                                 name:kNotificationUpdateSelected
                                               object:nil];
    
    [self notificationUpdateSelected:nil];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Delegate

#pragma mark - Custom Deledate

#pragma mark - Event Response

- (void)addPreviewTarget:(id)target action:(SEL)action{

    [_btnPreview addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSendTarget:(id)target action:(SEL)action{
    
    [_btnSend addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)notificationUpdateSelected:(NSNotification *)note{

    self.lblNumOfSelect.hidden = NO;
    NSInteger count = [UUAssetManager sharedInstance].selectdPhotos.count;
    if (count == 0) {
        
        self.lblNumOfSelect.hidden = YES;
        return;
    }
    
    self.lblNumOfSelect.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.lblNumOfSelect.transform = CGAffineTransformMakeScale(.5, .5);
    [UIView animateWithDuration:.3
                          delay:0
         usingSpringWithDamping:.5
          initialSpringVelocity:.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
        self.lblNumOfSelect.transform = CGAffineTransformIdentity;
                         
    } completion:nil];
}

#pragma mark - Getters And Setters

- (UIButton *)getButtonPreview{
    
    if (!_btnPreview) {
        
        _btnPreview = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPreview.frame = CGRectMake(10, 0, 50, 50);
        [_btnPreview setTitle:@"预览" forState:UIControlStateNormal];
        [_btnPreview setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
        _btnPreview.backgroundColor = [UIColor clearColor];
    }
    
    return _btnPreview;
}

- (UIButton *)getButtonSend{
    
    if (!_btnSend) {
        
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.frame = CGRectMake(ScreenWidth -60, 0, 50, 50);
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
        _btnSend.backgroundColor = [UIColor clearColor];
    }
    
    return _btnSend;
}

- (UILabel *)getLabelNumber{

    if (!_lblNumOfSelect) {
        
        _lblNumOfSelect = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -80, 15, 20, 20)];
        _lblNumOfSelect.backgroundColor = COLOR_WITH_RGB(94,201,252,.9f);
        _lblNumOfSelect.textAlignment = NSTextAlignmentCenter;
        _lblNumOfSelect.textColor = [UIColor whiteColor];
        _lblNumOfSelect.font = [UIFont systemFontOfSize:13];
        _lblNumOfSelect.layer.cornerRadius = 9;
        _lblNumOfSelect.layer.borderColor = [UIColor whiteColor].CGColor;
        _lblNumOfSelect.layer.borderWidth = 1;
        _lblNumOfSelect.clipsToBounds = YES;
        _lblNumOfSelect.hidden = YES;
    }
    
    return _lblNumOfSelect;
}
@end
