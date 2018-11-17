//
//  NSString+Encrypt.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/25.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

/// base64, RSA, AES 待添加

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/**
 * MD5加密，返回32位十六进制小写密文
 *
 * @param string 原明文数据
 *
 * @return 经过MD5加密后的密文
 */
+ (NSString *)md5EncryptString_Lowercase_FromString:(NSString *)string;

/**
 * MD5加密，返回32位十六进制大写密文
 *
 * @param string 原明文数据
 *
 * @return 经过MD5加密后的密文
 */
+ (NSString *)md5EncryptString_Uppercase_FromString:(NSString *)string;


/**
 * SHA1加密，返回40位十六进制小写密文
 *
 * @param string 原明文数据
 *
 * @return 经过SHA1加密后的密文
 */
+ (NSString *)sha1EncryptString_Lowercase_FromString:(NSString *)string;

/**
 * SHA1加密，返回40位十六进制大写密文
 *
 * @param string 原明文数据
 *
 * @return 经过SHA1加密后的密文
 */
+ (NSString *)sha1EncryptString_Uppercase_FromString:(NSString *)string;

@end
