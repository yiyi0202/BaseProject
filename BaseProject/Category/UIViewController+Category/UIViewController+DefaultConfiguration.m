//
//  UIViewController+DefaultConfiguration.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIViewController+DefaultConfiguration.h"

@interface UIViewController () <UIGestureRecognizerDelegate>

@end

@implementation UIViewController (DefaultConfiguration)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(loadView) swizzledSelector:@selector(yy_loadView)];
        [self methodSwizzlingWithOriginalSelector:@selector(viewDidLoad) swizzledSelector:@selector(yy_viewDidLoad)];
        [self methodSwizzlingWithOriginalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(yy_viewDidAppear:)];
    });
}

// 和view直接相关的配置必须写在-loadView里，否则会出问题
- (void)yy_loadView {
    
    [self yy_loadView];
    
    // 默认的界面背景色
    self.view.backgroundColor = Default_VC_Background_Color;
}

- (void)yy_viewDidLoad {
    
    [self yy_viewDidLoad];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // 默认的界面布局原点配置
    [self performSelector:@selector(defaultVCLayoutConfiguration)];
#pragma clang diagnostic pop
    

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // 默认的导航栏配置
    [self performSelector:@selector(defaultNavigationBarConfiguration)];
#pragma clang diagnostic pop
}

- (void)yy_viewDidAppear:(BOOL)animated {
    
    [self yy_viewDidAppear:animated];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // 默认的导航栏控制器配置
    [self performSelector:@selector(defaultNavigationControllerConfiguration)];
#pragma clang diagnostic pop
    
    // 默认的导航栏透明度
    self.navigationBarAlpha = 1.0;
}

@end


@implementation UIViewController (VCLayout)

- (void)defaultVCLayoutConfiguration {
    
    // 界面布局原点相关的两个属性
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (System_Version < 11.0) {// iOS11中用scrollView.contentInsetAdjustmentBehavior代替了viewController的automaticallyAdjustsScrollViewInsets属性，所以针对iOS11之后的系统只能在外界设置了，这里只做iOS11之前系统的工作
        
        if ([self.navigationController isMemberOfClass:[UIImagePickerController class]]) {// 系统的相册必须得让它自动调整
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            self.automaticallyAdjustsScrollViewInsets = YES;
#pragma clang diagnostic pop
            
        }else {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
        }
    }
}

@end


@implementation UIViewController (NavigationBar)

// 默认的导航栏配置
- (void)defaultNavigationBarConfiguration {
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 各种颜色
    [self.navigationController.navigationBar setBarTintColor:Default_Navigation_Bar_Tint_Color];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Default_Navigation_Bar_Title_Color}];
    [self.navigationController.navigationBar setTintColor:Default_Navigation_Bar_Bar_Button_Item_Color];
    
    // 返回按钮
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -Navigation_Bar_Height)forBarMetrics:UIBarMetricsDefault];
    if (self.navigationController.viewControllers.count > 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BaseProject_BackArrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemAction:)];
    }
}

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
        [self.navigationController.navigationBar performSelector:@selector(yy_setAlpha:) withObject:@(topSecnondVC.navigationBarAlpha)];// 为了解决点击返回按钮返回时，有透明度变化的导航栏之间出现透明度跳变的bug
#pragma clang diagnostic pop
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)rightBarButtonItem {
    
    
}

@end


@implementation UIViewController (NavigationController)

- (void)defaultNavigationControllerConfiguration {
    
    self.enableSlideBack = YES;
}

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


// 关掉tabBar一级界面的侧滑返回，否则会出bug
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        
        return self.navigationController.viewControllers.count > 1;
    }
    
    return YES;
}

@end


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
