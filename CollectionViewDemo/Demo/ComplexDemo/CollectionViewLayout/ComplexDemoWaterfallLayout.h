//
//  ComplexDemoWaterfallLayout.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ComplexDemoWaterfallLayout;
@protocol ComplexDemoWaterfallLayoutDelegate <NSObject>

@required
/// item高度代理回调
/// @param layout 瀑布流布局
/// @param index 第几个item
/// @param itemWidth item宽度
- (CGFloat)waterfallLayout:(ComplexDemoWaterfallLayout *)layout itemHeightWithIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@end

@interface ComplexDemoWaterfallLayout : UICollectionViewFlowLayout

/// 列数
@property (nonatomic, assign) NSInteger columnCount;
/// 行间距
@property (nonatomic, assign) CGFloat rowMargin;
/// 列间距
@property (nonatomic, assign) CGFloat columnMargin;
/// UICollectionView的insets
@property (nonatomic, assign) UIEdgeInsets contentInsets;
/// 代理
@property (nonatomic, weak) id<ComplexDemoWaterfallLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
