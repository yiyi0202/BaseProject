//
//  ProjectMaskView.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectMaskView.h"

@interface ProjectMaskView ()

@property (nonatomic, assign) BOOL animationed;

@end

@implementation ProjectMaskView

#pragma mark - life cycle

- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.382];
    }
    
    return self;
}


#pragma mark - public method

+ (instancetype)showToView:(UIView *)view withCustomSubview:(UIView *)customSubview subviewLayout:(void(^)(void))layout subviewAnimation:(void(^)(void))animation {

    ProjectMaskView *maskView = [[ProjectMaskView alloc] init];
    
    [maskView addSubview:customSubview];
    [view addSubview:maskView];
    customSubview.tag = 11111111111;
    
    if (layout) {
        
        layout();
    }
    
    if (animation) {
        
        // 子视图自定义动画
        animation();
    }else {
        
        // 子视图默认动画
        customSubview.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        [UIView animateWithDuration:0.25 animations:^{
            
            customSubview.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return maskView;
}

+ (void)hideFromView:(UIView *)view withSubviewAnimation:(NSTimeInterval(^)(void))block {
    
    ProjectMaskView *maskView = [self maskViewForView:view];
    
    if (maskView != nil) {
        
        UIView *tempCustomView = [maskView viewWithTag:11111111111];
    
        if (block == nil) {
            
            tempCustomView.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:0.25 animations:^{
                
                tempCustomView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
            } completion:^(BOOL finished) {
                
                [maskView removeFromSuperview];
            }];
        }else {
        
            NSTimeInterval animationDuration = block();
            // 因为 block 是异步执行的, 所以这里做个延时
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [maskView removeFromSuperview];
            });
        }
    }
}


#pragma mark - private method

+ (ProjectMaskView *)maskViewForView:(UIView *)view {
    
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            
            return (ProjectMaskView *)subview;
        }
    }
    return nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.tapBlock) {
        
        self.tapBlock();
    }
}

@end
