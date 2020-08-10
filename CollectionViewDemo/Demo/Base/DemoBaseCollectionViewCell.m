//
//  DemoBaseCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoBaseCollectionViewCell.h"

@implementation DemoBaseCollectionViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        [self configDefaultInit];
        // 添加视图
        [self addSubviews];
        // 添加约束
        [self addViewsConstraints];
    }
    return self;
}

- (void)configDefaultInit {
    
}

- (void)addSubviews {
    
}

- (void)addViewsConstraints {
    
}

@end
