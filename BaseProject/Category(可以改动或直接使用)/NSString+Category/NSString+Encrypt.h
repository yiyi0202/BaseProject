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

- (NSString *)yy_md5Encode;
- (NSString *)yy_sha1Encode;
- (NSString *)yy_md5_sha1;

@end
