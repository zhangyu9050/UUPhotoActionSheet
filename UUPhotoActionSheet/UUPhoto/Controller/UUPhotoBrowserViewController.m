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

@end

@implementation UUPhotoBrowserViewController

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
            }
            [_visiblePages addObject:page];
            [self configurePage:page forIndex:index];
            
            [_rootScroller addSubview:page];
        }
    }
}

- (UUZoomingScrollView *)dequeueRecycledPage {
    UUZoomingScrollView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

- (void)configurePage:(UUZoomingScrollView *)page forIndex:(NSUInteger)index {
    page.frame = [self frameForPageAtIndex:index];
    page.tag = index;
    [page displayImage:[[UUAssetManager sharedInstance] getImageAtIndex:index type:2]];
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    for (UUZoomingScrollView *page in _visiblePages)
        if (page.tag == index) return YES;
    return NO;
}

#pragma mark - life cycle

- (void)configUI{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.rootScroller];
    [self.view addSubview:self.toolBarView];
    
    [self scrollViewDidScroll:nil];

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
        _toolBarView = [[UUToolBarView alloc] initWithFrame:frame];
//        [_toolBarView addPreviewTarget:self action:@selector(onClickPreview:)];
//        [_toolBarView addSendTarget:self action:@selector(onClickSend:)];
        
        _toolBarView.backgroundColor = COLOR_WITH_RGB(250,250,250,.6f);
        
    }
    
    return _toolBarView;
}

@end
