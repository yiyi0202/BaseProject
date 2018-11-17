//
//  NSObject+ArchiveAndUnarchive.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSObject+ArchiveAndUnarchive.h"
#import <objc/runtime.h>

@interface NSObject ()<NSCoding>

@end

@implementation NSObject (ArchiveAndUnarchive)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    // 记录一个类成员变量的个数
    unsigned int ivarCount = 0;
    // 获取一个类的成员变量列表
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    
    for (int i = 0; i < ivarCount; i ++) {
        
        // 获取单个成员变量
        Ivar ivar = ivars[i];
        
        // 获取成员变量的名字并将其转换为OC字符串
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 获取该成员变量对应的值
        id value = [self valueForKey:key];
        
        // encode
        [aCoder encodeObject:value forKey:key];
    }
    
    // 释放ivars
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    // 因为没有superClass了
    self = [self init];
    
    if (self != nil) {
        
        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &ivarCount);
        for (int i = 0; i < ivarCount; i ++) {
            
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            // decode
            id value = [aDecoder decodeObjectForKey:key];
            
            // 赋值
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    
    return self;
}

#pragma clang diagnostic pop

@end
