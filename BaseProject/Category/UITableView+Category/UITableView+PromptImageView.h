//
//  UITableView+PromptImageView.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UITableView (YY_PromptImage)

/// 提示图的名字
@property (nonatomic, copy) NSString *yy_promptImageName;
/// 点击提示图的回调
@property (nonatomic, copy) void(^yy_didTapPromptImage)(void);

/// 不使用该分类里的这套判定规则
@property (nonatomic, assign) BOOL yy_dontUseThisCategory;

@end
