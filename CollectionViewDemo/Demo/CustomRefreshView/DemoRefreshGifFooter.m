//
//  DemoRefreshGifFooter.m
//  CollectionViewDemo
//
//  Created by kaishujianggushi on 2020/8/10.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoRefreshGifFooter.h"

@interface DemoRefreshGifFooter ()
/// 图标
@property (nonatomic, strong) UIImageView *noMoreImgView;
/// 文案
@property (nonatomic, strong) UILabel *noMoreLabel;

@end

@implementation DemoRefreshGifFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    self.mj_h = 50;
    self.showNoMoreImage = YES;
    [self setBackgroundColor:[UIColor clearColor]];
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_footer%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages duration:refreshingImages.count * 0.2 forState:MJRefreshStateRefreshing];
    self.stateLabel.hidden = YES;

    [self addSubview:self.noMoreLabel];
    [self addSubview:self.noMoreImgView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    self.gifView.frame = self.bounds;
    self.gifView.contentMode = UIViewContentModeCenter;
    [self.gifView startAnimating];

    CGFloat imgWidth = 25.0;
    CGFloat lblWidth = [self returnTextWidth:self.noMoreLabel.text size:CGSizeMake(self.mj_w - imgWidth - 9, MAXFLOAT) font:self.noMoreLabel.font].width;
    if (self.showNoMoreImage) {
        self.noMoreImgView.frame = CGRectMake((self.mj_w - (imgWidth + lblWidth + 9)) / 2.0, (self.mj_h - 11) / 2.0, imgWidth, 11);
        self.noMoreLabel.frame = CGRectMake(CGRectGetMaxX(self.noMoreImgView.frame) + 9, (self.mj_h - 11) / 2.0, lblWidth, 11);
    } else {
        self.noMoreLabel.frame = CGRectMake((self.mj_w - lblWidth )/2.0, (self.mj_h - 11) / 2.0, lblWidth, 11);
    }
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

- (CGSize)returnTextWidth:(NSString *)text size:(CGSize)size font:(UIFont *)font{
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    return textSize;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            self.noMoreImgView.hidden = YES;
            self.noMoreLabel.hidden = YES;
            break;
        case MJRefreshStatePulling:
            self.noMoreImgView.hidden = YES;
            self.noMoreLabel.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            self.noMoreImgView.hidden = YES;
            self.noMoreLabel.hidden = YES;
            break;
        case MJRefreshStateNoMoreData:
            self.noMoreImgView.hidden = !self.showNoMoreImage;
            self.noMoreLabel.hidden = NO;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}

- (void)setNoMoreImageName:(NSString *)noMoreImageName {
    _noMoreImageName = noMoreImageName.copy;
    self.noMoreImgView.image = [UIImage imageNamed:_noMoreImageName];
}

- (void)setNoMoreLabelText:(NSString *)noMoreLabelText {
    _noMoreLabelText = noMoreLabelText.copy;
    self.noMoreLabel.text = _noMoreLabelText;
}

- (void)setShowNoMoreImage:(BOOL)showNoMoreImage {
    _showNoMoreImage = showNoMoreImage;
    self.noMoreImgView.hidden = !_showNoMoreImage;
}

#pragma mark - Getter

- (UIImageView *)noMoreImgView {
    if (!_noMoreImgView) {
        _noMoreImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_refresh_nomore"]];
        _noMoreImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noMoreImgView;
}

- (UILabel *)noMoreLabel {
    if (!_noMoreLabel) {
        _noMoreLabel = [UILabel new];
        _noMoreLabel.textColor = [UIColor lightGrayColor];
        _noMoreLabel.font = [UIFont systemFontOfSize:12];
        _noMoreLabel.textAlignment = NSTextAlignmentLeft;
        _noMoreLabel.text = @"没有更多了";
    }
    return _noMoreLabel;
}

@end
