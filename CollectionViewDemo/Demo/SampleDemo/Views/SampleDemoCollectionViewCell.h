//
//  SampleCollectionViewCell.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SampleDemoCollectionViewCell : DemoBaseCollectionViewCell
/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
