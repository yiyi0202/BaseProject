//
//  UITableView+Adaptation.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/13.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UITableView+Adaptation.h"

@implementation UITableView (Adaptation)

- (void)yy_AdaptiOS11 {
    
    // 不要让系统自动为我们调整 tableView 的大小, 我们自己控制
    if (@available(iOS 11.0, *)) {
        
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        // Fallback on earlier versions
    }
    
    // 避免不实现 (-tableView: viewForFooterInSection:) 和 (-tableView: viewForHeaderInSection:) 方法导致 (_tableView: heightForHeaderInSection:) 和 (-tableView: heightForFooterInSection:) 不被调用
    self.estimatedRowHeight = 44;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
}

@end
