//
//  ComplexDemoItemModel.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComplexDemoWaterfallModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComplexDemoItemModel : NSObject
/// 项标题
@property (nonatomic, copy) NSString *itemTitle;
/// 数据源
@property (nonatomic, copy) NSArray<ComplexDemoWaterfallModel*> *dataArray;

@end

NS_ASSUME_NONNULL_END
