//
//  ViewController.m
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/17.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "NestContentScrollView.h"
#import "PinnedView.h"

#define App_Navigation_Height self.navigationController.navigationBar.frame.size.height
#define App_Status_Height [[UIApplication sharedApplication] statusBarFrame].size.height
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
static const CGFloat Nest_HeaderScrollView_Height = 280;
static const CGFloat Nest_PinneView_height = 44;

@interface ViewController ()<UIScrollViewDelegate,NestContentScrollViewChangeCurrentColletionViewDelegate>
@property (strong, nonatomic) NestContentScrollView *nestScrollView;
@property (strong, nonatomic) PinnedView *pinnedView;
@property (nonatomic, assign) CGRect pinnedViewInitFrame;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nestScrollView = [[NestContentScrollView alloc]initWithFrame:CGRectMake(0, App_Navigation_Height+App_Status_Height, Main_Screen_Width, Main_Screen_Height-(App_Navigation_Height+App_Status_Height)) headerHeight:Nest_HeaderScrollView_Height pinnerHeight:Nest_PinneView_height];
    _nestScrollView.delegate = self;
    _nestScrollView.changeColletionViewDelegate = self;
    _nestScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(Nest_HeaderScrollView_Height+Nest_PinneView_height, 0, 0, 0);
    [_nestScrollView addSubview:_pinnedView];
    [self.view addSubview:_nestScrollView];
    
    __weak __typeof(self)WeakSelf = self;
    WeakSelf.nestScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf.nestScrollView.mj_header endRefreshing];
            [WeakSelf createColletionDataWithCurrentColletionType:WeakSelf.nestScrollView.currentIndex isRelaod:YES];
            [WeakSelf.nestScrollView.currentColletionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [WeakSelf NestContentScrollViewDidChangedCurrentColletionView:WeakSelf.nestScrollView currentIdenx:WeakSelf.nestScrollView.currentIndex];
            });
            
        });
    }];
    _nestScrollView.mj_header.ignoredScrollViewContentInsetTop = -(Nest_HeaderScrollView_Height+Nest_PinneView_height);
    [_nestScrollView.mj_header beginRefreshing];
    
    WeakSelf.nestScrollView.collectionContainerScrollView.leftColletionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf createColletionDataWithCurrentColletionType:WeakSelf.nestScrollView.currentIndex isRelaod:NO];
            [WeakSelf.nestScrollView.collectionContainerScrollView.leftColletionView.mj_footer endRefreshing];
            [WeakSelf.nestScrollView.collectionContainerScrollView.leftColletionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [WeakSelf NestContentScrollViewDidChangedCurrentColletionView:WeakSelf.nestScrollView currentIdenx:WeakSelf.nestScrollView.currentIndex];
            });
        });
    }];
    
    WeakSelf.nestScrollView.collectionContainerScrollView.rightColletionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf createColletionDataWithCurrentColletionType:WeakSelf.nestScrollView.currentIndex isRelaod:NO];
            [WeakSelf.nestScrollView.collectionContainerScrollView.rightColletionView.mj_footer endRefreshing];
            [WeakSelf.nestScrollView.collectionContainerScrollView.rightColletionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [WeakSelf NestContentScrollViewDidChangedCurrentColletionView:WeakSelf.nestScrollView currentIdenx:WeakSelf.nestScrollView.currentIndex];
            });
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createColletionDataWithCurrentColletionType:(NSInteger)currentType isRelaod:(BOOL)reload{
    NSInteger total = 30;
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < total; i++) {
        [list addObject:@(MAX(100, arc4random() % 200))];
    }
    if(currentType == 0){
        if(!_nestScrollView.collectionContainerScrollView.leftCollectionViewData)_nestScrollView.collectionContainerScrollView.leftCollectionViewData = [NSMutableArray array];
        if(reload)[_nestScrollView.collectionContainerScrollView.leftCollectionViewData removeAllObjects];
        [_nestScrollView.collectionContainerScrollView.leftCollectionViewData addObjectsFromArray:list];
        return;
    }
    if(!_nestScrollView.collectionContainerScrollView.rightCollectionViewData)_nestScrollView.collectionContainerScrollView.rightCollectionViewData = [NSMutableArray array];
    if(reload)[_nestScrollView.collectionContainerScrollView.rightCollectionViewData removeAllObjects];
    [_nestScrollView.collectionContainerScrollView.rightCollectionViewData addObjectsFromArray:list];
}

#pragma mark- 切换colletionView

- (void)NestContentScrollViewDidChangedCurrentColletionView:(NestContentScrollView *)nestContentScrollView
                                               currentIdenx:(NSInteger)currentIndex{
    nestContentScrollView.contentSize = CGSizeMake(0,Nest_HeaderScrollView_Height+Nest_PinneView_height+nestContentScrollView.currentColletionView.contentSize.height+44);
    //右边没有有数据时自动请求数据
    if(currentIndex == 1 && _nestScrollView.collectionContainerScrollView.rightCollectionViewData.count == 0)[_nestScrollView.mj_header beginRefreshing];
}


#pragma mark- NestScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat nestScrollViewContentOffsetY = self.nestScrollView.contentOffset.y;
    if(nestScrollViewContentOffsetY <= 0.0){
        _nestScrollView.headerView.frame = (CGRect){.origin=CGPointMake(0, nestScrollViewContentOffsetY),.size= _nestScrollView.headerView.bounds.size};
        
        _nestScrollView.pinnedView.frame = (CGRect){.origin=CGPointMake(0, nestScrollViewContentOffsetY+Nest_HeaderScrollView_Height),.size=CGSizeMake(Main_Screen_Width, Nest_PinneView_height)};
    }else if(nestScrollViewContentOffsetY >= Nest_HeaderScrollView_Height){ //pinnedView悬浮的距离
        _nestScrollView.pinnedView.frame = (CGRect){.origin=CGPointMake(0, nestScrollViewContentOffsetY),.size=CGSizeMake(Main_Screen_Width, Nest_PinneView_height)};
        
        _nestScrollView.collectionContainerScrollView.frame = (CGRect){.origin=CGPointMake(0, nestScrollViewContentOffsetY+Nest_PinneView_height), .size=CGSizeMake(_nestScrollView.collectionContainerScrollView.frame.size.width, Main_Screen_Height-(App_Navigation_Height+App_Status_Height)-Nest_PinneView_height)};
        
        [_nestScrollView.currentColletionView setContentOffset:CGPointMake(0, nestScrollViewContentOffsetY-Nest_HeaderScrollView_Height)];
        
        
    }else{
        _nestScrollView.pinnedView.frame = (CGRect){.origin=CGPointMake(0, Nest_HeaderScrollView_Height),.size=CGSizeMake(Main_Screen_Width, Nest_PinneView_height)};
        
        _nestScrollView.collectionContainerScrollView.frame = (CGRect){.origin=CGPointMake(0, Nest_HeaderScrollView_Height+Nest_PinneView_height), .size=CGSizeMake(_nestScrollView.collectionContainerScrollView.frame.size.width,  Main_Screen_Height-(App_Navigation_Height+App_Status_Height)-(Nest_HeaderScrollView_Height+Nest_PinneView_height)+nestScrollViewContentOffsetY)};
        
        [_nestScrollView.currentColletionView setContentOffset:CGPointZero];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}


@end
