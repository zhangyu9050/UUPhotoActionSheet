//
//  DemoViewController.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "DemoViewController.h"
#import "UUPhotoActionSheet.h"
#import "UUPhoto-Macros.h"

@interface DemoViewController() < UUPhotoActionSheetDelegate >

@property (nonatomic, strong) UUPhotoActionSheet *sheet;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"UUPhotoActionSheet";
    
    _sheet = [[UUPhotoActionSheet alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)
                                             weakSuper:self];
    
    [self.navigationController.view addSubview:_sheet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [_sheet showAnimation];
}

#pragma mark - Custom Deledate

- (void)imagePickerDidFinished:(UUPhotoActionSheet *)obj{

    
}

- (void)imagePickerDidCancel:(UUPhotoActionSheet *)obj{

    
}

@end
