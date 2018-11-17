//
//  ProjectSingleton.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectSingleton.h"

@implementation ProjectSingleton

static ProjectSingleton *singleton = nil;
+ (instancetype)sharedSingleton {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [[ProjectSingleton alloc] init];
    });
    
    return singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [ProjectSingleton sharedSingleton];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    
    return [ProjectSingleton sharedSingleton];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    
    return [ProjectSingleton sharedSingleton];
}

- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        
        // 一些属性的设置
    }
    
    return self;
}

@end
