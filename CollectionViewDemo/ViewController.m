//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ViewController.h"
#import "SampleDemoViewController.h"
#import "ComplexDemoViewController.h"

#import "DemoCollectionViewCell.h"

#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/// collectionView数据源
@property (nonatomic, copy) NSArray *dataArray;
/// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化设置
    [self _configDefaultInit];
    // 添加视图
    [self _addSubviews];
    // 添加约束
    [self _addViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 去掉导航栏的半透明效果
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Private

- (void)_configDefaultInit {
    // 设置控制器标题
    self.title = @"UICollectionViewDemo";
    // 设置控制器视图颜色
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化collectionView数据源
    self.dataArray = @[@"UICollectionView普通应用", @"UICollectionView嵌套应用"];
}

- (void)_addSubviews {
    [self.view addSubview:self.collectionView];
}

- (void)_addViewsConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DemoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    if (self.dataArray.count > indexPath.row) {
        cell.titleLabel.text = self.dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            SampleDemoViewController *sampleViewController = [[SampleDemoViewController alloc] init];
            [self.navigationController pushViewController:sampleViewController animated:YES];
        } break;
        case 1: {
            ComplexDemoViewController *complexDemoViewController = [[ComplexDemoViewController alloc] init];
            [self.navigationController pushViewController:complexDemoViewController animated:YES];
        } break;
        default:
            break;
    }
}

#pragma mark  UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 60.0);
}


#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DemoCollectionViewCell class] forCellWithReuseIdentifier:[DemoCollectionViewCell reuseIdentifier]];
    }
    return _collectionView;
}


@end
