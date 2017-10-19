//
//  ProjectTabBarController.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjectTabBarControllerDelegate <NSObject>

/**
 *  仅当添加了自定义 centerButton 的情况下才需要实现该协议方法
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectCenterButton:(UIButton *)centerButton;

@end

@interface ProjectTabBarController : UITabBarController

/**
 *  正常 tabBar, 用该方法初始化
 */
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                 titles:(NSArray<NSString *> *)titles
                             imageNames:(NSArray<NSString *> *)imageNames
                     selectedImageNames:(NSArray<NSString *> *)selectedImageNames
                               animated:(BOOL)flag;

/**
 *  需要添加自定义 centerButton, 用该方法初始化
 *
 *  @param delegate     :   要响应 ProjectTabBarControllerDelegate 的代理对象
 *  @param size         :   自定义 centerButton 的大小, 传 CGSizeZero 的话则默认 (48, 48) 的大小
 *  @param offset       :   自定义 centerButton 的中心距离默认状态竖向的偏移量, 既凸起多少, 传 0 的话则默认原始位置不凸起
 *  @param imageName    :   自定义 centerButton 的图片
 *  @param flag         :   tabBarItem 的图片是否要跳动动画
 */
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                 titles:(NSArray<NSString *> *)titles
                             imageNames:(NSArray<NSString *> *)imageNames
                     selectedImageNames:(NSArray<NSString *> *)selectedImageNames
                               delegate:(id<ProjectTabBarControllerDelegate>)delegate
                       centerButtonSize:(CGSize)size
                     centerButtonOffset:(CGFloat)offset
                  centerButtonImageName:(NSString *)imageName
                               animated:(BOOL)flag;
@end
