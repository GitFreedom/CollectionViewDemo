//
//  ComplexDemoWaterfallLayout.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoWaterfallLayout.h"

@interface ComplexDemoWaterfallLayout ()
/// 布局属性数组
@property (nonatomic, strong) NSMutableArray *layoutAttributesArray;
/// 每列高度数组
@property (nonatomic, strong) NSMutableArray *columnHeightArray;
/// 最大列高
@property (nonatomic, assign) CGFloat maxColumnHeight;
@end

@implementation ComplexDemoWaterfallLayout

#pragma mark - overwrite father‘s methods

- (void)prepareLayout {
    
    [super prepareLayout];
    // 重置最大列高
    self.maxColumnHeight = 0;
    // 重置每列高度数组
    [self.columnHeightArray removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeightArray addObject:[NSNumber numberWithDouble:self.contentInsets.top]];
    }
    // 重置布局属性数组
    [self.layoutAttributesArray removeAllObjects];
    NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < itemsCount; i++) {
        [self.layoutAttributesArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttributesArray.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttibute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - self.contentInsets.left - self.contentInsets.right - (self.columnCount - 1) * self.columnMargin) / (self.columnCount * 1.0);
    CGFloat itemHeight = [self.delegate waterfallLayout:self itemHeightWithIndex:indexPath.item itemWidth:itemWidth];
    NSInteger minCols = 0;
    CGFloat minColHeight = [self.columnHeightArray[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat colHeight = [self.columnHeightArray[i] doubleValue];
        if (colHeight < minColHeight) {
            minColHeight = colHeight;
            minCols = i;
        }
    }
    CGFloat itemX = self.contentInsets.left + (itemWidth + self.columnMargin) * minCols;
    CGFloat itemY = minColHeight;
    //当不是最上面那一行时加rowMargin
    if (indexPath.section != 0 || indexPath.row / self.columnCount != 0) {
        itemY += self.rowMargin;
    }
    layoutAttibute.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    CGFloat updateColHeight = CGRectGetMaxY(layoutAttibute.frame);
    self.columnHeightArray[minCols] = [NSNumber numberWithDouble:updateColHeight];
    if (updateColHeight > self.maxColumnHeight) {
        self.maxColumnHeight = updateColHeight;
    }
    return layoutAttibute;
}

- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.maxColumnHeight + self.contentInsets.bottom);
}

#pragma mark - getter

- (NSMutableArray *)layoutAttributesArray {
    
    if (!_layoutAttributesArray) {
        _layoutAttributesArray = [[NSMutableArray alloc]init];
    }
    return _layoutAttributesArray;
}

- (NSMutableArray *)columnHeightArray {
    
    if (!_columnHeightArray) {
        _columnHeightArray = [[NSMutableArray alloc]init];
    }
    return _columnHeightArray;
}

@end
