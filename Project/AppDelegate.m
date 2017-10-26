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
    
    return YES;
}

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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
