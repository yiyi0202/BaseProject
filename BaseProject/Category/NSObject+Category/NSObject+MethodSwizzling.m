//
//  NSObject+MethodSwizzling.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (MethodSwizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
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
}

@end
