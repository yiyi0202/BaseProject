//
//  UICollectionView+Adaptation.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/13.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UICollectionView+Adaptation.h"

@implementation UICollectionView (Adaptation)

- (void)yy_AdaptiOS11 {
    
    // 不要让系统自动为我们调整 collectionView 的大小, 我们自己控制
    if (@available(iOS 11.0, *)) {
        
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        // Fallback on earlier versions
    }
}

@end
