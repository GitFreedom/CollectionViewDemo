//
//  SampleDemoModel.h
//  CollectionViewDemo
//
//  Created by 王俊东 on 2020/8/8.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SampleDemoModel : NSObject
/// sectionHeader标题
@property (nonatomic, copy) NSString *sectionHeaderTitle;
/// item数组
@property (nonatomic, copy) NSArray<NSString *> *itemsArray;
/// sectionFooter标题
@property (nonatomic, copy) NSString *sectionFooterTitle;

@end

NS_ASSUME_NONNULL_END
