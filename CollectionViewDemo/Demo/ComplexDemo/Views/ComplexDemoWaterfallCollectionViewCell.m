//
//  ComplexDemoWaterfallCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoWaterfallCollectionViewCell.h"
#import "SampleDemoCollectionViewCell.h"
#import "DemoRefreshGifFooter.h"
#import "ComplexDemoCollectionView.h"

#import "ComplexDemoWaterfallLayout.h"

#import "ComplexDemoWaterfallModel.h"

@interface ComplexDemoWaterfallCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, ComplexDemoWaterfallLayoutDelegate>
/// collectionView
@property (nonatomic, strong) ComplexDemoCollectionView *collectionView;
@end

@implementation ComplexDemoWaterfallCollectionViewCell

#pragma mark - Override

- (void)configDefaultInit {
    [super configDefaultInit];
    
    // 初始化加载更多
    [self _configLoadMore];
}

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

#pragma mark - Private

- (void)_configLoadMore {
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [DemoRefreshGifFooter footerWithRefreshingBlock:^{
        // 延迟0.25秒模拟网路请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 添加新数据
            NSInteger itemsCount = weakSelf.itemModel.itemsArray.count;
            for (NSInteger i = itemsCount; i < itemsCount + 50; i++) {
                ComplexDemoWaterfallItemModel *waterfallItemModel = [[ComplexDemoWaterfallItemModel alloc] init];
                waterfallItemModel.title = [NSString stringWithFormat:@"%li", (long)i];
                waterfallItemModel.itemHeight = 80 + arc4random() % 120;
                [weakSelf.itemModel.itemsArray addObject:waterfallItemModel];
            }
            // 刷新collectionView数据
            [weakSelf.collectionView reloadData];
            // 停止下拉刷新动画
            if (weakSelf.itemModel.itemsArray.count >= 150) { // 允许加载三页
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        });
    }];
}

#pragma mark - UICollectionViewDatasource

// 返回瀑布流item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemModel.itemsArray.count;
}

// 返回瀑布流具体item的实现
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SampleDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    if (self.itemModel.itemsArray.count > indexPath.row) {
        cell.titleLabel.text = self.itemModel.itemsArray[indexPath.row].title;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"瀑布流点击了第%li个item", (long)indexPath.row);
}

#pragma mark   UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoWaterfallCollectionViewCell:willBeginDragging:)]) {
        [self.delegate complexDemoWaterfallCollectionViewCell:self willBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoWaterfallCollectionViewCell:didEndScroll:)]) {
        [self.delegate complexDemoWaterfallCollectionViewCell:self didEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoWaterfallCollectionViewCell:didEndScroll:)]) {
            [self.delegate complexDemoWaterfallCollectionViewCell:self didEndScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoWaterfallCollectionViewCell:didEndScroll:)]) {
        [self.delegate complexDemoWaterfallCollectionViewCell:self didEndScroll:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"副滑动回调 scrollView.contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoWaterfallCollectionViewCell:didScroll:)]) {
        [self.delegate complexDemoWaterfallCollectionViewCell:self didScroll:scrollView];
    }
}

#pragma mark - ComplexDemoWaterfallLayoutDelegate

// 返回瀑布流每个item的高度
- (CGFloat)waterfallLayout:(ComplexDemoWaterfallLayout *)layout itemHeightWithIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    if (self.itemModel.itemsArray.count <= index) {
        return 0;
    }
    
    return self.itemModel.itemsArray[index].itemHeight;
}

#pragma mark - Setter

- (void)setItemModel:(ComplexDemoWaterfallModel *)itemModel {
    if (!_itemModel || _itemModel != itemModel) {
        _itemModel = itemModel;
        // 刷表
        [self.collectionView reloadData];
    }
    
    // 重置一下上拉加载状态，防止cell复用的时候加载异常
    if (self.itemModel.itemsArray.count >= 150) { // 允许加载三页
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - Getter

- (ComplexDemoCollectionView *)collectionView {
    if (_collectionView == nil) {
        // 初始化瀑布流布局
        ComplexDemoWaterfallLayout *waterFlowLayout = [[ComplexDemoWaterfallLayout alloc] init];
        // 设置瀑布流列数
        waterFlowLayout.columnCount = 2;
        // 设置瀑布流列之间的间隔
        waterFlowLayout.columnMargin = 9.0;
        // 设置瀑布流行之间的间隔
        waterFlowLayout.rowMargin = 10.0;
        // 设置瀑布流整体内容与视图之间的间距
        waterFlowLayout.contentInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
        // 设置代理
        waterFlowLayout.delegate = self;
        // 初始化CollectionView
        _collectionView = [[ComplexDemoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:waterFlowLayout];
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
        // 设置contentInsetAdjustmentBehavior
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

@end
