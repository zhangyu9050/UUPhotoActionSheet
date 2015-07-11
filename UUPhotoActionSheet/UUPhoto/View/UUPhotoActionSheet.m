//
//  UUPhotoActionSheet.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUPhotoActionSheet.h"
#import "UUPhoto-Macros.h"
#import "UUPhoto-Import.h"

@interface UUPhotoActionSheet() < UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate >

@property (nonatomic, strong, getter = getSheetView) UIView *sheetView;

@property (nonatomic, strong, getter = getButtonAlbum) UIButton *btnAlbum;

@property (nonatomic, strong, getter = getButtonCamera) UIButton *btnCamera;

@property (nonatomic, strong, getter = getButtonCancel) UIButton *btnCancel;

@property (nonatomic, strong, getter = getThumbnailView) UUThumbnailView *thumbnailView;

@property (nonatomic, weak) UIViewController *weakSuper;

@end

@implementation UUPhotoActionSheet

- (instancetype)initWithFrame:(CGRect)frame weakSuper:(id)weakSuper{

    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
        _weakSuper = weakSuper;
    }
    
    return self;
}

#pragma mark - life cycle

- (void)configUI{
    
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self addSubview:self.sheetView];
    
    [self.sheetView addSubview:self.btnCancel];
    [self.sheetView addSubview:self.btnAlbum];
    [self.sheetView addSubview:self.btnCamera];
    [self.sheetView addSubview:self.thumbnailView];

}

- (void)dealloc{

    _weakSuper = nil;
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [_weakSuper dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Custom Deledate

#pragma mark - Event Response

- (void)onClickCamera:(id)sender{

    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [_weakSuper presentViewController:pickerImage animated:YES completion:^{
        
    }];

}

- (void)onClickAlbum:(id)sender{

    UINavigationController *naviController;
    naviController = [[UINavigationController alloc] initWithRootViewController:UUPhotoGroupViewController.new];
    
    [_weakSuper presentViewController:naviController animated:YES completion:^{
        
    }];
}

- (void)onClickCancel:(id)sender{
    
    [self cancelAnimation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self cancelAnimation];
}

#pragma mark - Public Methods

- (void)showAnimation{
    
    CGRect frame = _sheetView.frame;
    frame.origin.y = ScreenHeight -350;
    [UIView animateWithDuration:.25f animations:^{
        
        _sheetView.frame = frame;
        self.alpha = 1;
    }];
}


#pragma mark - Private Methods

- (void)cancelAnimation{

    CGRect frame = _sheetView.frame;
    frame.origin.y = ScreenHeight;
    [UIView animateWithDuration:.25f animations:^{
        
        _sheetView.frame = frame;
        self.alpha = 0;
    }];
}


#pragma mark - Getters And Setters

- (UIView *)getSheetView{

    if (!_sheetView) {
        
        CGRect frame = CGRectMake(0, ScreenHeight, ScreenWidth, 350);
        _sheetView = [[UIView alloc] initWithFrame:frame];
        _sheetView.backgroundColor = COLOR_WITH_RGB(230,231,234,1);
        
    }
    
    return _sheetView;
}

- (UIButton *)getButtonCancel{

    if (!_btnCancel) {
        
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCancel.frame = CGRectMake(0, CGRectGetHeight(_sheetView.frame) -50, ScreenWidth, 50);
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
        _btnCancel.backgroundColor = [UIColor whiteColor];
        
        [_btnCancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _btnCancel;
}

- (UIButton *)getButtonCamera{
    
    if (!_btnCamera) {
        
        _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCamera.frame = CGRectMake(0, CGRectGetMinY(_btnAlbum.frame) -51, ScreenWidth, 50);
        [_btnCamera setTitle:@"拍照" forState:UIControlStateNormal];
        [_btnCamera setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
        _btnCamera.backgroundColor = [UIColor whiteColor];
        
        [_btnCamera addTarget:self action:@selector(onClickCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnCamera;
}


- (UIButton *)getButtonAlbum{
    
    if (!_btnAlbum) {
        
        _btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAlbum.frame = CGRectMake(0, CGRectGetMinY(_btnCancel.frame) -60, ScreenWidth, 50);
        [_btnAlbum setTitle:@"相册" forState:UIControlStateNormal];
        [_btnAlbum setTitleColor:COLOR_WITH_RGB(94,201,252,1) forState:UIControlStateNormal];
        _btnAlbum.backgroundColor = [UIColor whiteColor];
        
        [_btnAlbum addTarget:self action:@selector(onClickAlbum:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnAlbum;
}

- (UUThumbnailView *)getThumbnailView{

    if (!_thumbnailView) {
        
        CGRect frame = CGRectMake(0, 0, ScreenWidth, 190);
        _thumbnailView = [[UUThumbnailView alloc] initWithFrame:frame];
    }
    
    return _thumbnailView;
}

@end
