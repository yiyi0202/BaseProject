//
//  ProjectPush.h
//  BaseProject
//
//  Created by 意一yiyi on 2018/1/9.
//  Copyright © 2018年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>// iOS10注册APNs所需头文件
#endif

@interface ProjectPush : NSObject

/**
 *  配置推送
 *
 *  @param  launchOption  启动参数
 *  @param  isProduction  是否是生产环境
 */
+ (void)configurePushWithLaunchOption:(NSDictionary *)launchOption apsForProduction:(BOOL)isProduction;

/**
 *  设置别名：主要用来给拥有该别名的单个用户推送
 *
 *  @param  alias  别名
 */
+ (void)setAlias:(NSString *)alias;

/**
 *  删除别名
 */
+ (void)deleteAlias;

/**
 *  设置标签：主要用来给拥有该标签的批量用户推送
 *
 *  @param  tags  标签数组
 */
+ (void)setTags:(NSSet<NSString *> *)tags;

/**
 *  删除标签
 */
+ (void)deleteTags:(NSSet<NSString *> *)tags;

/**
 *  清空角标：清空极光角标+AppIcon右上角显示
 */
+ (void)resetBadge;

@end
