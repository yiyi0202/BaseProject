//
//  UITableView+PromptImageView.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (PromptImageView)

/// 点击提示图的回调
@property (nonatomic, copy) void(^tapPromptImageViewBlock)(void);

@end
