//
//  UITableView+PromptImageView.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UITableView+PromptImageView.h"
#import <objc/runtime.h>

@implementation UITableView (PromptImageView)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) swizzledSelector:@selector(yy_reloadData)];
    });
}

- (void)yy_reloadData {
    
    [self yy_reloadData];
    
    if (self.hasInvokedReload) {// 如果已经调用过 reloadData 了, 说明不是 tableView 被创建完第一次出现, 那就可以处理提示图的显隐
        
        [self handlePromptImageView];
    }else {// tableView 被创建完第一次出现, 我们不做提示图显隐的处理, 而仅仅是声明后面调用的 reloadData 已经不是 tableView 被创建完第一次出现调用的了
        
        self.hasInvokedReload = YES;
    }
}

// 提示图显隐的处理
- (void)handlePromptImageView {
    
    // 因为 tableView 被创建完第一次出现的时候会自动调用一下 reloadData, 但是我们希望的是刚出现的时候是一个白板 + HUD, 请求数据为空的时候才显示 promptImageView, 所以此处才做了这层判断
    if (self.hasInvokedReload) {
        
        if (self.promptImageView == nil) {
            
            self.promptImageView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
            self.promptImageView.contentMode = UIViewContentModeCenter;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPromptImageView:)];
            [self.promptImageView addGestureRecognizer:tapGestureRecognizer];
            self.promptImageView.userInteractionEnabled = YES;
        }
        
        if ([self dataSourceIsEmpty]) {
            
            self.promptImageView.image = [UIImage imageNamed:@"promptImageView"];
        }else {
            
            self.promptImageView.image = nil;
        }
        
        self.backgroundView = self.promptImageView;
    }
}

// 判断 tableView 的数据源是否为空
- (BOOL)dataSourceIsEmpty {
    
    // 键盘切换输入法的那个tableView
    if ([self isKindOfClass:NSClassFromString(@"UIInputSwitcherTableView")]) {
        
        return NO;
    }
    
    // pickerView
    if ([self isKindOfClass:NSClassFromString(@"UIPickerTableView")]) {
        
        return NO;
    }
    
    // tableView
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        
        // 获取分区数(如果外界没有实现 numberOfSectionsInTableView:, 那么分区数默认 1 个)
        NSInteger sections = 1;
        
        sections = [self numberOfSections];
        
        // 如果分区数为 0, 说明数据为空
        if (sections == 0) {
            
            return YES;
        }else {
            
            // 获取分区的行数
            for (int i = 0; i < sections; i ++) {
                
                // 此处 i 即为当前分区
                NSInteger rows = [self numberOfRowsInSection:i];
                
                // 如果其中任意一个分区的数据不为空, 那就返回 NO
                if (rows != 0) {
                    
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

// 为了避免 reloadData 时反复创建 promptImageView, 将其添加为属性
- (void)setPromptImageView:(UIImageView *)promptImageView {
    
    objc_setAssociatedObject(self, @"promptImageView", promptImageView, OBJC_ASSOCIATION_RETAIN);
}

- (UIImageView *)promptImageView {
    
    return objc_getAssociatedObject(self, @"promptImageView");
}

// 点击 promptImageView, 暴露一个 block 出去, 供自定义操作
- (void)tapPromptImageView:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (self.tapPromptImageViewBlock) {
        
        self.tapPromptImageViewBlock();
    }
}

// 添加 tapPromptImageViewBlock 属性
- (void)setTapPromptImageViewBlock:(void (^)(void))tapPromptImageViewBlock {
    
    objc_setAssociatedObject(self, @"tapPromptImageViewBlock", tapPromptImageViewBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))tapPromptImageViewBlock {
    
    return objc_getAssociatedObject(self, @"tapPromptImageViewBlock");
}

// 添加 isFirstReload 属性
- (void)setHasInvokedReload:(BOOL)hasInvokedReload {
    
    objc_setAssociatedObject(self, @"hasInvokedReload", @(hasInvokedReload), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)hasInvokedReload {
    
    return [objc_getAssociatedObject(self, @"hasInvokedReload") boolValue];
}

@end
