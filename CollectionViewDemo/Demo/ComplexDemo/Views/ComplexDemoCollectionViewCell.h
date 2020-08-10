//
//  ComplexDemoCollectionViewCell.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ComplexDemoCollectionViewCell, ComplexDemoCollectionView, ComplexDemoItemModel;

@protocol ComplexDemoCollectionViewCellDelegate <NSObject>

@optional
/// UICollectionView开始拖动回调
/// @param cell ComplexDemoCollectionViewCell
/// @param scrollView  滑动视图
- (void)complexDemoCollectionViewCell:(ComplexDemoCollectionViewCell *)cell
                    willBeginDragging:(UIScrollView *)scrollView;

/// UICollectionView结束拖动回调
/// @param cell ComplexDemoCollectionViewCell
/// @param scrollView  滑动视图
- (void)complexDemoCollectionViewCell:(ComplexDemoCollectionViewCell *)cell
                         didEndScroll:(UIScrollView *)scrollView;

/// UICollectionView滑动回调
/// @param cell ComplexDemoCollectionViewCell
/// @param scrollView  滑动视图
- (void)complexDemoCollectionViewCell:(DemoBaseCollectionViewCell *)cell
                            didScroll:(UIScrollView *)scrollView;

/// 当前显示页改变回调
/// @param cell ComplexDemoCollectionViewCell
/// @param showPage  当前显示页码
- (void)complexDemoCollectionViewCell:(ComplexDemoCollectionViewCell *)cell
                    showPageDidChange:(NSInteger)showPage;

@end

@interface ComplexDemoCollectionViewCell : DemoBaseCollectionViewCell
/// 当前显示的页码
@property (nonatomic, assign) NSInteger currentShowPage;
/// collectionView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
/// 当前展示的瀑布流collectionView
@property (nonatomic, strong, readonly) ComplexDemoCollectionView *currentWaterfallCollectionView;
/// 代理
@property (nonatomic, weak) id<ComplexDemoCollectionViewCellDelegate> delegate;
/// 模型数据
@property (nonatomic, strong) ComplexDemoItemModel *itemModel;

@end

NS_ASSUME_NONNULL_END
