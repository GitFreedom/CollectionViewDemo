//
//  ComplexDemoCustomFloatLayout.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComplexDemoCustomFloatLayout : UICollectionViewFlowLayout

/// 指定section悬浮
@property (nonatomic, assign) NSInteger targetSectionHeaderFloat;

@end

NS_ASSUME_NONNULL_END
