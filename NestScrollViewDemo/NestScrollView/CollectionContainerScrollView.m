//
//  ColletionContainerScrollView.m
//  NestScrollViewDemo
//
//  Created by dolphii on 2018/1/17.
//  Copyright © 2018年 dolphii. All rights reserved.
//

#import "CollectionContainerScrollView.h"
#import "WaterFlowLayout.h"
#import "NestCollectionCell.h"

static void *NestLeftCollectionViewKVOContext = &NestLeftCollectionViewKVOContext;
static void *NestRightCollectionViewKVOContext = &NestRightCollectionViewKVOContext;
static void *NestCollectionContainerScrollViewKVOContext = &NestCollectionContainerScrollViewKVOContext;

@interface CollectionContainerScrollView()<WaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (assign, nonatomic) CGFloat frameWidth;
@property (assign, nonatomic) CGFloat frameHeight;
@end

@implementation CollectionContainerScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.contentSize = CGSizeMake(frame.size.width*2, 0);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor blueColor];
        
        self.clipsToBounds = YES;
        
        self.frameWidth = frame.size.width;
        self.frameHeight = frame.size.height;
        
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew context:NestCollectionContainerScrollViewKVOContext];//监听frame变化
        
//        [self createSubViewsWithFrameWidth:frame.size.width frameHeight:frame.size.height];
        
    }
    return self;
}

- (void)createSubViewsWithFrameWidth:(CGFloat)width
                         frameHeight:(CGFloat)height{
    
    WaterFlowLayout *leftWaterLayout = [[WaterFlowLayout alloc]init];
    leftWaterLayout.delegate = self;
    leftWaterLayout.Identifier = 0;
    self.leftColletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:leftWaterLayout];
    _leftColletionView.dataSource = self;
    _leftColletionView.delegate = self;
    _leftColletionView.backgroundColor = [UIColor redColor];
    [_leftColletionView registerClass:[NestCollectionCell class] forCellWithReuseIdentifier:@"NestCollectionCellIden"];
    _leftColletionView.scrollEnabled = NO;
    [self addSubview:_leftColletionView];
    
    
    WaterFlowLayout *rightWaterLayout = [[WaterFlowLayout alloc]init];
    rightWaterLayout.delegate = self;
    rightWaterLayout.Identifier = 1;
    self.rightColletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(width, 0, width, height) collectionViewLayout:rightWaterLayout];
    _rightColletionView.dataSource = self;
    _rightColletionView.delegate  =self;
    _rightColletionView.scrollEnabled = NO;
    _rightColletionView.tag = 1;
    _rightColletionView.backgroundColor = [UIColor grayColor];
    [_rightColletionView registerClass:[NestCollectionCell class] forCellWithReuseIdentifier:@"NestCollectionCellIden"];
    [self addSubview:_rightColletionView];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"frame" context:NestCollectionContainerScrollViewKVOContext];
}

- (UICollectionView *)leftColletionView{
    if(!_leftColletionView){
        WaterFlowLayout *leftWaterLayout = [[WaterFlowLayout alloc]init];
        leftWaterLayout.delegate = self;
        leftWaterLayout.Identifier = 0;
        self.leftColletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _frameWidth, _frameHeight) collectionViewLayout:leftWaterLayout];
        _leftColletionView.dataSource = self;
        _leftColletionView.delegate = self;
        _leftColletionView.backgroundColor = [UIColor redColor];
        [_leftColletionView registerClass:[NestCollectionCell class] forCellWithReuseIdentifier:@"NestCollectionCellIden"];
        _leftColletionView.scrollEnabled = NO;
        [self addSubview:_leftColletionView];
    }
    return _leftColletionView;
}

- (UICollectionView *)rightColletionView{
    if(!_rightColletionView){
        WaterFlowLayout *rightWaterLayout = [[WaterFlowLayout alloc]init];
        rightWaterLayout.delegate = self;
        rightWaterLayout.Identifier = 1;
        _rightColletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(_frameWidth, 0, _frameWidth, _frameHeight) collectionViewLayout:rightWaterLayout];
        _rightColletionView.dataSource = self;
        _rightColletionView.delegate  =self;
        _rightColletionView.scrollEnabled = NO;
        _rightColletionView.tag = 1;
        _rightColletionView.backgroundColor = [UIColor grayColor];
        [_rightColletionView registerClass:[NestCollectionCell class] forCellWithReuseIdentifier:@"NestCollectionCellIden"];
        [self addSubview:_rightColletionView];
    }
    return _rightColletionView;
}

#pragma mark- ColletionView ContentSize KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context == NestCollectionContainerScrollViewKVOContext){//监听self frame变化 子colletionView frame和self一样
        if([keyPath isEqualToString:NSStringFromSelector(@selector(frame))]){
            UIScrollView *scrollView = object;
            CGFloat newHeight = scrollView.frame.size.height;
            self.leftColletionView.frame = (CGRect){.origin=CGPointZero,.size=CGSizeMake(scrollView.frame.size.width, newHeight)};
            self.rightColletionView.frame = (CGRect){.origin=self.rightColletionView.frame.origin,.size=CGSizeMake(scrollView.frame.size.width, newHeight)};
        }
    }
}
    
#pragma mark- About Colletion

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView.tag)return _rightCollectionViewData.count;
    return _leftCollectionViewData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NestCollectionCellIden" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"N%ld", indexPath.row + 1];
    return cell;
}
    
- (CGFloat)WaterFlowLayout:(WaterFlowLayout *)WaterFlowLayout
   heightForRowAtIndexPath:(NSInteger)index
                 itemWidth:(CGFloat)itemWidth{
    if(WaterFlowLayout.Identifier){//rightCollectionView
        return _rightCollectionViewData[index].floatValue;
    }
    return _leftCollectionViewData[index].floatValue;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s----%d", __PRETTY_FUNCTION__,(int)indexPath.row);
}


@end
