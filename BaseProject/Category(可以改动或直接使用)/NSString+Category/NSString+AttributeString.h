//
//  NSString+AttributeString.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/24.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributeString)

/**
 *  改变文本中某段文本的颜色
 *
 *  @param  textArray   要改变的文本的数组
 *  @param  textColor   要改变成的字体颜色
 *
 *  @return 转换后的属性字符串
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor;

/**
 *  改变文本中某段文本的大小
 *
 *  @param  textArray   要改变的文本的数组
 *  @param  fontSize    要改变成的字体大小
 *
 *  @return 转换后的属性字符串
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray fontSize:(CGFloat)fontSize;

/**
 *  给文本中某段文本添加删除线
 *
 *  @param  textArray       需要改变的文本数组
 *  @param  deletelineColor 删除线的颜色
 *
 *  @return 转换后的富文本
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray deletelineColor:(UIColor *)deletelineColor;

/**
 *  改变文本中某段文本的颜色, 大小
 *
 *  @param  textArray   要改变的文本的数组
 *  @param  textColor   要改变成的字体颜色
 *  @param  fontSize    要改变成的字体大小
 *
 *  @return 转换后的属性字符串
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

/**
 *  改变文本中某段文本的颜色, 并添加删除线
 *
 *  @param  textArray       要改变的文本的数组
 *  @param  textColor       要改变成的字体颜色
 *  @param  deletelineColor 删除线的颜色
 *
 *  @return 转换后的属性字符串
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor deletelineColor:(UIColor *)deletelineColor;

/**
 *  改变文本中某段文本的大小, 并添加删除线
 *
 *  @param  textArray       要改变的文本的数组
 *  @param  fontSize        要改变成的字体大小
 *  @param  deletelineColor 删除线的颜色
 *
 *  @return 转换后的属性字符串
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray fontSize:(CGFloat)fontSize deletelineColor:(UIColor *)deletelineColor;

/**
 *  改变文本中某段文本的颜色, 大小, 并添加删除线
 *
 *  @param  textArray       要改变的文本的数组
 *  @param  textColor       要改变成的字体颜色
 *  @param  fontSize        要改变成的字体大小
 *  @param  deletelineColor 删除线的颜色
 *
 *  @return 转换后的属性字符串
 */
- (NSMutableAttributedString *)yy_changeToAttributedStringWithTextArray:(NSArray *)textArray textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize deletelineColor:(UIColor *)deletelineColor;

@end
