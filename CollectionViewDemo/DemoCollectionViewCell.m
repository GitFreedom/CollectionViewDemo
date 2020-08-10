//
//  DemoCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoCollectionViewCell.h"

@interface DemoCollectionViewCell ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DemoCollectionViewCell

#pragma mark - Override

- (void)addSubviews {
    [super addSubviews];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)addViewsConstraints {
    [super addViewsConstraints];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

@end
