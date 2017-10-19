//
//  UITabBarController+ScreenRotate.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UITabBarController+ScreenRotate.h"

@implementation UITabBarController (ScreenRotate)

// tabBarController 会拦截其子控制器关于屏幕旋转的配置, 所以这里返回其 childViewController 的相关配置
- (BOOL)shouldAutorotate {
    
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}

@end
