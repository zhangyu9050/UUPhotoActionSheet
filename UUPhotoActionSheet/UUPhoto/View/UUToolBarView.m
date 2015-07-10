//
//  UUToolBarView.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUToolBarView.h"
#import "UUPhoto-Macros.h"

@interface UUToolBarView()

@property (nonatomic, strong, getter = getButtonSend) UIButton *btnSend;
@property (nonatomic, strong, getter = getButtonPreview) UIButton *btnPreview;


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
@end
