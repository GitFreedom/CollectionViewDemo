//
//  ComplexDemoWaterfallCollectionViewCell.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ComplexDemoWaterfallCollectionViewCell, ComplexDemoCollectionView, ComplexDemoWaterfallModel;

@protocol ComplexDemoWaterfallCollectionViewCellDelegate <NSObject>

@optional 

/// UICollectionView开始拖动回调
/// @param cell ComplexDemoWaterfallCollectionViewCell
/// @param scrollView  滑动视图
- (void)complexDemoWaterfallCollectionViewCell:(ComplexDemoWaterfallCollectionViewCell *)cell
                             willBeginDragging:(UIScrollView *)scrollView;

/// UICollectionView结束滑动回调
/// @param cell ComplexDemoWaterfallCollectionViewCell
/// @param scrollView  滑动视图
- (void)complexDemoWaterfallCollectionViewCell:(ComplexDemoWaterfallCollectionViewCell *)cell
                                  didEndScroll:(UIScrollView *)scrollView;

/// UICollectionView滑动回调
/// @param cell ComplexDemoWaterfallCollectionViewCell
/// @param scrollView  滑动视图
- (void)complexDemoWaterfallCollectionViewCell:(ComplexDemoWaterfallCollectionViewCell *)cell
                                     didScroll:(UIScrollView *)scrollView;

@end

@interface ComplexDemoWaterfallCollectionViewCell : DemoBaseCollectionViewCell
/// collectionView
@property (nonatomic, strong, readonly) ComplexDemoCollectionView *collectionView;
/// 代理
@property (nonatomic, weak) id<ComplexDemoWaterfallCollectionViewCellDelegate> delegate;
/// 模型数据
@property (nonatomic, strong) ComplexDemoWaterfallModel *itemModel;

@end

NS_ASSUME_NONNULL_END
