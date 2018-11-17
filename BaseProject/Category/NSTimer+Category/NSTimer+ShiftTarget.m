//
//  NSTimer+ShiftTarget.m
//  Test
//
//  Created by 意一yiyi on 2017/9/15.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSTimer+ShiftTarget.h"
#import <objc/runtime.h>

@implementation NSTimer (ShiftTarget)

+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(timerWithTimeInterval:repeats:block:) swizzledSelector:@selector(yy_timerWithTimeInterval:repeats:block:)];
        [self methodSwizzlingWithOriginalSelector:@selector(scheduledTimerWithTimeInterval:repeats:block:) swizzledSelector:@selector(yy_scheduledTimerWithTimeInterval:repeats:block:)];
    });
}

// 对 NSTimer 的创建包一层
+ (NSTimer *)yy_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    
    // 把外界传进来的 block 变量作为 userInfo 传递给我们内部创建好的 timer
    return [self timerWithTimeInterval:interval target:self selector:@selector(timerFire:) userInfo:block repeats:repeats];
}

+ (NSTimer *)yy_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerFire:) userInfo:block repeats:repeats];
}

+ (void)timerFire:(NSTimer *)timer {
    
    // 接收到 userInfo
    if ([timer.userInfo isKindOfClass:NSClassFromString(@"NSBlock")]) {
        
        // 将 userInfo 强转为 block
        void (^block)(NSTimer *timer) = timer.userInfo;
        
        // 调用 block, 然后就会去外界找 block 的实现
        block(timer);
    }
}

@end
