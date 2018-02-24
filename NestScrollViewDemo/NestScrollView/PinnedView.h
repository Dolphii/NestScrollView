//
//  PinnedView.h
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/19.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinnedView : UIView

@property (copy, nonatomic) void(^didSelectChangeType)(NSInteger type);//0左边 1右边

@end
