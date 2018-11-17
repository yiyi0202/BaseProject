//
//  ProjectTabBar.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTabBar : UITabBar

@property (nonatomic, assign) CGSize centerButtonSize;
@property (nonatomic, assign) CGFloat centerButtonOffset;
@property (nonatomic,   copy) NSString *centerButtonImageName;
@property (nonatomic,   copy) void(^centerButtonBlock)(UIButton *centerButton);

@end
