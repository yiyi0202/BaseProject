//
//  AppDelegate.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "AppDelegate.h"
#import "HomepageViewController.h"
#import "MineViewController.h"

@interface AppDelegate ()<ProjectTabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@", NSHomeDirectory());
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
//    ProjectTabBarController *tabBarController = [[ProjectTabBarController alloc] initWithViewControllers:@[[HomepageViewController new], [MineViewController new]] titles:nil imageNames:@[@"homepage", @"mine"] selectedImageNames:@[@"homepage_selected", @"mine_selected"] delegate:self centerButtonSize:CGSizeMake(61, 61) centerButtonOffset:-24 centerButtonImageName:@"live" animated:YES];
    ProjectTabBarController *tabBarController = [[ProjectTabBarController alloc] initWithViewControllers:@[[HomepageViewController new], [MineViewController new]] titles:nil imageNames:@[@"homepage", @"mine"] selectedImageNames:@[@"homepage_selected", @"mine_selected"] animated:NO];
    
    [self.window setRootViewController:tabBarController];
    
    
#pragma mark - 社会化组件
    
    [ProjectSocial configureSocialWithSocialType:(ProjectSocialTypeShareSDK)];
    
#pragma mark - JPush
    
    [ProjectPush configurePushWithLaunchOption:launchOptions apsForProduction:NO];
    
    
    return YES;
}


#pragma mark - 设置系统回调

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    
    if (!result) {
        
        // 其他如支付等SDK的回调
    }
    
    return result;
}


#pragma mark - JPush

// 注册远程推送成功，并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
}

// 注册远程推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

    NSLog(@"注册远程推送失败：%@", error);
}

//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    NSLog(@"%@", userInfo);

    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 Support，前台收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }else {
        
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}


#pragma mark - ProjectTabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectCenterButton:(UIButton *)centerButton {
    
    NSLog(@"111111111111");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [ProjectPush resetBadge];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [ProjectPush resetBadge];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
