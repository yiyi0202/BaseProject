//
//  NSString+Encrypt.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/25.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Encrypt)

- (NSString *)yy_md5Encode {
    
    // 码文数组(占 16 个字节)
    unsigned char resultArray[CC_MD5_DIGEST_LENGTH];
    // 编码
    CC_MD5(self.UTF8String, (CC_LONG)strlen(self.UTF8String), resultArray);
    // 码文
    NSMutableString *md5String = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [md5String appendFormat:@"%02X", resultArray[i]];// X 代表十六进制
    }
    
    return (NSString *)md5String;
}

@end
