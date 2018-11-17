//
//  NSObject+MethodSwizzling.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

//==============================================================//
// 该分类的作用：为NSObject扩展一个黑魔法的方法，供需要使用黑魔法的子类调用 //
//==============================================================//
@interface NSObject (MethodSwizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
