//
//  UIButton+ImageAndTitleLayoutStyle.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageAndTitleLayoutStyle) {
    
    ImageAndTitleLayoutStyleImageOnLabel,
    ImageAndTitleLayoutStyleImageLeftToLabel,
    ImageAndTitleLayoutStyleImageUnderLabel,
    ImageAndTitleLayoutStyleImageRightToLabel
};

@interface UIButton (ImageAndTitleLayoutStyle)

/**
 *  重新布局 button 的 image 和 title
 *
 *  使用方法 : button 首次设置完图片和文本并添加完约束之后调用一下; button 更新了图片和文本的时候也需要调用一下
 */
- (void)layoutImageAndTitle:(ImageAndTitleLayoutStyle)style
            imageTitleSpace:(CGFloat)space;

@end
