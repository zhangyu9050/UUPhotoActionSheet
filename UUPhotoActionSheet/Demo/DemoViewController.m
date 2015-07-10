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

@implementation DemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"UUPhotoActionSheet";
    
    UUPhotoActionSheet *sheet;
    sheet = [[UUPhotoActionSheet alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) weakSuper:self];
    
    [self.view addSubview:sheet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
