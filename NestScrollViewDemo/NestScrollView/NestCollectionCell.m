//
//  NestCollectionCell.m
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/21.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import "NestCollectionCell.h"

@implementation NestCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _textLabel.font = [UIFont systemFontOfSize:15.0];
        _textLabel.textColor = [UIColor orangeColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _textLabel.frame  = (CGRect){.origin=CGPointZero,.size=self.contentView.bounds.size};
}

@end
