//
//  PinnedView.m
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/19.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import "PinnedView.h"

@interface PinnedView()
@property (assign, nonatomic)NSInteger selectType;//0左边 1右边
@end


@implementation PinnedView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviewsWithFrameWith:frame.size.width frameHeight:frame.size.height];
    }
    return self;
}

- (void)createSubviewsWithFrameWith:(CGFloat)frameWidth
                        frameHeight:(CGFloat)frameHeight{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"Button1" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setBackgroundColor:[UIColor whiteColor]];
    leftButton.frame = CGRectMake(0, 0, frameWidth/2, frameHeight);
    [leftButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"Button2" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(frameWidth/2, 0, frameWidth/2, frameHeight);
    rightButton.tag = 1;
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor lightGrayColor]];
    [rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    
}

- (void)buttonPressed:(UIButton *)sender{
    self.selectType = sender.tag;
    if(self.didSelectChangeType){
        self.didSelectChangeType(self.selectType);
    }
}

@end
