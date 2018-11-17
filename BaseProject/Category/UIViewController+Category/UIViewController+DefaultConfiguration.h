//
//  UIViewController+DefaultConfiguration.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

//======================================================//
// 该分类的作用：在全局上为项目里所有的Controller做一些统一的配置 //
//======================================================//
@interface UIViewController (DefaultConfiguration)

@end


//=================================//
// 该分类的作用：主要负责导航栏的一些配置 //
//=================================//
@interface UIViewController (NavigationBar)

/// 当前viewController导航栏的透明度（0~1.0），可以用来设置导航栏的渐变效果或者导航栏的显隐，强烈推荐该属性的设置写在-viewDidAppear:方法里
// 这个属性的默认是1，即每个界面在创建的时候默认都是不透明导航栏的，所以我们只需要处理那些导航栏需要的透明的viewController就可以了，这样的界面一般不会很多，所以强烈推荐该属性的设置写在-viewDidAppear:里面，因为只要这样才能保证UINavigationBar在设置yy_setAlpha的时候新界面的navigationBar确实已经被添加到navigationBar的itemStack里面了，要是在-viewWillAppear:里设置的话，新界面还没有出现，所以新界面的navigationBar还没被添加到navigationBar的itemStack里，你其实设置的还是push之前的那个界面的导航栏，切记。
// 此外，写在-viewDidAppear:会出现点击返回按钮返回是有点效果不完美的情况，这里通过在点击返回按钮的时候模拟侧滑返回的操作解决了。
@property (assign, nonatomic) CGFloat navigationBarAlpha;

@end


//==============================================//
// 该分类的作用：主要负责导航栏BarButtonItem的一些配置 //
//==============================================//
@interface UIViewController (NavigationBarButtonItem)

/**
 *  为什么要写这些方法？
 *
 *  （1）因为我们为项目添加了统一的返回按钮，并且他们都指向了leftBarButtonItemAction:这个方法，默认的实现就是pop回去，这个对于项目来说是非常必要的，可以省去为每个push出来的界面都分别写返回按钮和实现返回方法，可以省去不少劲
 *  （2）基于（1）中定义leftBarButtonItemAction:是必须的，那么当我们遇到返回按钮的事件不能满足我们的需求时，我们就需要重写leftBarButtonItemAction:这个方法的实现，那么你在外界直接重写leftBarButtonItemAction:即可，当调用这个方法时是优先在子类内部找方法的实现的，如果找到了就不会再找分类里面方法的实现了
 *  （3）但是如果有的界面我们需要自定义返回按钮，那么如果使用系统的方法，很可能造成不同的开发者给返回的这个方法起的名字不一样，即不都是leftBarButtonItemAction:，如果这种情况频繁出现会造成项目里代码乱七八糟，维护起来很成问题，因此此处才提供了下面几个方法，最主要的目的是为了保证左右item在生成的同时指向相同的方法，即leftBarButtonItemAction:和rightBarButtonItemAction:，这样会很方便我们维护
 *  （4）再者，下面几个方法之所以返回了一个UIBarButtonItem，是为了避免有的时候需要设置leftBarButtonItems的情况，如果我们不返回而是直接在方法里实现添加一个item，那将无法满足多个item的需求。因此这里只是返回一个barButtonItem，由外界自己设置，但是可以保证同侧的item都指向同一个方法，使用的时候在外面判断一下就可以了
 */
- (UIBarButtonItem *)generateLeftBarButtonItemWithTitle:(NSString *)title;
- (UIBarButtonItem *)generateLeftBarButtonItemWithImage:(UIImage *)image;
- (UIBarButtonItem *)generateLeftBarButtonItemWithCustomView:(UIView *)customView;
- (UIBarButtonItem *)generateRightBarButtonItemWithTitle:(NSString *)title;
- (UIBarButtonItem *)generateRightBarButtonItemWithImage:(UIImage *)image;
- (UIBarButtonItem *)generateRightBarButtonItemWithCustomView:(UIView *)customView;

/**
 *  leftBarButtonItem事件
 *
 *  （1）默认实现为pop回上一层
 *  （2）如需添加自定义操作，则重写该方法完成自定义操作，并在自定义操作后面调用[super leftBarButtonItemAction:]
 *  （3）如完全是自定义操作(即不pop回上一层)，则重写该方法即可
 *  （4）如果是多barButtonItem的情况，需要重写该方法，在方法里做判断做不同的操作
 */
- (void)leftBarButtonItemAction:(UIBarButtonItem *)leftBarButtonItem;

/**
 *  rightBarButtonItem事件
 *
 *  默认实现为空，需要自定义实现
 */
- (void)rightBarButtonItemAction:(UIBarButtonItem *)rightBarButtonItem;

@end


//======================================//
// 该分类的作用：主要负责导航栏控制器的一些配置 //
//======================================//
@interface UIViewController (NavigationController)

/// 是否开启侧滑返回
@property (assign, nonatomic) BOOL enableSlideBack;

@end


//=================================//
// 该分类的作用：主要负责状态栏的一些配置 //
//=================================//
@interface UIViewController (StatusBar)

@end
