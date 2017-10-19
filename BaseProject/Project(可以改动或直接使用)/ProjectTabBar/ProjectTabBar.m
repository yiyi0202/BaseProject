//
//  ProjectTabBar.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectTabBar.h"

@interface ProjectTabBar ()

@property (nonatomic, strong) UIButton *centerButton;

@end

@implementation ProjectTabBar

#pragma mark - life cycle

- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        
        [self layoutUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        [self layoutUI];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // centerButton 的位置和大小
    if (CGSizeEqualToSize(self.centerButtonSize, CGSizeZero)) {
        
        self.centerButtonSize = CGSizeMake(48, 48);
    }
    
    self.centerButtonOffset += (24 - self.centerButtonSize.height / 2.0);
    
    
    self.centerButton.frame = CGRectMake(self.center.x - self.centerButtonSize.width / 2.0, self.centerButtonOffset, self.centerButtonSize.width, self.centerButtonSize.height);
    
    // 调整 tabBar 周围子控件的位置和大小
    int buttonIndex = 0;
    for (UIView *tempButton in self.subviews) {
        
        if ([tempButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            CGRect tempRect = tempButton.frame;
            tempRect.size.width = self.frame.size.width / (self.subviews.count - 1);// 因为多一个 _UIBarBackground 的子视图
            tempRect.origin.x = tempRect.size.width * buttonIndex;
            tempButton.frame = tempRect;
            
            buttonIndex ++;
            
            // 为 centerButton.frame 留出位置
            if (buttonIndex == (self.subviews.count - 2) / 2) {
                
                buttonIndex ++;
            }
        }
    }
}


#pragma mark - layoutUI

- (void)layoutUI {
    
    [self addSubview:self.centerButton];
}


#pragma mark - private method

- (void)centerButtonAction:(UIButton *)button {
    
    if (self.centerButtonBlock) {
        
        self.centerButtonBlock(self.centerButton);
    }
}

// 重写方法 : 目的是为了让超出 tabBar 的部分也响应点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 这一步必须写, 不写的话, 当栈底导航栏控制器 push 出新的控制器后, 即便是隐藏了 tabBar, 点击自定义按钮所在位置也会响应事件
    if (!self.isHidden) {
        
        // 转换点击点的坐标系
        CGPoint newPoint = [self convertPoint:point toView:self.centerButton];
        
        // 判断点击点是否在自定义 button 上
        if ([self.centerButton pointInside:newPoint withEvent:event]) {
            
            // 在的话, 由自定义 button 响应事件
            return self.centerButton;
        }else {
            
            // 否则, 由系统自动处理
            return [super hitTest:point withEvent:event];
        }
    }else {
        
        // 否则, 由系统自动处理
        return [super hitTest:point withEvent:event];
    }
}


#pragma mark - setter, getter

- (void)setCenterButtonImageName:(NSString *)centerButtonImageName {
    
    _centerButtonImageName = centerButtonImageName;
    [self.centerButton setBackgroundImage:[UIImage imageNamed:_centerButtonImageName] forState:(UIControlStateNormal)];
}

- (UIButton *)centerButton {
    
    if (_centerButton == nil) {
        
        _centerButton = [[UIButton alloc] init];
        _centerButton.backgroundColor = [UIColor clearColor];
        
        _centerButton.adjustsImageWhenHighlighted = NO;
        
        [_centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _centerButton;
}

@end
