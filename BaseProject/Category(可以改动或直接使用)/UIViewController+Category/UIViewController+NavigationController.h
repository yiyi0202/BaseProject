//
//  UIViewController+NavigationController.h
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationController)<UIGestureRecognizerDelegate>

/// 是否开启侧滑返回
@property (assign, nonatomic) BOOL enableSlideBack;

@end
