//
//  ComplexDemoCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoCollectionViewCell.h"
#import "ComplexDemoWaterfallCollectionViewCell.h"

#import "ComplexDemoItemModel.h"

@interface ComplexDemoCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, ComplexDemoWaterfallCollectionViewCellDelegate>
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ComplexDemoCollectionViewCell

#pragma mark - Override

- (void)addSubviews {
    [super addSubviews];
    
    [self.contentView addSubview:self.collectionView];
}

- (void)addViewsConstraints {
    [super addViewsConstraints];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UICollectionViewDatasource

// 返回item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemModel.dataArray.count;
}

// 返回瀑布流具体item的实现
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComplexDemoWaterfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ComplexDemoWaterfallCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    if (_currentWaterfallCollectionView == nil) {
        _currentWaterfallCollectionView = cell.collectionView;
    }
    cell.delegate = self;
    if (self.itemModel.dataArray.count > indexPath.row) {
        cell.itemModel = self.itemModel.dataArray[indexPath.row];
    }
    return cell;
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

#pragma mark  UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 由于是由setContentOffset:animated:触发，所以要强制调用一下代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoCollectionViewCell:showPageDidChange:)]) {
        [self.delegate complexDemoCollectionViewCell:self showPageDidChange:_currentShowPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    NSLog(@"currentPage = %li", (long)currentPage);
    if (_currentShowPage != currentPage) {
        _currentShowPage = currentPage;
        // 更新当前展示的瀑布流collectionView
        [self _updateCurrentWaterfallCollectionView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoCollectionViewCell:showPageDidChange:)]) {
            [self.delegate complexDemoCollectionViewCell:self showPageDidChange:_currentShowPage];
        }
    }
}

#pragma mark  UICollectionViewDelegateFlowLayout

// 每个元素对应的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

// 每个sectionHeader的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

// 每个sectionFooter的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

// 每一行内列与列之间的间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 每一列内行与行之间的间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - ComplexDemoWaterfallCollectionViewCellDelegate

- (void)complexDemoWaterfallCollectionViewCell:(ComplexDemoWaterfallCollectionViewCell *)cell
                             willBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoCollectionViewCell:willBeginDragging:)]) {
        [self.delegate complexDemoCollectionViewCell:self willBeginDragging:scrollView];
    }
}

- (void)complexDemoWaterfallCollectionViewCell:(ComplexDemoWaterfallCollectionViewCell *)cell
                                  didEndScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoCollectionViewCell:didEndScroll:)]) {
        [self.delegate complexDemoCollectionViewCell:self didEndScroll:scrollView];
    }
}

- (void)complexDemoWaterfallCollectionViewCell:(ComplexDemoWaterfallCollectionViewCell *)cell
                                     didScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoCollectionViewCell:didScroll:)]) {
        [self.delegate complexDemoCollectionViewCell:cell didScroll:scrollView];
    }
}

#pragma mark - Private

- (void)_updateCurrentWaterfallCollectionView {
    if ([self.collectionView numberOfItemsInSection:0] > self.currentShowPage) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentShowPage inSection:0]];
        if ([cell isKindOfClass:[ComplexDemoWaterfallCollectionViewCell class]]) {
            ComplexDemoWaterfallCollectionViewCell *waterfallCell = (ComplexDemoWaterfallCollectionViewCell *)cell;
            _currentWaterfallCollectionView = waterfallCell.collectionView;
        }
    }
}

#pragma mark - Setter

- (void)setCurrentShowPage:(NSInteger)currentShowPage {
    if (_currentShowPage != currentShowPage) {
        _currentShowPage = currentShowPage;
        [self.collectionView setContentOffset:CGPointMake(currentShowPage * CGRectGetWidth(self.collectionView.frame), self.collectionView.contentOffset.y) animated:YES];
        // 更新当前展示的瀑布流collectionView
        [self _updateCurrentWaterfallCollectionView];
    }
}

- (void)setItemModel:(ComplexDemoItemModel *)itemModel {
    _itemModel = itemModel;
    // 刷表
    [self.collectionView reloadData];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        // 初始化布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 初始化CollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 设置分页
        _collectionView.pagingEnabled = YES;
        // 设置是否显示滚动条
        _collectionView.showsVerticalScrollIndicator = NO; // 竖直方向
        _collectionView.showsHorizontalScrollIndicator = NO; // 水平方向
        // 设置背景色
        _collectionView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
        // 注册cell
        [_collectionView registerClass:[ComplexDemoWaterfallCollectionViewCell class] forCellWithReuseIdentifier:[ComplexDemoWaterfallCollectionViewCell reuseIdentifier]];
        // 设置contentInsetAdjustmentBehavior
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

@end
