//
//  UINavigationController+Push_SlideBack.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UINavigationController+Push_SlideBack.h"

@interface UINavigationController () <UINavigationControllerDelegate>

@end


@implementation UINavigationController (Push_SlideBack)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(pushViewController:animated:) swizzledSelector:@selector(yy_pushViewController:animated:)];
        [self methodSwizzlingWithOriginalSelector:NSSelectorFromString(@"_updateInteractiveTransition:") swizzledSelector:@selector(yy__updateInteractiveTransition:)];
    });
}


#pragma mark - push

// push的时候自动隐藏tabBar
- (void)yy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 因为这句话是写在push操作前面的，所以在push出下个界面之前self.viewControllers是不会增加的，所以我们检测到self.viewControllers.count == 1就该隐藏了，然后才等它push出下个界面，self.viewControllers.count这时才会变成2
    if (self.viewControllers.count >= 1) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句话是用来完成push操作的，所以应该写在后面。因为要是写在前面的话，等执行到hidesBottomBarWhenPushed时已经完成了push操作，根本来不及检测WhenPushed这种状态，所以会出问题
    [self yy_pushViewController:viewController animated:animated];
    
    // 本来计划把push和slideBack写成两个分类的，但是这个slideBack会用到的代理的设置时机只能在push的时候设置，所以只能写一块了
    if ([[self class] isEqual:[UIImagePickerController class]]) {// 这里会导致UIImagePickerController选照片或拍照是不可编辑
        
        return;
    }
    if (self.delegate != self) {

        self.delegate = self;
    }
}


#pragma mark - slide back

// 侧滑返回会调用的方法
- (void)yy__updateInteractiveTransition:(CGFloat)percentComplete {
    
    [self yy__updateInteractiveTransition:(percentComplete)];
    
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        if (coordinator != nil) {
            
            CGFloat fromAlpha = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarAlpha;// 读取要返回的viewController的导航栏透明度
            CGFloat toAlpha = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarAlpha;// 读取要返回到的viewController的导航栏透明度
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
                        
            [self yy_setNavigationBarAlpha:@(nowAlpha)];
        }
    }
}


#pragma mark - UINavigationControllerDelegate

// 这是UINavigationControllerDelegate里的一个方法，我们使用该方法来处理侧滑到中途松手的情况，如果不处理的话导航栏的效果会出偏差
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        if (coordinator != nil) {
            
            if (@available(iOS 10.0, *)) {
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    
                    [self dealInteractionChanges:context];
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


#pragma mark - private method

- (void)yy_setNavigationBarAlpha:(NSNumber *)navigationBarAlpha {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self.navigationBar performSelector:@selector(yy_setAlpha:) withObject:navigationBarAlpha];
#pragma clang diagnostic pop
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    
    if ([context isCancelled]) {// 滑了一小半不滑了，松手，自动取消返回手势
        
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarAlpha;
            [self yy_setNavigationBarAlpha:@(nowAlpha)];
        }];
    } else {// 滑了一大半，松手，自动完成返回手势
        
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:
                                UITransitionContextToViewControllerKey].navigationBarAlpha;
            [self yy_setNavigationBarAlpha:@(nowAlpha)];
        }];
    }
}

@end


@implementation UINavigationController (StatusBar)

// navigationController会拦截其子控制器关于状态栏的配置，所以这里返回其childViewController的相关配置
- (BOOL)prefersStatusBarHidden {
    
    return self.topViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return self.topViewController.preferredStatusBarUpdateAnimation;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return self.topViewController.preferredStatusBarStyle;
}

@end
