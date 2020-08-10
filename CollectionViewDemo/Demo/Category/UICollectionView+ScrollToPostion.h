//
//  UICollectionView+ScrollToPostion.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (ScrollToPostion)

/// 滑动到指定位置
/// @param indexPath 坐标（第几行第几列）
/// @param scrollPosition 滑动的位置
/// @param animated  是否有动画
- (void)scrollToTargetItemAtIndexPath:(NSIndexPath *)indexPath
                     atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                             animated:(BOOL)animated;

/// 滑动到指定section
/// @param section 行数
/// @param scrollPosition 滑动位置（暂不支持组合类型比如 UICollectionViewScrollPositionTop | UICollectionViewScrollPositionCenteredVertically）
/// @param animated 是否有动画
- (void)scrollToTargetSection:(NSInteger)section
             atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                     animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
