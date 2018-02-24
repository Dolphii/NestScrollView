//
//  NestContentScrollView.h
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/17.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinnedView.h"
#import "CollectionContainerScrollView.h"

@class NestContentScrollView;

@protocol NestContentScrollViewChangeCurrentColletionViewDelegate<NSObject>
@optional
- (void)NestContentScrollViewDidChangedCurrentColletionView:(NestContentScrollView *)nestContentScrollView
                                               currentIdenx:(NSInteger)currentIndex;
@end

@interface NestContentScrollHeaderView:UIView
@property (nonatomic, strong) UILabel *titleLabel;
@end



@interface NestContentScrollView : UIScrollView

@property (nonatomic, strong) NestContentScrollHeaderView *headerView;
@property (nonatomic, strong) PinnedView *pinnedView;
@property (nonatomic, assign) CGRect pinnedViewInitFrame;
@property (nonatomic, strong) CollectionContainerScrollView *collectionContainerScrollView;
@property (assign, nonatomic) NSInteger currentIndex;//0左边1右边
@property (nonatomic, strong) UICollectionView *currentColletionView;

@property (nonatomic, weak) id<NestContentScrollViewChangeCurrentColletionViewDelegate> changeColletionViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame
                 headerHeight:(CGFloat)headerHeight
                 pinnerHeight:(CGFloat)pinnerHeight;

@end
