//
//  ProjectPush.m
//  BaseProject
//
//  Created by 意一yiyi on 2018/1/9.
//  Copyright © 2018年 意一yiyi. All rights reserved.
//

#import "ProjectPush.h"

@implementation ProjectPush

/**
 *  配置推送
 *
 *  @param  launchOption  启动参数
 *  @param  isProduction  是否是生产环境
 */
+ (void)configurePushWithLaunchOption:(NSDictionary *)launchOption apsForProduction:(BOOL)isProduction {
    
    // 链接APNs，注册远程推送
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:[UIApplication sharedApplication].delegate];
    
    // 初始化JPush
    [JPUSHService setupWithOption:launchOption
                           appKey:JPush_App_Key
                          channel:@"Publish channel"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}

/**
 *  设置别名：主要用来给拥有该别名的单个用户推送
 *
 *  @param  alias  别名
 */
+ (void)setAlias:(NSString *)alias {
    
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"设置别名===%@, 状态码===%ld", iAlias, (long)iResCode);
    } seq:1111];
}

/**
 *  删除别名
 */
+ (void)deleteAlias {
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {

        NSLog(@"删除别名===%@, 状态码===%ld", iAlias, (long)iResCode);
    } seq:1111];
}

/**
 *  设置标签：主要用来给拥有该标签的批量用户推送
 *
 *  @param  tags  标签数组
 */
+ (void)setTags:(NSSet<NSString *> *)tags {
    
    [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
        NSLog(@"设置标签===%@, 状态码===%ld", iTags, (long)iResCode);
    } seq:1111];
}

/**
 *  删除标签
 */
+ (void)deleteTags:(NSSet<NSString *> *)tags; {
    
    [JPUSHService deleteTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
        NSLog(@"删除标签===%@, 状态码===%ld", iTags, (long)iResCode);
    } seq:1111] ;
}

/**
 *  清空角标：清空极光角标+AppIcon右上角显示
 */
+ (void)resetBadge {
    
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
