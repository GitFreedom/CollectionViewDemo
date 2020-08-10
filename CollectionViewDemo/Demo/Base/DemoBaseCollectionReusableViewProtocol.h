//
//  DemoBaseCollectionReusableViewProtocol.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DemoBaseCollectionReusableViewProtocol <NSObject>

/// 重用标示
+ (NSString *)reuseIdentifier;

/// 初始化
- (void)configDefaultInit;

/// 添加视图
- (void)addSubviews;

/// 添加约束
- (void)addViewsConstraints;

@end

NS_ASSUME_NONNULL_END
