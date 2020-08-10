//
//  ComplexDemoSectionHeaderReusableView.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "DemoBaseCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@class ComplexDemoHeaderCollectionReusableView, ComplexDemoSectionModel;

@protocol ComplexDemoHeaderCollectionReusableViewDelegate <NSObject>

@optional
/// 点击item回调
/// @param sectionHeader ComplexDemoHeaderCollectionReusableView
/// @param indexPath  位置
- (void)complexDemoHeaderCollectionReusableView:(ComplexDemoHeaderCollectionReusableView *)sectionHeader
                       didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ComplexDemoHeaderCollectionReusableView : DemoBaseCollectionReusableView
/// 代理
@property (nonatomic, weak) id<ComplexDemoHeaderCollectionReusableViewDelegate> delegate;
/// 选中的位置
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
/// 模型数据
@property (nonatomic, strong) ComplexDemoSectionModel *sectionModel;

@end

NS_ASSUME_NONNULL_END
