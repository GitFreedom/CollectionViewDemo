//
//  ComplexDemoWaterfallModel.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComplexDemoWaterfallItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComplexDemoWaterfallModel : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;
/// 数据源
@property (nonatomic, strong) NSMutableArray<ComplexDemoWaterfallItemModel*> *itemsArray;

@end

NS_ASSUME_NONNULL_END
