//
//  ComplexDemoSectionHeaderReusableView.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoHeaderCollectionReusableView.h"
#import "SampleDemoCollectionViewCell.h"

#import "ComplexDemoSectionModel.h"

@interface ComplexDemoHeaderCollectionReusableView ()<UICollectionViewDelegate, UICollectionViewDataSource>
/// 数据源
@property (nonatomic, copy) NSArray<ComplexDemoWaterfallModel*> *dataArray;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ComplexDemoHeaderCollectionReusableView

#pragma mark - Override

- (void)configDefaultInit {
    [super configDefaultInit];
    
    // 设置背景色
    self.backgroundColor = [UIColor redColor];
    // 初始化选中的位置
    _selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
}

- (void)addSubviews {
    [super addSubviews];
    
    [self addSubview:self.collectionView];
}

- (void)addViewsConstraints {
    [super addViewsConstraints];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10.0);
        make.right.bottom.mas_equalTo(-10.0);
    }];
}

#pragma mark - UICollectionViewDataSource

// 控制对应行有几列
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 具体item实现
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SampleDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        cell.titleLabel.text = self.dataArray[indexPath.row].title;
    }
    cell.titleLabel.textColor = [indexPath compare:self.selectIndexPath] == NSOrderedSame ? [UIColor redColor] : [UIColor blackColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

// 每个元素点击事件回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%li行", (long)indexPath.row);
    if (self.delegate && [self.delegate respondsToSelector:@selector(complexDemoHeaderCollectionReusableView:didSelectItemAtIndexPath:)]) {
        [self.delegate complexDemoHeaderCollectionReusableView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark  UICollectionViewDelegateFlowLayout

// 每个元素对应的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 0) {
        // 获取collectionView的宽度
        CGFloat colllectionWidth = CGRectGetWidth(collectionView.frame);
        // 获取当前行有几列
        NSInteger colCount = self.dataArray.count;
        // 计算每一列的宽度（(colllectionWidth - (colCount - 1) * 每一列的最小间隔) / colCount）
        CGFloat itemWidth = (colllectionWidth - (colCount - 1) * 10.0) / colCount;
        // 返回每一个item的大小
        return CGSizeMake(itemWidth, CGRectGetHeight(collectionView.frame));
    }
    return CGSizeZero;
}

#pragma mark - Setter

- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath {
    if (!_selectIndexPath || [_selectIndexPath compare:selectIndexPath] != NSOrderedSame) {
        _selectIndexPath = selectIndexPath;
        [self.collectionView reloadData];
    }
}

- (void)setSectionModel:(ComplexDemoSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    // 更新数据源
    if (_sectionModel.itemsArray && _sectionModel.itemsArray.count > 0) {
        self.dataArray = _sectionModel.itemsArray.firstObject.dataArray;
    } else {
        self.dataArray = @[];
    }
    // 刷新数据
    [self.collectionView reloadData];
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        // 初始化布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 每一行内列与列之间的间隔
        flowLayout.minimumInteritemSpacing = 10.0;
        // 初始化CollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 设置是否显示滚动条
        _collectionView.showsVerticalScrollIndicator = NO; // 竖直方向
        _collectionView.showsHorizontalScrollIndicator = NO; // 水平方向
        // 设置背景色
        _collectionView.backgroundColor = [UIColor redColor];
        // 注册cell
        [_collectionView registerClass:[SampleDemoCollectionViewCell class] forCellWithReuseIdentifier:[SampleDemoCollectionViewCell reuseIdentifier]];
    }
    return _collectionView;
}

@end
