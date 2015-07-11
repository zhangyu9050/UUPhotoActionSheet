//
//  UUPhotoBrowserViewController.m
//  UUPhotoActionSheet
//
//  Created by zhangyu on 15/7/10.
//  Copyright (c) 2015年 zhangyu. All rights reserved.
//

#import "UUPhotoBrowserViewController.h"
#import "UUPhoto-Import.h"
#import "UUPhoto-Macros.h"

#define PADDING 10

@interface UUPhotoBrowserViewController() < UIScrollViewDelegate >{
    
    NSMutableSet *_visiblePages, *_recycledPages;
}

@property (nonatomic, strong, getter = getRootScrollView) UIScrollView *rootScroller;
@property (nonatomic, strong, getter = getToolBarView) UUToolBarView *toolBarView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation UUPhotoBrowserViewController

- (instancetype)initWithJumpToPage:(NSInteger )index{

    if (self = [super init]) {
     
        _currentPage = index;
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle

- (void)configUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.rootScroller];
    [self.view addSubview:self.toolBarView];
    
    [self jumpToPageAtIndex:_currentPage animated:NO];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger numberOfPhotos = [UUAssetManager sharedInstance].assetPhotos.count;
    CGRect visibleBounds = _rootScroller.bounds;
    NSInteger iFirstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
    NSInteger iLastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > numberOfPhotos - 1) iFirstIndex = numberOfPhotos - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > numberOfPhotos - 1) iLastIndex = numberOfPhotos - 1;
    
    NSInteger pageIndex;
    for (UUZoomingScrollView *page in _visiblePages) {
        pageIndex = page.tag;
        if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
            [_recycledPages addObject:page];
            
            [page prepareForReuse];
            [page removeFromSuperview];
        }
    }
    
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
    
    // Add missing pages
    for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            
            // Add new page
            UUZoomingScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                page = [[UUZoomingScrollView alloc] init];
                [page addImageTarget:self action:@selector(onClickImageBrowser:)];
            }
            [_visiblePages addObject:page];
            [self configurePage:page forIndex:index];
            
            [_rootScroller addSubview:page];
        }
    }
}

- (void)onClickImageBrowser:(UIGestureRecognizer *)gesture{

    [self setHideNavigationBar];
}

#pragma mark - Private Methods

- (void)setHideNavigationBar{

    CGRect frame = _toolBarView.frame;
    if (self.navigationController.navigationBarHidden) {
        
        frame.origin.y = ScreenHeight -50;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        
    } else {
        
        frame.origin.y = ScreenHeight;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [UIView animateWithDuration:.25f animations:^{
        
        _toolBarView.frame = frame;
    }];
}

- (void)jumpToPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
    
    // Change page
    NSInteger numberOfPhotos = [UUAssetManager sharedInstance].assetPhotos.count;
    if (index < numberOfPhotos) {
        CGRect pageFrame = [self frameForPageAtIndex:index];
        [_rootScroller setContentOffset:CGPointMake(pageFrame.origin.x - PADDING, 0) animated:animated];
    }
    
}


- (UUZoomingScrollView *)dequeueRecycledPage {
    
    UUZoomingScrollView *page = [_recycledPages anyObject];
    if (page) [_recycledPages removeObject:page];
    
    return page;
}

- (void)configurePage:(UUZoomingScrollView *)page forIndex:(NSUInteger)index {
    
    page.tag = index;
    page.frame = [self frameForPageAtIndex:index];
    [page displayImage:[[UUAssetManager sharedInstance] getImageAtIndex:index type:2]];
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    
    for (UUZoomingScrollView *page in _visiblePages){
    
        if (page.tag == index) return YES;
    }
    
    return NO;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    
    CGRect bounds = _rootScroller.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}

- (CGRect)frameForPagingScrollView {
    
    CGRect frame = self.view.bounds;
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}

- (CGSize)contentSizeForPagingScrollView {
    
    CGRect bounds = _rootScroller.bounds;
    return CGSizeMake(bounds.size.width * [UUAssetManager sharedInstance].assetPhotos.count, 0);
}


#pragma mark - Getters And Setters

- (UIScrollView *)getRootScrollView{
    
    if (!_rootScroller) {
        
        _rootScroller = [[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
        _rootScroller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rootScroller.pagingEnabled = YES;
        _rootScroller.delegate = self;
        _rootScroller.showsHorizontalScrollIndicator = NO;
        _rootScroller.showsVerticalScrollIndicator = NO;
        _rootScroller.backgroundColor = [UIColor blackColor];
        _rootScroller.contentSize = [self contentSizeForPagingScrollView];
    }
    
    return _rootScroller;
}

- (UUToolBarView *)getToolBarView{
    
    if (!_toolBarView) {
        
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) -50, ScreenWidth, 50);
        _toolBarView = [[UUToolBarView alloc] initWithBlackColor];
        _toolBarView.frame = frame;
//        [_toolBarView addPreviewTarget:self action:@selector(onClickPreview:)];
//        [_toolBarView addSendTarget:self action:@selector(onClickSend:)];
        
        
        
    }
    
    return _toolBarView;
}

@end
