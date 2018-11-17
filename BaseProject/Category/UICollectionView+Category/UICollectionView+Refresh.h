//
//  UICollectionView+Refresh.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectRefreshHeader.h"
#import "ProjectRefreshFooter.h"

@interface UICollectionView (Refresh)

#pragma mark - RefreshPage

/// 刷新的页数, 默认值为 1
@property (assign, nonatomic) NSInteger refreshPage;


#pragma mark - RefreshHeader

/**
 *  给 tableView 添加一个 RefreshHeader
 *
 *  因为这里把刷新的 page 也作为了 tableView 的一个属性, 所以此处初始化方式采用 target-action 的方式, 可以直接将刷新操作指向 viewController 里请求数据的方法, 不必再写方法, 用 block 的话需要多一步不是很爽
 */
- (void)yy_addRefreshHeaderWithStyle:(ProjectRefreshHeaderStyle)style refreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  tableView 开始刷新 header
 */
- (void)yy_beginRefreshingHeader;

/**
 *  tableView 结束刷新 header
 */
- (void)yy_endRefreshingHeader;


#pragma mark - RefreshFooter

/**
 *  给 tableView 添加一个 RefreshFooter
 *
 *  因为这里把刷新的 page 也作为了 tableView 的一个属性, 所以此处初始化方式采用 target-action 的方式, 可以直接将刷新操作指向 viewController 里请求数据的方法, 不必再写方法, 用 block 的话需要多一步不是很爽
 */
- (void)yy_addRefreshFooterWithStyle:(ProjectRefreshFooterStyle)style refreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  tableView 开始刷新 footer
 */
- (void)yy_beginRefreshingFooter;

/**
 *  tableView 结束刷新 footer
 */
- (void)yy_endRefreshingFooter;

/**
 *  tableView 结束刷新 footer, 已加载全部数据
 */
- (void)yy_endRefreshingFooterWithNoMoreData;

@end
