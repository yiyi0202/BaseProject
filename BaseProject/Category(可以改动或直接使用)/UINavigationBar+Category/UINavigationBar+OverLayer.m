//
//  UINavigationBar+OverLayer.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UINavigationBar+OverLayer.h"
#import <objc/runtime.h>

@implementation UINavigationBar (OverLayer)

+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(setBarTintColor:) swizzledSelector:@selector(yy_setBarTintColor:)];
    });
}


#pragma mark - overLayer

- (void)setOverLayer:(UIView *)overLayer {
    
    objc_setAssociatedObject(self, @"overLayer", overLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overLayer {
    
    return objc_getAssociatedObject(self, @"overLayer");
}


#pragma mark - setBarTintColor
/**
 * 在外界依旧可以继续使用系统提供的设置导航栏颜色的方法, 只不过我们这里通过运行时让它变成修改 overLayer 的颜色了
 */

- (void)yy_setBarTintColor:(UIColor *)barTintColor {
    
    [self yy_setBarTintColor:barTintColor];
    
    if (self.overLayer == nil) {
        
        self.overLayer = [[UIView alloc] init];
        self.overLayer.frame = CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight);
        
        if (self.subviews.count != 0) {
            
            [self.subviews[0] insertSubview:self.overLayer atIndex:0];
            self.overLayer.layer.zPosition = 1;
        }
    }
    
    self.overLayer.backgroundColor = barTintColor;
}


#pragma mark - setAlpha
/**
 * 设置导航栏的透明度, 本质上还是转化为对 overLayer 颜色的控制
 */

- (void)yy_setAlpha:(NSNumber *)scale {
    
    // 为了避免 viewContrlloer 的 navigationBarAlpha 记录错误的值
    if ([scale floatValue] > 1.0) {
        
        scale = @(1.0);
    }
    
    if ([scale floatValue] < 0.0) {
        
        scale = @(0.0);
    }
    
    self.overLayer.backgroundColor = [self.overLayer.backgroundColor colorWithAlphaComponent:[scale floatValue]];

    // iOS11 的 API 改了点
    id apiObject = nil;
    NSUInteger index = [self.items indexOfObject:self.topItem];
    if (kSystemVersion_is_iOS11OrLater) {
        
        apiObject = [[self valueForKey:@"_stack"] valueForKey:@"_items"][index];
    }else {

        apiObject = [self valueForKey:@"_itemStack"][index];
    }

    // 中间的 title(注意这里一定要设置 _label.alpha, 否则会有 bug)
    ((UILabel *)[[apiObject valueForKey:@"_defaultTitleView"] valueForKey:@"_label"]).alpha = [scale floatValue];

    // 如果不是 title, 而是自定义了 titleView(这里要设置 backgroundColor, 否则会有 bug. 自定义 _titleView 这种情况一般不会和隐藏导航栏同时出现, 这样的设计一般不会出现, 所以先不管 textColor 等内容的渐变, 而是只处理 _titleView 背景色的渐变)
    ((UIView *)[apiObject valueForKey:@"_titleView"]).backgroundColor = [((UIView *)[apiObject valueForKey:@"_titleView"]).backgroundColor colorWithAlphaComponent:[scale floatValue]];
    
    // leftBarButtonItems
//    [[apiObject valueForKey:@"_leftBarButtonItems"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
//
//        view.tintColor = [self.tintColor colorWithAlphaComponent:[scale floatValue]];
//        if ([scale floatValue] <= 0) {
//
//            ((UIBarButtonItem *)view).enabled = NO;
//        }else {
//
//            ((UIBarButtonItem *)view).enabled = YES;
//        }
//    }];

    // rightBarButtonItems
//    [[apiObject valueForKey:@"_rightBarButtonItems"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
//
//        view.tintColor = [self.tintColor colorWithAlphaComponent:[scale floatValue]];
//        if ([scale floatValue] <= 0) {
//
//            ((UIBarButtonItem *)view).enabled = NO;
//        }else {
//
//            ((UIBarButtonItem *)view).enabled = YES;
//        }
//    }];
}

@end
