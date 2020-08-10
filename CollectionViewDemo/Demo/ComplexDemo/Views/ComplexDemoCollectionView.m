//
//  ComplexDemoCollectionView.m
//  CollectionViewDemo
//
//  Created by kaishujianggushi on 2020/8/10.
//  Copyright © 2020 王俊东. All rights reserved.
//

#import "ComplexDemoCollectionView.h"

@implementation ComplexDemoCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];;
}

@end
