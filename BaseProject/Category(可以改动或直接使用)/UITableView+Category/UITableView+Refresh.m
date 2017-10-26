//
//  UITableView+Refresh.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UITableView+Refresh.h"
#import <objc/runtime.h>

@implementation UITableView (Refresh)

#pragma mark - RefreshPage

- (void)setRefreshPage:(NSInteger)refreshPage {
    
    objc_setAssociatedObject(self, @"refreshPage", @(refreshPage), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)refreshPage {
    
    return [objc_getAssociatedObject(self, @"refreshPage") integerValue];
}

- (void)initializeRefreshPage {
    
    self.refreshPage = 1;
}

- (void)changeRefreshPage {
    
    self.refreshPage ++;
}


#pragma mark - RefreshHeader

- (void)setRefreshingHeaderTarget:(id)refreshingHeaderTarget {
    
    objc_setAssociatedObject(self, @"refreshingHeaderTarget", refreshingHeaderTarget, OBJC_ASSOCIATION_RETAIN);
}

- (void)setRefreshingHeaderAction:(NSString *)refreshingHeaderAction {
    
    objc_setAssociatedObject(self, @"refreshingHeaderAction", refreshingHeaderAction, OBJC_ASSOCIATION_RETAIN);
}

- (id)refreshingHeaderTarget {
    
    return objc_getAssociatedObject(self, @"refreshingHeaderTarget");
}

- (NSString *)refreshingHeaderAction {
    
    return objc_getAssociatedObject(self, @"refreshingHeaderAction");
}

- (void)yy_addRefreshHeaderWithStyle:(ProjectRefreshHeaderStyle)style refreshingTarget:(id)target refreshingAction:(SEL)action {
    
    // 初始化 refreshPage
    [self initializeRefreshPage];
    
    // 创建 refreshHeader
    ProjectRefreshHeader *refreshHeader = nil;
    switch (style) {
        case ProjectRefreshHeaderStyle_Arrow_StateLabel_TimeLabel:
        case ProjectRefreshHeaderStyle_Arrow_StateLabel:
        case ProjectRefreshHeaderStyle_Arrow:
        {
            refreshHeader = [[ProjectRefreshHeader alloc] initNormalHeaderWithRefreshingTarget:self refreshingAction:@selector(yy_refreshHeader)];
            self.refreshingHeaderTarget = target;
            self.refreshingHeaderAction = NSStringFromSelector(action);
            refreshHeader.style = style;
        }
            break;
            
        case ProjectRefreshHeaderStyle_Gif_StateLabel_TimeLabel:
        case ProjectRefreshHeaderStyle_Gif_StateLabel:
        case ProjectRefreshHeaderStyle_Gif:
        {
            refreshHeader = [[ProjectRefreshHeader alloc] initGifHeaderWithRefreshingTarget:self refreshingAction:@selector(yy_refreshHeader)];
            self.refreshingHeaderTarget = target;
            self.refreshingHeaderAction = NSStringFromSelector(action);
            refreshHeader.style = style;
        }
            break;
    }
    
    self.mj_header = refreshHeader;
}

- (void)yy_beginRefreshingHeader {
    
    [self.mj_header beginRefreshing];
}

- (void)yy_endRefreshingHeader {
    
    [self.mj_header endRefreshing];
}

- (void)yy_refreshHeader {
    
    [self initializeRefreshPage];// 置位 refreshPage
    
    if (self.refreshingHeaderTarget != nil && self.refreshingHeaderAction != nil) {
        
        // 如果崩在这里, 可查看外部是否实现了刷新 header 的方法
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.refreshingHeaderTarget performSelector:NSSelectorFromString(self.refreshingHeaderAction)];
#pragma clang diagnostic pop
    }
}


#pragma mark - RefreshFooter

- (void)setRefreshingFooterTarget:(id)refreshingFooterTarget {
    
    objc_setAssociatedObject(self, @"refreshingFooterTarget", refreshingFooterTarget, OBJC_ASSOCIATION_RETAIN);
}

- (void)setRefreshingFooterAction:(NSString *)refreshingFooterAction {
    
    objc_setAssociatedObject(self, @"refreshingFooterAction", refreshingFooterAction, OBJC_ASSOCIATION_RETAIN);
}

- (id)refreshingFooterTarget {
    
    return objc_getAssociatedObject(self, @"refreshingFooterTarget");
}

- (NSString *)refreshingFooterAction {
    
    return objc_getAssociatedObject(self, @"refreshingFooterAction");
}

- (void)yy_addRefreshFooterWithStyle:(ProjectRefreshFooterStyle)style refreshingTarget:(id)target refreshingAction:(SEL)action {
    
    // 初始化 refreshPage
    [self initializeRefreshPage];
    
    // 创建 footer
    ProjectRefreshFooter *footer = nil;
    switch (style) {
        case ProjectRefreshFooterStyleStyle_Arrow_StateLabel:
        {
            footer = [[ProjectRefreshFooter alloc] initNormalFooterWithRefreshingTarget:self refreshingAction:@selector(yy_refreshFooter)];
            self.refreshingFooterTarget = target;
            self.refreshingFooterAction = NSStringFromSelector(action);
        }
            break;
            
        case ProjectRefreshFooterStyleStyle_Gif_StateLabel:
        {
            footer = [[ProjectRefreshFooter alloc] initGifFooterWithRefreshingTarget:self refreshingAction:@selector(yy_refreshFooter)];
            self.refreshingFooterTarget = target;
            self.refreshingFooterAction = NSStringFromSelector(action);
        }
            break;
    }
    
    self.mj_footer = footer;
}

- (void)yy_beginRefreshingFooter {
    
    [self.mj_footer beginRefreshing];
}

- (void)yy_endRefreshingFooter {
    
    [self.mj_footer endRefreshing];
}

- (void)yy_endRefreshingFooterWithNoMoreData {
    
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)yy_refreshFooter {
    
    [self changeRefreshPage];// 刷一次 refreshPage 就加 1
    
    if (self.refreshingFooterTarget != nil && self.refreshingFooterAction != nil) {
        
        // 如果崩在这里, 可查看外部是否实现了刷新 header 的方法
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.refreshingFooterTarget performSelector:NSSelectorFromString(self.refreshingFooterAction)];
#pragma clang diagnostic pop
    }
}

@end
