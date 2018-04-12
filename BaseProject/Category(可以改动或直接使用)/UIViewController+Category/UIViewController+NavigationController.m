//
//  UIViewController+NavigationController.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIViewController+NavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationController)

- (void)defaultNavigationControllerConfiguration {
    
    self.enableSlideBack = YES;
}


#pragma mark - 是否开启侧滑返回

- (void)setEnableSlideBack:(BOOL)enableSlideBack {
    
    objc_setAssociatedObject(self, @"enableSlideBack", @(enableSlideBack), OBJC_ASSOCIATION_RETAIN);

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (enableSlideBack) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (BOOL)enableSlideBack {
    
    return [objc_getAssociatedObject(self, @"enableSlideBack") boolValue];
}


#pragma mark - UIGestureRecognizerDelegate

// 关掉 tabBar 一级界面的侧滑返回, 否则会出 bug
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {

        return self.navigationController.viewControllers.count > 1;
    }

    return YES;
}

@end
