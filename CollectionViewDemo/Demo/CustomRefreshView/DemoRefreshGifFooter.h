//
//  DemoRefreshGifFooter.h
//  CollectionViewDemo
//
//  Created by kaishujianggushi on 2020/8/10.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoRefreshGifFooter : MJRefreshAutoGifFooter

@property (nonatomic, copy) NSString *noMoreLabelText;
@property (nonatomic, copy) NSString *noMoreImageName;
@property (nonatomic, assign) BOOL showNoMoreImage;

@end

NS_ASSUME_NONNULL_END
