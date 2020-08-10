//
//  ComplexDemoCustomFloatLayout.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoCustomFloatLayout.h"

@implementation ComplexDemoCustomFloatLayout

#pragma mark - Override

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.collectionView.numberOfSections <= self.targetSectionHeaderFloat) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    
    // 获取目标section的item的数量
    NSInteger numberOfItemsInTargetSection = [self.collectionView numberOfItemsInSection:self.targetSectionHeaderFloat];
    if (numberOfItemsInTargetSection <= 0) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    
    // 获取第一个item结构信息
    UICollectionViewLayoutAttributes *firstItemAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.targetSectionHeaderFloat]];
    
    // 获取最后一个item结构信息
    UICollectionViewLayoutAttributes *lastItemAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:MAX(0, numberOfItemsInTargetSection - 1) inSection:self.targetSectionHeaderFloat]];
    
    // 获取目标sectionHeader的结构信息
    UICollectionViewLayoutAttributes *targetSectionHeaderAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.targetSectionHeaderFloat]];
    
    // 获取父类所返回的数组并转化为可变数组
    NSMutableArray<UICollectionViewLayoutAttributes *> *tempArray = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    [tempArray removeObject:targetSectionHeaderAttributes];
    
    // 获取目标sectionHeader的frame
    CGRect targetSectionHeaderFrame = targetSectionHeaderAttributes.frame;
    
    // 当前的滑动距离
    CGFloat offset = self.collectionView.contentOffset.y;
    
    // 第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
    CGFloat targetSectionHeaderY = CGRectGetMinY(firstItemAttributes.frame) - CGRectGetHeight(targetSectionHeaderFrame) - self.sectionInset.top;

    // 哪个大取哪个，保证header悬停
    // 针对当前header基本上都是offset更加大，针对下一个header则会是headerY大，各自处理
    CGFloat maxY = MAX(offset, targetSectionHeaderY);

    // 最后一个cell的y值 + 最后一个cell的高度 + 可能存在的sectionInset的bottom - 当前header的高度
    // 当当前section的footer或者下一个section的header接触到当前header的底部，计算出的headerMissingY即为有效值
    CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - CGRectGetHeight(targetSectionHeaderFrame);

    // 给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
    targetSectionHeaderFrame.origin.y = MIN(maxY, headerMissingY);
    // 给header的结构信息的frame重新赋值
    targetSectionHeaderAttributes.frame = targetSectionHeaderFrame;

    // 如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
    // 通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
    targetSectionHeaderAttributes.zIndex = 1024;
    
    // 添加目标sectionHeader的结构信息
    [tempArray addObject:targetSectionHeaderAttributes];
    // 返回添加之后的数组
    return tempArray.copy;
}

// 表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

#pragma mark - Setter

- (void)setTargetSectionHeaderFloat:(NSInteger)targetSectionHeaderFloat {
    _targetSectionHeaderFloat = targetSectionHeaderFloat;
    self.sectionHeadersPinToVisibleBounds = NO;
}

@end
