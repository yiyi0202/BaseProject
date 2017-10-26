//
//  NSString+Regex.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/25.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

- (BOOL)yy_isPhoneNumber;
- (BOOL)yy_isEmail;

// 此处设置密码由 6~16 个字母和数字组成
- (BOOL)yy_isPassword;
// 此处采用 6 位数字的短信验证码
- (BOOL)yy_isMessageVerificationCode;

- (BOOL)yy_isIDCard;
- (BOOL)yy_isChinese;
- (BOOL)yy_isBankCard;

- (BOOL)yy_isPostCode;

@end
