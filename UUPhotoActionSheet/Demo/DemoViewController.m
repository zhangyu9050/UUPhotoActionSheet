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
#import "UUPhoto-Import.h"

@interface DemoViewController() < UUPhotoActionSheetDelegate >

@property (nonatomic, strong) UUPhotoActionSheet *sheet;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"UUPhotoActionSheet";
    
    _sheet = [[UUPhotoActionSheet alloc] initWithMaxSelected:9
                                                   weakSuper:self];
    
    _sheet.delegate = self;
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

- (void)actionSheetDidFinished:(NSArray *)obj{

    NSLog(@"已发送 %lu 图片",(unsigned long)obj.count);
}

@end
