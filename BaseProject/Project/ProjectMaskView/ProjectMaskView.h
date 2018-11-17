//
//  ProjectMaskView.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

//==================================================================================================//
// 该类的作用 :
// (1)主要是针对自定义弹窗时, 每定义一个弹窗就得在弹窗下面写一个 maskView 盖住屏幕防止用户的误触, 所以就提取出来这个 maskView, 我们只需要自定义一个弹窗作为子视图传给这个 maskView 就行了
// (2)由于此, 我们也可以发现这个类除了应用于弹窗之外, 还可以用于其它一些需要给屏幕盖一层东西然后再把需要显示的东西展示出来的场景, 防止用户误触
//==================================================================================================//

#import <UIKit/UIKit.h>

@interface ProjectMaskView : UIView

/// 点击 maskView 的回调
@property (nonatomic,   copy) void(^tapBlock)(void);

/**
 *  显示 maskView
 *
 *  @param view             :   要将 maskView 展示到哪个 view 上
 *  @param customSubview    :   maskView 上面要展示的自定义子视图
 *  @param layout           :   自定义子视图的布局, 之所以要以参数的形式写在这, 是为了保证用 Masonry 的时候也能很方便而且不会出错
 *  @param animation        :   自定义子视图出现时的动画, 传 nil 的话会默认一个 scale 的形变效果, 需要自定义动画的话就在这里自定义
 *
 *  @return 当前的 maskView, 方便调用 tapBlock
 */
+ (instancetype)showToView:(UIView *)view withCustomSubview:(UIView *)customSubview subviewLayout:(void(^)(void))layout subviewAnimation:(void(^)(void))animation;

/**
 *  隐藏 maskView
 *
 *  @param view     :   要隐藏哪个 view 上的 maskView
 *  @param block    :   自定义子视图出现消失时的动画, 传 nil 的话会默认一个 scale 的形变效果, 需要自定义动画的话就在这里自定义, 返回值为自定义动画时长
 */
+ (void)hideFromView:(UIView *)view withSubviewAnimation:(NSTimeInterval(^)(void))block;

@end

/*=================================================================================================

举例 : 
 
UIView *someAlertView = [[UIView alloc] init];
someAlertView.backgroundColor = [UIColor magentaColor];

ProjectMaskView *maskView = [ProjectMaskView showToView:Key_Window withCustomSubview:someAlertView subviewLayout:^{
    
    [someAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(Key_Window.mas_bottom);
        make.right.equalTo(Key_Window).offset(-kFittedWidth(80));
        make.width.mas_equalTo(kFittedWidth(50));
        make.height.mas_equalTo(kFittedHeight(180));
    }];
    
    // 添加约束后, 约束不会立马转换为 frame, 而这句话的作用就可以将约束立马转化为 frame, 因此如果不写这句话就去走 mas_updateConstraints 更新约束实现动画效果是有问题的
    [someAlertView.superview layoutIfNeeded];
} subviewAnimation:^{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [someAlertView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(Key_Window.mas_bottom).offset(-(kFittedHeight(180)));
        }];
        [someAlertView.superview layoutIfNeeded];
    }];
}];

maskView.tapBlock = ^{
    
    [ProjectMaskView hideFromView:Key_Window withSubviewAnimation:^NSTimeInterval{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [someAlertView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(Key_Window.mas_bottom);
            }];
            [someAlertView.superview layoutIfNeeded];
        }];
        
        return 0.5;
    }];
};
====================================================================================================*/



