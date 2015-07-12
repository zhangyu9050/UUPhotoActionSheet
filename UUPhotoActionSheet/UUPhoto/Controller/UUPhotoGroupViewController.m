//
//  UUPhotoGroupViewController.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUPhotoGroupViewController.h"
#import "UUPhoto-Import.h"

@interface UUPhotoGroupViewController() < UITableViewDataSource,
                                          UITableViewDelegate >

@property (nonatomic, strong, getter = getTableView) UITableView *tableView;

@end

@implementation UUPhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configUI];
    [self configNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - life cycle

- (void)configUI{
    
    
    [self.view addSubview:self.tableView];
    
    [[UUAssetManager sharedInstance] getGroupList:^(NSArray *obj) {
        
        [self.tableView reloadData];
        
        [self.navigationController pushViewController:UUPhotoCollectionViewController.new animated:NO];
    }];
}

- (void)configNavigationItem{

    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor   = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlackTranslucent;
    
    
    self.navigationItem.title = @"相册";
    UIBarButtonItem *barCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(onClickCancel:)];
    
    self.navigationItem.rightBarButtonItem = barCancel;

}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[UUAssetManager sharedInstance] getGroupCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    ALAssetsGroup *group = [[UUAssetManager sharedInstance] getGroupAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[group numberOfAssets]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UUAssetManager sharedInstance].currentGroupIndex = indexPath.row;
    [self.navigationController pushViewController:UUPhotoCollectionViewController.new animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Custom Deledate

#pragma mark - Event Response

- (void)onClickCancel:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[UUAssetManager sharedInstance].selectdPhotos removeAllObjects];
    }];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Getters And Setters

- (UITableView *)getTableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    }
    
    return _tableView;
}

@end
