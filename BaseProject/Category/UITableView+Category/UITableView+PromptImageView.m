//
//  UITableView+PromptImageView.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UITableView+PromptImageView.h"
#import <objc/runtime.h>

@interface UITableView ()

// 已经调用过reloadData方法了
@property (nonatomic, assign) BOOL yy_hasInvokedReloadData;

// 提示图
@property (nonatomic, strong) UIImageView *yy_promptImageView;

@end

@implementation UITableView (PromptImageView)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) swizzledSelector:@selector(yy_reloadData)];
    });
}

- (void)yy_reloadData {
    
    if ([[self class] isEqual:[UITableView class]] && !self.yy_dontUseThisCategory) {// 防止替换掉UITableView类簇里子类方法的实现
        
        [self yy_reloadData];
        
        if (self.yy_hasInvokedReloadData) {// 而是只在请求数据完成后，调用reloadData刷新界面时才处理提示图的显隐
            
            [self yy_handlePromptImage];
        } else {// tableView第一次加载的时候会自动调用一下reloadData方法，这一次调用我们不处理提示图的显隐
            
            self.yy_hasInvokedReloadData = YES;
        }
    } else {
        
        [self yy_reloadData];
    }
}


#pragma mark - private method

// 提示图的显隐
- (void)yy_handlePromptImage {
    
    if ([self yy_dataIsEmpty]) {
        
        [self yy_showPromptImage];
    }else {
        
        [self yy_hidePromptImage];
    }
}

// 判断请求到的数据是否为空
- (BOOL)yy_dataIsEmpty {
    
    // 获取分区数
    NSInteger sections = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {// 如果外界实现了该方法，则读取外界提供的分区数
        
        sections = [self numberOfSections];
    } else {// 如果外界没实现该方法，系统不是会自动给我们返回一个分区嘛
        
        sections = 1;
    }
    
    if (sections == 0) {// 分区数为0，说明数据为空
        
        return YES;
    }
    
    
    // 分区数不为0，则需要判断每个分区下的行数
    for (int i = 0; i < sections; i ++) {
        
        // 获取各个分区的行数
        NSInteger rows = [self numberOfRowsInSection:i];
        
        if (rows != 0) {// 但凡有一个分区下的行数不为0，说明数据不为空
            
            return NO;
        }
    }
    
    
    // 如果所有分区下的行数都为0，才说明数据为空
    return YES;
}

// 显示提示图
- (void)yy_showPromptImage {
    
    if (self.yy_promptImageView == nil) {
        
        self.yy_promptImageView = [[UIImageView alloc] initWithFrame:self.backgroundView.bounds];
        self.yy_promptImageView.backgroundColor = [UIColor clearColor];
        self.yy_promptImageView.contentMode = UIViewContentModeCenter;
        self.yy_promptImageView.userInteractionEnabled = YES;
        
        if (self.yy_promptImageName.length == 0) {
            
            self.yy_promptImageName = @"BaseProject_NoDataPromptImage";
        }
        self.yy_promptImageView.image = [UIImage imageNamed:self.yy_promptImageName];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yy_didTapPromptImage:)];
        [self.yy_promptImageView addGestureRecognizer:tapGestureRecognizer];
    }
    
    self.backgroundView = self.yy_promptImageView;
}

// 隐藏提示图
- (void)yy_hidePromptImage {
    
    self.backgroundView = nil;
}

// 点击提示图的回调
- (void)yy_didTapPromptImage:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (self.yy_didTapPromptImage) {
        
        self.yy_didTapPromptImage();
    }
}


#pragma mark - setter, getter

- (void)setYy_hasInvokedReloadData:(BOOL)yy_hasInvokedReloadData {
    
    objc_setAssociatedObject(self, @"yy_hasInvokedReloadData", @(yy_hasInvokedReloadData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yy_hasInvokedReloadData {
    
    return [objc_getAssociatedObject(self, @"yy_hasInvokedReloadData") boolValue];
}

- (void)setYy_promptImageView:(UIImageView *)yy_promptImageView {
    
    objc_setAssociatedObject(self, @"yy_promptImageView", yy_promptImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)yy_promptImageView {
    
    return objc_getAssociatedObject(self, @"yy_promptImageView");
}

- (void)setYy_promptImageName:(NSString *)yy_promptImageName {
    
    objc_setAssociatedObject(self, @"yy_promptImageName", yy_promptImageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)yy_promptImageName {
    
    return objc_getAssociatedObject(self, @"yy_promptImageName");
}

- (void)setYy_didTapPromptImage:(void (^)(void))yy_didTapPromptImage {
    
    objc_setAssociatedObject(self, @"yy_didTapPromptImage", yy_didTapPromptImage, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))yy_didTapPromptImage {
    
    return objc_getAssociatedObject(self, @"yy_didTapPromptImage");
}

- (void)setYy_dontUseThisCategory:(BOOL)yy_dontUseThisCategory {
    
    objc_setAssociatedObject(self, @"yy_dontUseThisCategory", @(yy_dontUseThisCategory), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yy_dontUseThisCategory {
    
    return [objc_getAssociatedObject(self, @"yy_dontUseThisCategory") boolValue];
}

@end
