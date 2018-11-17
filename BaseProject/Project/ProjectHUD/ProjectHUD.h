//
//  ProjectHUD.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, MBProgressHUDPosition) {
    
    MBProgressHUDPositionTop,
    MBProgressHUDPositionMiddle,
    MBProgressHUDPositionBottom
};

typedef NS_ENUM(NSInteger, MBProgressHUDResult) {
    
    MBProgressHUDResultSuccess,
    MBProgressHUDResultFail
};

@interface ProjectHUD : NSObject

#pragma mark - SystemHUD

+ (void)showSystemHUDToView:(UIView *)view;
+ (void)hideSystemHUDFromView:(UIView *)view;


#pragma mark - MBProgressHUD

/**
 *  显示MBProgressHUD默认的样式：一个大白板，上面一个小菊花
 *
 *  @param  text  如果有文本，则hud下面会跟一行小内容；如果没文本，则hud为纯大白板加小菊花
 */
+ (void)showMBProgressHUDToView:(UIView *)view withText:(NSString *)text;

/**
 *  显示gif
 *
 *  @param  gifName  "xxx.gif"
 */
+ (void)showMBProgressHUDToView:(UIView *)view withGifName:(NSString *)gifName;

/**
 *  显示图片数组模拟gif
 */
+ (void)showMBProgressHUDToView:(UIView *)view withImageNameArray:(NSArray<NSString *> *)imageNameArray;

/**
 *  隐藏MBProgressHUD
 */
+ (void)hideMBProgressHUDFromView:(UIView *)view;

/**
 *  短暂提示类型：显示文本，自动隐藏
 */
+ (void)showMBProgressHUDToView:(UIView *)view withText:(NSString *)text atPosition:(MBProgressHUDPosition)position autoHideAfterTimeInterval:(CGFloat)timeInterval completionHandlerAfterAutohide:(void(^)(void))completionHandler;

/**
 *  短暂提示类型：显示图片和文本，自动隐藏
 */
+ (void)showMBProgressHUDToView:(UIView *)view withText:(NSString *)text image:(NSString *)imageName autoHideAfterTimeInterval:(CGFloat)timeInterval completionHandlerAfterAutohide:(void(^)(void))completionHandler;

/**
 *  短暂提示类型：显示进度环，自动隐藏
 */
// 第一步：请求开始前，展示初始化进度提示
+ (void)showMBProgressHUDToView:(UIView *)view withInitProgressPrompt:(NSString *)prompt;
// 第二步：请求进行中，实时更新HUD的进度和进度提示
+ (void)updateMBProgressHUDOnView:(UIView *)view withProgress:(CGFloat)progress progressPrompt:(NSString *)prompt;
// 第三步：请求结束后，根据请求结果更新HUD
+ (void)updateMBProgressHUDOnView:(UIView *)view withRequstResult:(MBProgressHUDResult)result progressPrompt:(NSString *)prompt autoHideAfterTimeInterval:(CGFloat)timeInterval completionHandlerAfterAutohide:(void(^)(void))completionHandler;

@end
