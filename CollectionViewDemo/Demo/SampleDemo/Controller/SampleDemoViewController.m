//
//  SampleDemoViewController.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//  UICollectionView结合MJRefresh简单使用
//  使用的技术点
//  1、粘性头部  2、多列布局  3、上拉加载更多  4、下拉刷新  5、滑动到指定位置  6、头部组件  7、尾部组件  8、滑动回调  9、是否显示滚动条

#import "SampleDemoViewController.h"

#import "SampleDemoCollectionViewCell.h"
#import "SampleDemoHeaderCollectionReusableView.h"
#import "SampleDemoFooterCollectionReusableView.h"
#import "DemoRefreshGifHeader.h"
#import "DemoRefreshGifFooter.h"

#import "SampleDemoModel.h"

#import "UICollectionView+ScrollToPostion.h"

#import <Masonry/Masonry.h>

@interface SampleDemoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/// collectionView数据源
@property (nonatomic, strong) NSMutableArray<SampleDemoModel *> *dataArray;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SampleDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化设置
    [self _configDefaultInit];
    // 添加视图
    [self _addSubviews];
    // 添加约束
    [self _addViewsConstraints];
    // 设置下来刷新和上拉加载
    [self _configRefresh];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 设置初始偏移位置（进来滑动到第三行顶部）
    [self.collectionView scrollToTargetSection:2 atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - Private

- (NSArray<SampleDemoModel *> *)_produceSampleDataWithCount:(NSInteger)count {
    NSMutableArray<SampleDemoModel *> *tempDataArray = @[].mutableCopy;
    for (NSInteger row = 1; row <= count; row++) {
        SampleDemoModel *model = [[SampleDemoModel alloc] init];
        model.sectionHeaderTitle = [NSString stringWithFormat:@"第%li行头部", (long)row];
        NSMutableArray<NSString *> *tempArray = @[].mutableCopy;
        for (NSInteger col = 1; col <= row; col++) {
            [tempArray addObject:[NSString stringWithFormat:@"第%li行第%li列", (long)row, (long)col]];
        }
        model.itemsArray = tempArray.copy;
        model.sectionFooterTitle = [NSString stringWithFormat:@"第%li行尾部", (long)row];
        [tempDataArray addObject:model];
    }
    return tempDataArray.copy;
}

- (void)_configDefaultInit {
    // 设置控制器标题
    self.title = @"UICollectionView普通应用";
    // 设置控制器视图颜色
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    // 初始化collectionView数据源
    self.dataArray = @[].mutableCopy;
    [self.dataArray addObjectsFromArray:[self _produceSampleDataWithCount:6]];
}

- (void)_addSubviews {
    [self.view addSubview:self.collectionView];
}

- (void)_addViewsConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)_configRefresh {
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [DemoRefreshGifHeader headerWithRefreshingBlock:^{
        // 延迟0.25秒模拟网路请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除原来数据
            [weakSelf.dataArray removeAllObjects];
            // 添加新数据
            [weakSelf.dataArray addObjectsFromArray:[weakSelf _produceSampleDataWithCount:6]];
            // 刷新collectionView数据
            [weakSelf.collectionView reloadData];
            // 停止下拉刷新动画
            [weakSelf.collectionView.mj_header endRefreshing];
            // 重置一下mj_footer状态
            weakSelf.collectionView.mj_footer.state = MJRefreshStateIdle;
        });
    }];
    // 忽略多少scrollView的contentInset的top
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = 0;
    
    // 上拉加载
    self.collectionView.mj_footer = [DemoRefreshGifFooter footerWithRefreshingBlock:^{
        // 延迟0.25秒模拟网路请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 添加新数据
            [weakSelf.dataArray addObjectsFromArray:[weakSelf _produceSampleDataWithCount:6]];
            // 刷新collectionView数据
            [weakSelf.collectionView reloadData];
            // 停止下拉刷新动画
            if (weakSelf.dataArray.count >= 18) { // 允许加载三页
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        });
    }];
    // 忽略多少scrollView的contentInset的bottom
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = 0;
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
    SampleDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.section) {
        if (self.dataArray[indexPath.section].itemsArray.count > indexPath.row) {
            cell.titleLabel.text = self.dataArray[indexPath.section].itemsArray[indexPath.row];
        }
    }
    return cell;
}

// 具体section头和尾实现
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 头
        SampleDemoHeaderCollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[SampleDemoHeaderCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
        if (self.dataArray.count > indexPath.section) {
            sectionHeader.titleLabel.text = self.dataArray[indexPath.section].sectionHeaderTitle;
        }
        return sectionHeader;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) { // 尾
        SampleDemoFooterCollectionReusableView *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[SampleDemoFooterCollectionReusableView reuseIdentifier] forIndexPath:indexPath];
        if (self.dataArray.count > indexPath.section) {
            sectionFooter.titleLabel.text = self.dataArray[indexPath.section].sectionFooterTitle;
        }
        return sectionFooter;
    }
    return [[UICollectionReusableView alloc] init];
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
    if (self.dataArray.count > indexPath.section) {
        // 获取collectionView的宽度
        CGFloat colllectionWidth = CGRectGetWidth(collectionView.frame);
        // 获取当前行有几列
        NSInteger colCount = self.dataArray[indexPath.section].itemsArray.count;
        // 计算每一列的宽度（(colllectionWidth - (colCount - 1) * 每一列的最小间隔) / colCount）
        CGFloat itemWidth = (colllectionWidth - (colCount - 1) * 10.0) / colCount;
        // 返回每一个item的大小
        return CGSizeMake(itemWidth, 80.0);
    }
    return CGSizeZero;
}

// 每个sectionHeader的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 30.0);
}

// 每个sectionFooter的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 30.0);
}

// 每一行内列与列之间的间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark  UIScrollViewDelegate

// 滑动回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"滑动回调 scrollView.contentOffset = %@", NSStringFromCGPoint(scrollView.contentOffset));
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        // 初始化布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置header是否悬停
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        // 设置footer是否悬停
        flowLayout.sectionFootersPinToVisibleBounds = NO;
        // 初始化CollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 设置是否显示滚动条
        _collectionView.showsVerticalScrollIndicator = YES; // 竖直方向
        _collectionView.showsHorizontalScrollIndicator = NO; // 水平方向
        // 设置背景色
        _collectionView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
        // 注册cell
        [_collectionView registerClass:[SampleDemoCollectionViewCell class] forCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier]];
        // 注册sectionHeader
        [_collectionView registerClass:[SampleDemoHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SampleDemoHeaderCollectionReusableView reuseIdentifier]];
        // 注册sectionFooter
        [_collectionView registerClass:[SampleDemoFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[SampleDemoFooterCollectionReusableView reuseIdentifier]];
        
    }
    return _collectionView;
}


@end
