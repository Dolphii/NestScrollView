//
//  ColletionContainerScrollView.h
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/17.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionContainerScrollView : UIScrollView
@property (strong, nonatomic) UICollectionView *leftColletionView;
@property (strong, nonatomic) UICollectionView *rightColletionView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *leftCollectionViewData;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rightCollectionViewData;
@end
