//
//  ProjectTabBarController.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectTabBarController.h"

@interface ProjectTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) ProjectTabBar *projectTabBar;
@property (nonatomic, assign) CGSize centerButtonSize;
@property (nonatomic, assign) CGFloat centerButtonOffset;
@property (nonatomic,   copy) NSString *centerButtonImageName;
@property (nonatomic,   weak) id<ProjectTabBarControllerDelegate> projectDelegate;

@property (nonatomic, assign) BOOL tabBarItemAnimated;

@end

@implementation ProjectTabBarController

#pragma mark - life cycle

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                 titles:(NSArray<NSString *> *)titles
                             imageNames:(NSArray<NSString *> *)imageNames
                     selectedImageNames:(NSArray<NSString *> *)selectedImageNames
                               animated:(BOOL)flag {
    
    self = [super init];
    if (self != nil) {
        
        _tabBarItemAnimated = flag;
        
        [self defaultTabBarConfiguration];
        [self addChildViewControllers:viewControllers titles:titles imageNames:imageNames selectedImageNames:selectedImageNames];
    }
    
    return self;
}

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                                 titles:(NSArray<NSString *> *)titles
                             imageNames:(NSArray<NSString *> *)imageNames
                     selectedImageNames:(NSArray<NSString *> *)selectedImageNames
                               delegate:(id<ProjectTabBarControllerDelegate>)delegate
                       centerButtonSize:(CGSize)size
                     centerButtonOffset:(CGFloat)offset
                  centerButtonImageName:(NSString *)imageName
                               animated:(BOOL)flag {
    
    self = [super init];
    if (self != nil) {
        
        _projectDelegate = delegate;
        _centerButtonSize = size;
        _centerButtonOffset = offset;
        _centerButtonImageName = imageName;
        _tabBarItemAnimated = flag;
        
        [self customTabBarConfiguration];
        [self addChildViewControllers:viewControllers titles:titles imageNames:imageNames selectedImageNames:selectedImageNames];
    }
    
    return self;
}


#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (self.tabBarItemAnimated) {
    
        UIView *tempView = nil;
        if (self.projectTabBar == nil) {
            
            tempView = self.tabBar.subviews[self.selectedIndex + 1].subviews[0];
        }else {
            
            tempView = self.tabBar.subviews[self.selectedIndex + 2].subviews[0];// 因为多了自定义的 centerButton
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            tempView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                tempView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }
}


#pragma mark - private method

- (void)addChildViewControllers:(NSArray *)viewControllers
                         titles:(NSArray<NSString *> *)titles
                     imageNames:(NSArray<NSString *> *)imageNames
             selectedImageNames:(NSArray<NSString *> *)selectedImageNames {
    
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UINavigationController *childNC = [[UINavigationController alloc] initWithRootViewController:viewControllers[idx]];
        UIImage *originalImage = [[UIImage imageNamed:imageNames[idx]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        UIImage *originalSelectedimage = [[UIImage imageNamed:selectedImageNames[idx]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        childNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[idx] image:originalImage selectedImage:originalSelectedimage];
        
        if (titles.count == 0) {
            
            childNC.tabBarItem.imageInsets = UIEdgeInsetsMake((48 - originalImage.size.height) / 2.0 - 3, 0, -((48 - originalImage.size.height) / 2.0 - 3), 0);// tabBar 上的图片和文本默认居上 1pt, 所以内容的高度是 48, 然后 imageInsets 默认状态为 UIEdgeInsetsZero, 但是默认居上有 3pt
        }
        
        [self addChildViewController:childNC];
    }];
}


#pragma mark - TabBarConfiguration

- (void)defaultTabBarConfiguration {
    
    self.tabBar.translucent = YES;
    self.tabBar.barTintColor = Default_Tab_Bar_Tint_Color;
    self.tabBar.tintColor = Default_Tab_Bar_Selected_Item_Tint_Color;
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = Default_Tab_Bar_Unselected_Item_Tint_Color;
    } else {
        // Fallback on earlier versions
    }
    
    self.selectedIndex = 0;
    self.delegate = self;
}

- (void)customTabBarConfiguration {
    
    self.projectTabBar = [[ProjectTabBar alloc] init];
    self.projectTabBar.translucent = YES;
    self.projectTabBar.barTintColor = Default_Tab_Bar_Tint_Color;
    if (@available(iOS 10.0, *)) {
        self.projectTabBar.unselectedItemTintColor = Default_Tab_Bar_Unselected_Item_Tint_Color;
    } else {
        // Fallback on earlier versions
    }
    
    self.projectTabBar.centerButtonSize = self.centerButtonSize;
    self.projectTabBar.centerButtonOffset = self.centerButtonOffset;
    self.projectTabBar.centerButtonImageName = self.centerButtonImageName;
    
    __weak typeof(self) weakSelf = self;
    self.projectTabBar.centerButtonBlock = ^(UIButton *centerButton) {
        
        if ([weakSelf.projectDelegate respondsToSelector:@selector(tabBarController:didSelectCenterButton:)]) {
            
            [weakSelf.projectDelegate tabBarController:weakSelf didSelectCenterButton:centerButton];
        }
    };
    
    [self setValue:self.projectTabBar forKey:@"tabBar"];
    
    self.selectedIndex = 0;
    self.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
