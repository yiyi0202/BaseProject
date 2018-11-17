//
//  NSTimer+ShiftTarget.h
//  Test
//
//  Created by 意一yiyi on 2017/9/15.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

//==================================================================================//
// 该分类的主要作用：替换timer创建方法的实现，从而避免timer对控制器的强引用导致控制器无法释放的问题 //
//==================================================================================//

#import <Foundation/Foundation.h>

@interface NSTimer (ShiftTarget)

@end