//
//  UIButton+ImageAndTitleLayoutStyle.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "UIButton+ImageAndTitleLayoutStyle.h"

@implementation UIButton (ImageAndTitleLayoutStyle)

- (void)layoutImageAndTitle:(ImageAndTitleLayoutStyle)style
            imageTitleSpace:(CGFloat)space {
    
    // 当文字显示不下时, 设置为省略后面的文本
    self.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height;
    
    CGFloat imageOffsetY = imageHeight / 2.0 + space / 2.0;// image 中心竖向偏移量
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2.0 - imageWidth / 2.0;// image 中心横向偏移量
    CGFloat labelOffsetY = labelHeight / 2.0 + space / 2.0;// label 中心竖向偏移量
    CGFloat labelOffsetX = (labelWidth / 2.0 + imageWidth) - labelWidth / 2.0 - imageWidth / 2.0;// label 中心横向偏移量
    
    CGFloat currentButtonWidth = MAX(imageWidth, labelWidth);
    CGFloat changeWidth = imageWidth + labelWidth - currentButtonWidth;
    CGFloat currentButtonHeight = MAX(imageHeight, labelHeight);
    CGFloat changeHeight = imageHeight + labelHeight - currentButtonHeight + space;
    
    switch (style) {
        case ImageAndTitleLayoutStyleImageOnLabel:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changeWidth / 2.0, changeHeight - imageOffsetY, -(changeWidth / 2.0));
        }
            break;
        case ImageAndTitleLayoutStyleImageLeftToLabel:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -(space / 2.0), 0, space / 2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, -(space / 2.0));
            self.contentEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, space / 2.0);
        }
            break;
        case ImageAndTitleLayoutStyleImageUnderLabel:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changeHeight - imageOffsetY, -(changeWidth / 2.0), imageOffsetY, -(changeWidth / 2.0));
        }
            break;
        case ImageAndTitleLayoutStyleImageRightToLabel:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space / 2.0, 0, -(labelWidth + space / 2.0));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + space / 2.0), 0, imageWidth + space / 2.0);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, space / 2.0);
        }
            break;
        default:
            break;
    }
}

@end
