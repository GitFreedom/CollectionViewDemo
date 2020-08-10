//
//  UICollectionView+ScrollToPostion.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "UICollectionView+ScrollToPostion.h"

#import <pthread.h>

@implementation UICollectionView (ScrollToPostion)

#pragma mark - Public

- (void)scrollToTargetItemAtIndexPath:(NSIndexPath *)indexPath
                     atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                             animated:(BOOL)animated {
    if (self.numberOfSections <= indexPath.section) {
        return;
    }
    
    if ([self numberOfItemsInSection:indexPath.section] <= indexPath.row) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self _executeInMainQueue:^{
        // collectionView重新布局，防止collectionView刷新数据之后定位不准的情况
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
        // 滑动到指定位置
        [weakSelf scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }];
}

- (void)scrollToTargetSection:(NSInteger)section
             atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                     animated:(BOOL)animated {
    if (self.numberOfSections <= section) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self _executeInMainQueue:^{
        // collectionView重新布局，防止collectionView刷新数据之后定位不准的情况
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
        // 计算应该滑动的偏移量
        CGFloat contentOffsetX = self.contentOffset.x;
        CGFloat contentOffsetY = self.contentOffset.y;
        switch (scrollPosition) {
            case UICollectionViewScrollPositionTop:{
                UICollectionViewLayoutAttributes *layoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                contentOffsetY = CGRectGetMinY(layoutAttribute.frame);
            } break;
            case UICollectionViewScrollPositionCenteredVertically:{
                UICollectionViewLayoutAttributes *headerLayoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                UICollectionViewLayoutAttributes *footerLayoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                CGFloat sectionTopY = CGRectGetMinY(headerLayoutAttribute.frame);
                CGFloat sectionBottomY = CGRectGetMaxY(footerLayoutAttribute.frame);
                contentOffsetY = sectionTopY + (sectionBottomY - sectionTopY) / 2.0;
            } break;
            case UICollectionViewScrollPositionBottom:{
                UICollectionViewLayoutAttributes *layoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                contentOffsetY = CGRectGetMaxY(layoutAttribute.frame);
            } break;
            case UICollectionViewScrollPositionLeft:{
                UICollectionViewLayoutAttributes *layoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                contentOffsetX = CGRectGetMinX(layoutAttribute.frame);
            } break;
            case UICollectionViewScrollPositionCenteredHorizontally:{
                UICollectionViewLayoutAttributes *headerLayoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                UICollectionViewLayoutAttributes *footerLayoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                CGFloat sectionLeftX = CGRectGetMinX(headerLayoutAttribute.frame);
                CGFloat sectionRightX = CGRectGetMaxX(footerLayoutAttribute.frame);
                contentOffsetX = sectionLeftX + (sectionRightX - sectionLeftX) / 2.0;
            } break;
            case UICollectionViewScrollPositionRight:{
                UICollectionViewLayoutAttributes *layoutAttribute = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                contentOffsetX = CGRectGetMaxX(layoutAttribute.frame);
            } break;
            default:
                break;
        }
        // 设置偏移量
        [self setContentOffset:CGPointMake(contentOffsetX, contentOffsetY) animated:animated];
    }];
}

#pragma mark - Private

- (void)_executeInMainQueue:(void(^)(void))completion {
    if (pthread_main_np()) {
        !completion ?: completion();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    }
}


@end
