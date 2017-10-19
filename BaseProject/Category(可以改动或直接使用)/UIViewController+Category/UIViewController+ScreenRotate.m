//
//  UIViewController+ScreenRotate.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIViewController+ScreenRotate.h"

@implementation UIViewController (ScreenRotate)

// 是否支持自动旋转. 项目中默认不支持旋转
- (BOOL)shouldAutorotate {
    
    return NO;
}

// 当支持自动旋转时, 可以旋转的方向. 项目中默认当支持自动旋转时, 可以 (正向竖屏+横屏) 旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 这个方法用来控制 presentedViewController 和 presentingViewController 优先展示给用户看到的方向. 项目中默认竖向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

@end
