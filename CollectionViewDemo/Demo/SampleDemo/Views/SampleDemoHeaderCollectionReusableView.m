//
//  SampleDemoHeaderCollectionReusableView.m
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "SampleDemoHeaderCollectionReusableView.h"

@interface SampleDemoHeaderCollectionReusableView ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SampleDemoHeaderCollectionReusableView

- (void)configDefaultInit {
    [super configDefaultInit];
    
    self.backgroundColor = [UIColor redColor];
}

- (void)addSubviews {
    [super addSubviews];
    
    [self addSubview:self.titleLabel];
}

- (void)addViewsConstraints {
    [super addViewsConstraints];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

@end
