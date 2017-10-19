//
//  UIViewController+DefaultConfiguration.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIViewController+DefaultConfiguration.h"

@implementation UIViewController (DefaultConfiguration)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(loadView) swizzledSelector:@selector(yy_loadView)];
        [self methodSwizzlingWithOriginalSelector:@selector(viewDidLoad) swizzledSelector:@selector(yy_viewDidLoad)];
        [self methodSwizzlingWithOriginalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(yy_viewDidAppear:)];
    });
}


#pragma mark - life cycle

// 和 view 直接相关的配置必须写在 -loadView 里, 否则会出问题
- (void)yy_loadView {
    
    [self yy_loadView];
    
    self.view.backgroundColor = kVCBackgroundColor;
}

- (void)yy_viewDidLoad {
    
    [self yy_viewDidLoad];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    // 默认的导航栏控制器配置
    [self performSelector:@selector(defaultNavigationControllerConfiguration)];

    // 默认的导航栏配置
    [self performSelector:@selector(defaultNavigationBarConfiguration)];
#pragma clang diagnostic pop

    
    // 视图布局原点相关的两个属性
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (!kSystemVersion_is_iOS11OrLater) {// iOS11 中用 scrollView.contentInsetAdjustmentBehavior 代替了 viewController 的 automaticallyAdjustsScrollViewInsets 属性, 所以针对 iOS11 之后的系统只能在外界设置了, 这里只做 iOS11 之前系统的工作
        
        if ([self.navigationController isMemberOfClass:[UIImagePickerController class]]) {// 系统的相册必须得让它自动调整
            
            self.automaticallyAdjustsScrollViewInsets = YES;
        }else {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

- (void)yy_viewDidAppear:(BOOL)animated {
    
    [self yy_viewDidAppear:animated];
    
    // 导航栏默认透明度
    self.navigationBarAlpha = 1.0;
}

@end
