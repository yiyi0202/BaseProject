//
//  UINavigationBar+OverLayer.h
//  BaseProject
//
//  Created by zhangshuo on 2017/10/17.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

//==============================================================================//
//该分类的作用是 :
// (1)我们在导航栏最上面盖了一层 overLayer 来控制导航栏的颜色, 为的是解决把 navigationBar.translucent 设置为 YES 之后造成的色差问题, 但是我们可以完全可以忘记我们为导航栏上盖了一层 overLayer, 还是像平常一样通过系统原有的方法来设置导航栏的颜色就可以了
// (2)此外, 因为导航栏的隐藏或者渐变操作通过 hide 或者 alpha 的办法实现起来都不是特别简洁, 所以我们也通过这个分类实现了项目中各种导航栏的隐藏和渐变的效果. 按理来说要改变导航栏的透明度应该使用该分类中的方法才对, 因为改变导航栏透明度本来就是属于导航栏应该提供的 API, 但是因为侧滑返回导航栏渐变的效果是必须获取侧滑返回前后两个 viewController 的导航栏的透明度的, 所以我们必须为viewController 扩展一个属性 navigationBarAlpha, 而且必须设置这个属性的值(当然我们会默认为 1, 其本质其实也是转化为了对该分类中方法的调用来设置 overLayer), 所以为了统一性, 我们就隐藏了导航栏设置透明度的 API, 而是统一使用 viewController 的 navigationBarAlpha 来设置导航栏的透明度
// (3)因此, 我们完全可以忘记这个分类的存在, 代码该怎么写怎么写就行了
//==============================================================================//

#import <UIKit/UIKit.h>

@interface UINavigationBar (OverLayer)

@end
