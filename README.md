# UUPhotoActionSheet


 ![image](https://github.com/zhangyu9050/UUPhotoActionSheet/blob/master/Screenshots/IMG_0366.jpg)


## 显示自定义ActionSheet

    _sheet = [[UUPhotoActionSheet alloc] initWithMaxSelected:9
                                                   weakSuper:self];
    _sheet.delegate = self;
    [self.navigationController.view addSubview:_sheet];
    
    [_sheet showAnimation]; //显示动画
    
    
    #pragma mark - Custom Deledate
    
    - (void)actionSheetDidFinished:(NSArray *)obj{
    
         NSLog(@"已发送 %lu 图片",(unsigned long)obj.count);
    }
