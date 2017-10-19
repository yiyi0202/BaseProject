//
//  UIViewController+StatusBar.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIViewController+StatusBar.h"

@implementation UIViewController (StatusBar)

// 是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

// 状态栏隐藏与显示状态切换时的动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationNone;
}

// 状态栏颜色. 项目中默认白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
