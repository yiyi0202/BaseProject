//
//  UICollectionView+PromptImageView.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UICollectionView+PromptImageView.h"
#import <objc/runtime.h>

@implementation UICollectionView (PromptImageView)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) swizzledSelector:@selector(yy_reloadData)];
    });
}

- (void)yy_reloadData {
    
    [self yy_reloadData];
    
    if (self.hasInvokedReload) {
        
        [self handlePromptImageView];
    }else {
        
        self.hasInvokedReload = YES;
    }
}

- (BOOL)dataSourceIsEmpty {

    // 手写输入法
    if ([self isKindOfClass:NSClassFromString(@"UIKBCandidateCollectionView")]) {
        
        return NO;
    }

    NSInteger sections = 1;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        
        sections = [self numberOfSections];
        
        if (sections == 0) {
            
            return YES;
        }else {
            
            for (int i = 0; i < sections; i ++) {
                
                NSInteger rows = [self numberOfItemsInSection:i];
                
                if (rows != 0) {
                    
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

- (void)handlePromptImageView {
    
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

- (void)setPromptImageView:(UIImageView *)promptImageView {
    
    objc_setAssociatedObject(self, @"promptImageView", promptImageView, OBJC_ASSOCIATION_RETAIN);
}

- (UIImageView *)promptImageView {
    
    return objc_getAssociatedObject(self, @"promptImageView");
}

- (void)tapPromptImageView:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (self.tapPromptImageViewBlock) {
        
        self.tapPromptImageViewBlock();
    }
}

- (void)setTapPromptImageViewBlock:(void (^)(void))tapPromptImageViewBlock {
    
    objc_setAssociatedObject(self, @"tapPromptImageViewBlock", tapPromptImageViewBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))tapPromptImageViewBlock {
    
    return objc_getAssociatedObject(self, @"tapPromptImageViewBlock");
}

- (void)setHasInvokedReload:(BOOL)hasInvokedReload {
    
    objc_setAssociatedObject(self, @"hasInvokedReload", @(hasInvokedReload), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)hasInvokedReload {
    
    return [objc_getAssociatedObject(self, @"hasInvokedReload") boolValue];
}

@end
