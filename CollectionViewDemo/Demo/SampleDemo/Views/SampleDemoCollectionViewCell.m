//
//  SampleCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "SampleDemoCollectionViewCell.h"

@interface SampleDemoCollectionViewCell ()
/// 背景视图
@property (nonatomic, strong) UIView *bgView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SampleDemoCollectionViewCell

#pragma mark - Override

- (void)addSubviews {
    [super addSubviews];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
}

- (void)addViewsConstraints {
    [super addViewsConstraints];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.0);
        make.right.mas_equalTo(-5.0);
        make.centerY.equalTo(self.bgView);
    }];
}

#pragma mark - Getter

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8.0;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
