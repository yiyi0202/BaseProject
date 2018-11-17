//
//  ProjectRefreshFooter.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "MJRefreshFooter.h"

typedef NS_ENUM(NSInteger, ProjectRefreshFooterStyle) {
    
    ProjectRefreshFooterStyleStyle_Arrow_StateLabel,
    ProjectRefreshFooterStyleStyle_Gif_StateLabel
};

@interface ProjectRefreshFooter : MJRefreshFooter

/// 普通或 gif footer 的样式
@property (assign, nonatomic) ProjectRefreshFooterStyle style;


/**
 *  创建一个普通的 footer
 */
- (id)initNormalFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  创建一个动图的 footer
 */
- (id)initGifFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
