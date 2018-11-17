//
//  NSUserDefaults+SaveComplexObject.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/25.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSUserDefaults+SaveComplexObject.h"

@implementation NSUserDefaults (SaveComplexObject)

- (void)yy_setComplexObject:(id)value forKey:(NSString *)defaultName {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:value];
#pragma clang diagnostic pop

    [NS_User_Defaults setObject:writeData forKey:defaultName];
}

- (id)yy_complexObjectForKey:(NSString *)defaultName {

    NSData *readData = [NS_User_Defaults objectForKey:defaultName];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    return [NSKeyedUnarchiver unarchiveObjectWithData:readData];
#pragma clang diagnostic pop
}

@end
