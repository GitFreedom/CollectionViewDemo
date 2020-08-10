//
//  DemoRefreshGifHeader.m
//  CollectionViewDemo
//
//  Created by kaishujianggushi on 2020/8/10.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoRefreshGifHeader.h"

@implementation DemoRefreshGifHeader

#pragma mark - Override

- (void)prepare {
    [super prepare];
    self.pullingPercent = 0.5;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    [self setBackgroundColor:[UIColor clearColor]];
    // 设置普通状态的动画图片
    NSMutableArray *pullingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 16; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_header%zd", i]];
        [pullingImages addObject:image];
    }
    [self setImages:pullingImages duration:2.0 forState:MJRefreshStateIdle];

    // 设置刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        for (NSUInteger i = 16; i <= 42; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_header%zd", i]];
            [refreshingImages addObject:image];
        }
    }
    [self setImages:refreshingImages duration:2.0 forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    self.gifView.frame = CGRectMake((CGRectGetWidth(self.frame) - 45) / 2.0, (CGRectGetHeight(self.frame) - 45 ) / 2.0, 45, 45);
    self.gifView.contentMode = UIViewContentModeScaleToFill;
}

@end
