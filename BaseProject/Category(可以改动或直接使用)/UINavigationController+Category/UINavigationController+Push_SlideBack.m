//
//  UINavigationController+Push_SlideBack.m
//  BaseProject
//
//  Created by zhangshuo on 2017/10/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UINavigationController+Push_SlideBack.h"

@implementation UINavigationController (Push_SlideBack)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(pushViewController:animated:) swizzledSelector:@selector(yy_pushViewController:animated:)];
        [self methodSwizzlingWithOriginalSelector:NSSelectorFromString(@"_updateInteractiveTransition:") swizzledSelector:@selector(yy__updateInteractiveTransition:)];
    });
}


#pragma mark - push

// push 的时候自动隐藏 tabBar
- (void)yy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 因为这句话是写在 push 操作前面的, 所以在 push 出下个界面之前 self.viewControllers 是不会增加的, 所以我们检测到 self.viewControllers.count == 1 就该隐藏了, 然后才等它 push 出下个界面, self.viewControllers.count 这时才会变成 2
    if (self.viewControllers.count >= 1) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句话是用来完成 push 操作的, 所以应该写在后面. 因为要是写在前面的话, 等执行到 hidesBottomBarWhenPushed 时已经完成了 push 操作, 根本来不及检测 WhenPushed 这种状态, 所以会出问题
    [self yy_pushViewController:viewController animated:animated];
    
    // 本来计划把 push 和 slideBack 写成两个分类的, 但是这个 slideBack 会用到的代理的设置时机只能在 push 的时候设置, 所以只能写一块了
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
            
            CGFloat fromAlpha = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarAlpha;// 读取要返回的 viewController 的导航栏透明度
            CGFloat toAlpha = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarAlpha;// 读取要返回到的 viewController 的导航栏透明度
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
                        
            [self yy_setNavigationBarAlpha:@(nowAlpha)];
        }
    }
}


#pragma mark - UINavigationControllerDelegate

// 这是 UINavigationControllerDelegate 里的一个方法, 我们使用该方法来处理侧滑到中途松手的情况, 如果不处理的话导航栏的效果会出偏差
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        
        id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
        if (coordinator != nil) {
            
            if (kSystemVersion_is_iOS10OrLater) {
                
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    
                    [self dealInteractionChanges:context];
                }];
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
    
    if ([context isCancelled]) {// 滑了一小半不滑了, 松手, 自动取消返回手势
        
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarAlpha;
            [self yy_setNavigationBarAlpha:@(nowAlpha)];
        }];
    } else {// 滑了一大半, 松手, 自动完成返回手势
        
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:
                                UITransitionContextToViewControllerKey].navigationBarAlpha;
            [self yy_setNavigationBarAlpha:@(nowAlpha)];
        }];
    }
}

@end
