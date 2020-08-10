//
//  ComplexDemoViewController.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoViewController.h"

#import "ComplexDemoCollectionView.h"
#import "SampleDemoCollectionViewCell.h"
#import "ComplexDemoCollectionViewCell.h"
#import "SampleDemoHeaderCollectionReusableView.h"
#import "SampleDemoFooterCollectionReusableView.h"
#import "ComplexDemoHeaderCollectionReusableView.h"
#import "ComplexDemoCustomFloatLayout.h"

#import "ComplexDemoSectionModel.h"

#import "UICollectionView+ScrollToPostion.h"

#import <Masonry/Masonry.h>

@interface ComplexDemoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ComplexDemoCollectionViewCellDelegate, ComplexDemoHeaderCollectionReusableViewDelegate>
/// collectionView数据源
@property (nonatomic, strong) NSMutableArray<ComplexDemoSectionModel *> *dataArray;
/// 自定义悬停layout
@property (nonatomic, strong) ComplexDemoCustomFloatLayout *customFloatLayout;
/// collectionView
@property (nonatomic, strong) ComplexDemoCollectionView *collectionView;
/// 容器collectionView
@property (nonatomic, weak) UICollectionView *containerCollectionView;
/// 当前显示的瀑布流collectionView
@property (nonatomic, weak) ComplexDemoCollectionView *currentShowWaterfallCollectionView;
@end

@implementation ComplexDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化设置
    [self _configDefaultInit];
    // 添加视图
    [self _addSubviews];
    // 添加约束
    [self _addViewsConstraints];
}

#pragma mark - Private

- (void)_configDefaultInit {
    // 设置控制器标题
    self.title = @"UICollectionView嵌套应用";
    // 设置控制器视图颜色
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    // 初始化collectionView数据源
    self.dataArray = @[].mutableCopy;
    for (NSInteger row = 1; row <= 5; row++) {
        ComplexDemoSectionModel *sectionModel = [[ComplexDemoSectionModel alloc] init];
        sectionModel.sectionHeaderTitle = [NSString stringWithFormat:@"第%li行头部", (long)row];
        NSMutableArray<ComplexDemoItemModel *> *tempArray = @[].mutableCopy;
        if (row == 5) {
            ComplexDemoItemModel *itemModel = [[ComplexDemoItemModel alloc] init];
            itemModel.itemTitle = [NSString stringWithFormat:@"%li", (long)row];
            NSMutableArray *waterfallArray = @[].mutableCopy;
            for (NSInteger col = 0; col < 5; col++) {
                ComplexDemoWaterfallModel *waterfallModel = [[ComplexDemoWaterfallModel alloc] init];
                waterfallModel.title = [NSString stringWithFormat:@"%li", (long)col];
                NSMutableArray *waterfallItemArray = @[].mutableCopy;
                for (NSInteger i = 0; i < 50; i++) {
                    ComplexDemoWaterfallItemModel *waterfallItemModel = [[ComplexDemoWaterfallItemModel alloc] init];
                    waterfallItemModel.title = [NSString stringWithFormat:@"%li", (long)i];
                    waterfallItemModel.itemHeight = 80 + arc4random() % 120;
                    [waterfallItemArray addObject:waterfallItemModel];
                }
                waterfallModel.itemsArray = waterfallItemArray;
                [waterfallArray addObject:waterfallModel];
            }
            itemModel.dataArray = waterfallArray.copy;
            [tempArray addObject:itemModel];
        } else {
            for (NSInteger col = 1; col <= row; col++) {
                ComplexDemoItemModel *itemModel = [[ComplexDemoItemModel alloc] init];
                itemModel.itemTitle = [NSString stringWithFormat:@"第%li行第%li列", (long)row, (long)col];
                [tempArray addObject:itemModel];
            }
        }
        sectionModel.itemsArray = tempArray.copy;
        sectionModel.sectionFooterTitle = [NSString stringWithFormat:@"第%li行尾部", (long)row];
        [self.dataArray addObject:sectionModel];
    }
    // 指定section悬停
    self.customFloatLayout.targetSectionHeaderFloat = 4;
}

- (void)_addSubviews {
    [self.view addSubview:self.collectionView];
}

- (void)_addViewsConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (nullable ComplexDemoCollectionViewCell *)_getComplexDemoCollectionViewCellWithIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ComplexDemoCollectionViewCell class]]) {
        return (ComplexDemoCollectionViewCell *)cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDataSource

// 控制有几行
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

// 控制对应行有几列
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count > section) {
        return self.dataArray[section].itemsArray.count;
    }
    return 0;
}

// 具体item实现
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count <= indexPath.section) {
        return [[UICollectionViewCell alloc] init];
    }
    
    ComplexDemoSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel.itemsArray.count <= indexPath.row) {
        return [[UICollectionViewCell alloc] init];
    }
    
    ComplexDemoItemModel *itemModel = sectionModel.itemsArray[indexPath.row];
    if (itemModel.dataArray && itemModel.dataArray.count > 0) {
        ComplexDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ComplexDemoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
        cell.delegate = self;
        cell.itemModel = itemModel;
        return cell;
    } else {
        SampleDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
        cell.titleLabel.text = itemModel.itemTitle;
        return cell;
    }
}

// 具体section头和尾实现
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count <= indexPath.section) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DemoBaseCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
    }
    
    ComplexDemoSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel.itemsArray.count <= indexPath.row) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DemoBaseCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
    }
    
    ComplexDemoItemModel *itemModel = sectionModel.itemsArray[indexPath.row];
    if (itemModel.dataArray && itemModel.dataArray.count > 0) {
        ComplexDemoHeaderCollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[ComplexDemoHeaderCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
        sectionHeader.delegate = self;
        sectionHeader.sectionModel = sectionModel;
        return sectionHeader;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 头
        SampleDemoHeaderCollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[SampleDemoHeaderCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
        if (self.dataArray.count > indexPath.section) {
            sectionHeader.titleLabel.text = sectionModel.sectionHeaderTitle;
        }
        return sectionHeader;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) { // 尾
        SampleDemoFooterCollectionReusableView *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[SampleDemoFooterCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
        if (self.dataArray.count > indexPath.section) {
            sectionFooter.titleLabel.text = sectionModel.sectionFooterTitle;
        }
        return sectionFooter;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DemoBaseCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

// 每个元素点击事件回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%li行", (long)indexPath.row);
}

// 即将显示的item
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"即将显示第%li行第%li列", (long)indexPath.section, (long)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"第%li行第%li列已经消失", (long)indexPath.section, (long)indexPath.row);
}


#pragma mark  UICollectionViewDelegateFlowLayout

// 每个元素对应的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count <= indexPath.section) {
        return CGSizeZero;
    }
    
    ComplexDemoSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel.itemsArray.count <= indexPath.row) {
        return CGSizeZero;
    }
    
    ComplexDemoItemModel *itemModel = sectionModel.itemsArray[indexPath.row];
    if (itemModel.dataArray && itemModel.dataArray.count > 0) {
        UICollectionViewLayoutAttributes *layoutAttribute = [collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttribute) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame) - CGRectGetHeight(layoutAttribute.frame));
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame) - 54.0);
        }
    }
    
    // 获取collectionView的宽度
    CGFloat colllectionWidth = CGRectGetWidth(collectionView.frame);
    // 获取当前行有几列
    NSInteger colCount = sectionModel.itemsArray.count;
    // 计算每一列的宽度（(colllectionWidth - (colCount - 1) * 每一列的最小间隔) / colCount）
    CGFloat itemWidth = (colllectionWidth - (colCount - 1) * 10.0) / colCount;
    // 返回每一个item的大小
    return CGSizeMake(itemWidth, 80.0);
}

// 每个sectionHeader的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count <= section) {
        return CGSizeZero;
    }
    
    ComplexDemoSectionModel *sectionModel = self.dataArray[section];
    if (sectionModel.itemsArray.count > 0) {
        ComplexDemoItemModel *itemModel = sectionModel.itemsArray.firstObject;
        if (itemModel.dataArray && itemModel.dataArray.count > 0) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), 54.0);
        }
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 30.0);
}

// 每个sectionFooter的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.dataArray.count <= section) {
        return CGSizeZero;
    }
    
    ComplexDemoSectionModel *sectionModel = self.dataArray[section];
    if (sectionModel.itemsArray.count > 0) {
        ComplexDemoItemModel *itemModel = sectionModel.itemsArray.firstObject;
        if (itemModel.dataArray && itemModel.dataArray.count > 0) {
            return CGSizeZero;
        }
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 30.0);
}

// 每一行内列与列之间的间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark  UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentShowWaterfallCollectionView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentShowWaterfallCollectionView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.currentShowWaterfallCollectionView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentShowWaterfallCollectionView.scrollEnabled = YES;
}

// 滑动回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"主滑动回调 scrollView.contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
    if (self.collectionView.numberOfSections > self.customFloatLayout.targetSectionHeaderFloat) {
        UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.customFloatLayout.targetSectionHeaderFloat]];
        CGFloat targetContentOffsetY = CGRectGetMinY(layoutAttributes.frame);
        if (scrollView.contentOffset.y < targetContentOffsetY) {
            self.currentShowWaterfallCollectionView.contentOffset = CGPointMake(self.currentShowWaterfallCollectionView.contentOffset.x, 0);
        }
        
        if (scrollView.contentOffset.y > targetContentOffsetY) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, targetContentOffsetY);
        }
    }
}

#pragma mark - ComplexDemoCollectionViewCellDelegate

- (void)complexDemoCollectionViewCell:(ComplexDemoCollectionViewCell *)cell
                    willBeginDragging:(UIScrollView *)scrollView {
    self.collectionView.scrollEnabled = NO;
}

- (void)complexDemoCollectionViewCell:(ComplexDemoCollectionViewCell *)cell
                         didEndScroll:(UIScrollView *)scrollView {
    self.collectionView.scrollEnabled = YES;
}

- (void)complexDemoCollectionViewCell:(DemoBaseCollectionViewCell *)cell
                            didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)complexDemoCollectionViewCell:(ComplexDemoCollectionViewCell *)cell
                    showPageDidChange:(NSInteger)showPage {
    UICollectionReusableView *sectionHeader = [self.collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.customFloatLayout.targetSectionHeaderFloat]];
    if ([sectionHeader isKindOfClass:[ComplexDemoHeaderCollectionReusableView class]]) {
        ComplexDemoHeaderCollectionReusableView *header = (ComplexDemoHeaderCollectionReusableView *)sectionHeader;
        header.selectIndexPath = [NSIndexPath indexPathForItem:showPage inSection:0];
    }
}

#pragma mark - ComplexDemoHeaderCollectionReusableViewDelegate

- (void)complexDemoHeaderCollectionReusableView:(ComplexDemoHeaderCollectionReusableView *)sectionHeader
                       didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ComplexDemoCollectionViewCell *cell = [self _getComplexDemoCollectionViewCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.customFloatLayout.targetSectionHeaderFloat]];
    if (cell) {
        cell.currentShowPage = indexPath.row;
    }
}

#pragma mark - Getter

- (ComplexDemoCustomFloatLayout *)customFloatLayout {
    if (_customFloatLayout == nil) {
        _customFloatLayout = [[ComplexDemoCustomFloatLayout alloc] init];
        // 设置header是否悬停
        _customFloatLayout.sectionHeadersPinToVisibleBounds = NO;
        // 设置footer是否悬停
        _customFloatLayout.sectionFootersPinToVisibleBounds = NO;
    }
    return _customFloatLayout;
}

- (ComplexDemoCollectionView *)collectionView {
    if (_collectionView == nil) {
        // 初始化CollectionView
        _collectionView = [[ComplexDemoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.customFloatLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 设置是否显示滚动条
        _collectionView.showsVerticalScrollIndicator = NO; // 竖直方向
        _collectionView.showsHorizontalScrollIndicator = NO; // 水平方向
        // 设置背景色
        _collectionView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
        // 注册cell
        [_collectionView registerClass:[SampleDemoCollectionViewCell class] forCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier]];
        [_collectionView registerClass:[ComplexDemoCollectionViewCell class] forCellWithReuseIdentifier:[ComplexDemoCollectionViewCell reuseIdentifier]];
        // 注册sectionHeader
        [_collectionView registerClass:[SampleDemoHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SampleDemoHeaderCollectionReusableView reuseIdentifier]];
        [_collectionView registerClass:[DemoBaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[DemoBaseCollectionReusableView reuseIdentifier]];
        [_collectionView registerClass:[ComplexDemoHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ComplexDemoHeaderCollectionReusableView reuseIdentifier]];
        // 注册sectionFooter
        [_collectionView registerClass:[SampleDemoFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[SampleDemoFooterCollectionReusableView reuseIdentifier]];
        [_collectionView registerClass:[DemoBaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[DemoBaseCollectionReusableView reuseIdentifier]];
        // 设置contentInsetAdjustmentBehavior
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}


@end
