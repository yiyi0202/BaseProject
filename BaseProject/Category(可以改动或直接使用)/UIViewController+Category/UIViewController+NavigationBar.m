//
//  UIViewController+NavigationBar.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>

@implementation UIViewController (NavigationBar)

// 默认的导航栏配置
- (void)defaultNavigationBarConfiguration {
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 返回按钮
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -kNavigationBarHeight)forBarMetrics:UIBarMetricsDefault];
    if (self.navigationController.viewControllers.count > 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBarBackArrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemAction:)];
    }
    
    // 各种颜色
    [self.navigationController.navigationBar setBarTintColor:kDefaultNavigationBarTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kDefaultNavigationBarTitleColor}];
    [self.navigationController.navigationBar setTintColor:kDefaultNavigationBarBarButtonItemColor];
}

@end


/**
 *  NavigationBarAlpha
 */
@implementation UIViewController (NavigationBarAlpha)

- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha {
    
    objc_setAssociatedObject(self, @"navigationBarAlpha", @(navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.navigationController.navigationBar performSelector:@selector(yy_setAlpha:) withObject:@(navigationBarAlpha)];
#pragma clang diagnostic pop
}

- (CGFloat)navigationBarAlpha {
    
    return [objc_getAssociatedObject(self, @"navigationBarAlpha") floatValue];;
}

@end


/**
 *  NavigationBarButtonItem
 */
@implementation UIViewController (NavigationBarButtonItem)

- (UIBarButtonItem *)generateLeftBarButtonItemWithTitle:(NSString *)title {
    
    return [[UIBarButtonItem alloc] initWithTitle:title style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemAction:)];
}

- (UIBarButtonItem *)generateLeftBarButtonItemWithImage:(UIImage *)image {
    
    return [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemAction:)];
}

- (UIBarButtonItem *)generateLeftBarButtonItemWithCustomView:(UIView *)customView {
    
    if ([customView isKindOfClass:[UIControl class]]) {
        
        [((UIControl *)customView) addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    return tempBarButtonItem;
}

- (UIBarButtonItem *)generateRightBarButtonItemWithTitle:(NSString *)title {
    
    return [[UIBarButtonItem alloc] initWithTitle:title style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
}

- (UIBarButtonItem *)generateRightBarButtonItemWithImage:(UIImage *)image {
    
    return [[UIBarButtonItem alloc] initWithImage:image style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
}

- (UIBarButtonItem *)generateRightBarButtonItemWithCustomView:(UIView *)customView {
    
    if ([customView isKindOfClass:[UIControl class]]) {
        
        [((UIControl *)customView) addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    return tempBarButtonItem;
}

- (void)leftBarButtonItemAction:(UIBarButtonItem *)leftBarButtonItem {
    
    if (self.navigationController.viewControllers.count > 1)  {
        
        UIViewController *topSecnondVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [self.navigationController.navigationBar performSelector:@selector(yy_setAlpha:) withObject:@(topSecnondVC.navigationBarAlpha)];// 为了解决点击返回按钮返回时, 有透明度变化的导航栏之间出现透明度跳变的 bug
#pragma clang diagnostic pop
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)rightBarButtonItem {
    
    
}

@end
