//
//  UIButton+PreventViolentClick.m
//  BaseProject
//
//  Created by 意一yiyi on 2018/10/17.
//  Copyright © 2018年 意一yiyi. All rights reserved.
//

#import "UIButton+PreventViolentClick.h"
#import <objc/runtime.h>

#define kTwoTimeClickTimeInterval 1.0// 两次点击的时间间隔，用来确定后一次点击是否被认定为暴力点击

@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval yy_lastTimeClickTimestamp;// 上一次点击的时间戳

@end

@implementation UIButton (PreventViolentClick)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(yy_sendAction:to:forEvent:);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        IMP originalIMP = method_getImplementation(originalMethod);
        IMP swizzleIMP = method_getImplementation(swizzledMethod);
        
        const char *originalTypeEncoding = method_getTypeEncoding(originalMethod);
        const char *swizzledTypeEncoding = method_getTypeEncoding(swizzledMethod);
        
        BOOL didAddMethod = class_addMethod(self, originalSelector, swizzleIMP, swizzledTypeEncoding);
        
        if (didAddMethod) {
            
            class_replaceMethod(self, swizzledSelector, originalIMP, originalTypeEncoding);
        } else {
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)yy_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event  {
    
    if ([[self class] isEqual:[UIButton class]]) {// 确保只替换掉UIButton的方法，而不会替换掉UIButton类簇里子类的方法
        
        // 获取此次点击的时间戳
        NSTimeInterval currentTimeClickTimestamp = [[NSDate date] timeIntervalSince1970];
        
        if (currentTimeClickTimestamp - self.yy_lastTimeClickTimestamp < kTwoTimeClickTimeInterval) {// 如果此次点击和上一次点击的时间间隔小于我们设定的时间间隔，则判定此次点击为暴力点击，什么都不做
            
            return;
        } else {// 否则我们判定此次点击为正常点击，button正常处理事件
            
            // 记录上次点击的时间戳
            self.yy_lastTimeClickTimestamp = currentTimeClickTimestamp;
            
            [self yy_sendAction:action to:target forEvent:event];
        }
    }else {
        
        [self yy_sendAction:action to:target forEvent:event];
    }
}

- (void)setYy_lastTimeClickTimestamp:(NSTimeInterval)yy_lastTimeClickTimestamp {
    
    objc_setAssociatedObject(self, @"yy_lastTimeClickTimestamp", @(yy_lastTimeClickTimestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)yy_lastTimeClickTimestamp {
    
    return [objc_getAssociatedObject(self, @"yy_lastTimeClickTimestamp") doubleValue];
}

@end
