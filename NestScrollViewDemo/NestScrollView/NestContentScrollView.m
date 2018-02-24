//
//  NestContentScrollView.m
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/17.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import "NestContentScrollView.h"

@implementation NestContentScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 20)];
    _titleLabel.text = @"这是一个label";
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_titleLabel];
}

@end

@interface NestContentScrollView()<UIScrollViewDelegate>
@property (assign, nonatomic) CGFloat frameWith;
@end

@implementation NestContentScrollView

- (instancetype)initWithFrame:(CGRect)frame
                 headerHeight:(CGFloat)headerHeight
                 pinnerHeight:(CGFloat)pinnerHeight{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor orangeColor];
        self.frameWith = frame.size.width;
        [self createSubviewsWithFrameWidth:frame.size.width frameHeight:frame.size.height headerHeight:headerHeight pinnerHeight:pinnerHeight];
    }
    return self;
}

- (void)createSubviewsWithFrameWidth:(CGFloat)frameWidth
                         frameHeight:(CGFloat)frameHeight
                        headerHeight:(CGFloat)headerHeight
                        pinnerHeight:(CGFloat)pinnerHeight{
    self.headerView = [[NestContentScrollHeaderView alloc]initWithFrame:CGRectMake(0, 0, frameWidth, headerHeight)];
    [self addSubview:_headerView];
    
    self.collectionContainerScrollView = [[CollectionContainerScrollView alloc]initWithFrame:CGRectMake(0, headerHeight+pinnerHeight, frameWidth, frameHeight-(headerHeight+pinnerHeight))];
    _collectionContainerScrollView.delegate = self;
    [self addSubview:_collectionContainerScrollView];
    
    self.pinnedView = [[PinnedView alloc]initWithFrame:CGRectMake(0, headerHeight, frameWidth, pinnerHeight)];
    _pinnedViewInitFrame = _pinnedView.frame;
    __weak typeof(self)WeakSelf = self;
    _pinnedView.didSelectChangeType = ^(NSInteger type) {
        if(type == WeakSelf.currentIndex)return ;
        WeakSelf.currentIndex = type;
        [WeakSelf.collectionContainerScrollView setContentOffset:CGPointMake(type*WeakSelf.collectionContainerScrollView.bounds.size.width, 0) animated:YES];
        if(WeakSelf.contentOffset.y>WeakSelf.pinnedViewInitFrame.origin.y)[WeakSelf setContentOffset:CGPointMake(0, WeakSelf.pinnedViewInitFrame.origin.y)];
        [WeakSelf.collectionContainerScrollView.leftColletionView setContentOffset:CGPointZero];
        [WeakSelf.collectionContainerScrollView.rightColletionView setContentOffset:CGPointZero];
        WeakSelf.currentColletionView = type?WeakSelf.collectionContainerScrollView.rightColletionView:WeakSelf.collectionContainerScrollView.leftColletionView;
        if([WeakSelf.changeColletionViewDelegate respondsToSelector:@selector(NestContentScrollViewDidChangedCurrentColletionView:currentIdenx:)]){
            [WeakSelf.changeColletionViewDelegate NestContentScrollViewDidChangedCurrentColletionView:WeakSelf currentIdenx:type];
        }
    };
    [self addSubview:_pinnedView];
    
    self.currentColletionView = _collectionContainerScrollView.leftColletionView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置上面headerView
//    CGFloat nestScrollViewContentOffsetY = self.contentOffset.y;
//    NSLog(@"----%@",NSStringFromUIEdgeInsets(self.contentInset));
//    if(nestScrollViewContentOffsetY <= 0.0){
//        _headerView.frame = (CGRect){.origin=CGPointMake(0, nestScrollViewContentOffsetY-self.contentInset.top),.size=_headerView.bounds.size};
//        _pinnedView.frame = (CGRect){.origin=CGPointMake(0, nestScrollViewContentOffsetY+_headerView.bounds.size.height-self.contentInset.top),.size=_pinnedView.bounds.size};
//    }
    
}

#pragma mark- CollectionContainerScrollView 滑动代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.contentOffset.y>self.pinnedViewInitFrame.origin.y)[self setContentOffset:CGPointMake(0, self.pinnedViewInitFrame.origin.y)];
    [_collectionContainerScrollView.leftColletionView setContentOffset:CGPointZero];
    [_collectionContainerScrollView.rightColletionView setContentOffset:CGPointZero];
    int index = (scrollView.contentOffset.x+_frameWith*0.5)/_frameWith;
    if(index == _currentIndex)return;
    _currentIndex = index;
    self.currentColletionView = index?_collectionContainerScrollView.rightColletionView:_collectionContainerScrollView.leftColletionView;
    if([_changeColletionViewDelegate respondsToSelector:@selector(NestContentScrollViewDidChangedCurrentColletionView:currentIdenx:)]){
        [_changeColletionViewDelegate NestContentScrollViewDidChangedCurrentColletionView:self currentIdenx:index];
    }
}


@end
