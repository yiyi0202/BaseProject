//
//  ProjectRefreshHeader.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "MJRefreshHeader.h"

typedef NS_ENUM(NSInteger, ProjectRefreshHeaderStyle) {
    
    ProjectRefreshHeaderStyle_Arrow_StateLabel_TimeLabel,
    ProjectRefreshHeaderStyle_Arrow_StateLabel,
    ProjectRefreshHeaderStyle_Arrow,
    
    ProjectRefreshHeaderStyle_Gif_StateLabel_TimeLabel,
    ProjectRefreshHeaderStyle_Gif_StateLabel,
    ProjectRefreshHeaderStyle_Gif
};

@interface ProjectRefreshHeader : MJRefreshHeader

/// 普通或 gif header 的样式
@property (assign, nonatomic) ProjectRefreshHeaderStyle style;


/**
 *  创建一个普通的 header
 */
- (id)initNormalHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  创建一个动图的 header
 */
- (id)initGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
