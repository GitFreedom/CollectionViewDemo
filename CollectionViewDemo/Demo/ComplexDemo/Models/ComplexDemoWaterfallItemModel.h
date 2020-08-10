//
//  ComplexDemoWaterfallItemModel.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/9.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComplexDemoWaterfallItemModel : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;

/// 瀑布流里面项高度
@property (nonatomic, assign) CGFloat itemHeight;
@end

NS_ASSUME_NONNULL_END
