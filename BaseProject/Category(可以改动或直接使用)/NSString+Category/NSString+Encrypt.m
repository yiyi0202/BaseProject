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
        
        [md5String appendFormat:@"%02x", resultArray[i]];// X 代表十六进制
    }
    
    return (NSString *)md5String;
}

- (NSString *)yy_sha1Encode {
    
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)yy_md5_sha1 {
    
    NSString * md5 = [self yy_md5Encode];
    NSString * sha1 = [self yy_sha1Encode];
    NSString * md5_sha1 = [NSString stringWithFormat:@"%@%@",sha1,md5];
    
    NSString * md5_sha1_1 =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",[[md5_sha1 substringWithRange:NSMakeRange(0, 9)] stringByAppendingString:@"s"], [[md5_sha1 substringWithRange:NSMakeRange(10, 9)] stringByAppendingString:@"h"], [[md5_sha1 substringWithRange:NSMakeRange(20, 9)] stringByAppendingString:@"l"], [[md5_sha1 substringWithRange:NSMakeRange(30, 9)] stringByAppendingString:@"s"], [[md5_sha1 substringWithRange:NSMakeRange(40, 9)] stringByAppendingString:@"u"], [[md5_sha1 substringWithRange:NSMakeRange(50, 9)] stringByAppendingString:@"n"], [[md5_sha1 substringWithRange:NSMakeRange(60, 9)] stringByAppendingString:@"y"], [md5_sha1 substringWithRange:NSMakeRange(70, 2)]];
    
    NSString * md5_sha1_2 =[NSString stringWithFormat:@"%@%@", [md5_sha1_1 substringWithRange:NSMakeRange(36, 36)], [md5_sha1_1 substringWithRange:NSMakeRange(0, 36)]];
    
    NSString * md5_sha1_3 =[NSString stringWithFormat:@"%@", [md5_sha1_2 substringWithRange:NSMakeRange(0, 70)]];
    
    
    NSString * md5_sha1_4 =[NSString stringWithFormat:@"%@%@%@%@%@",[[md5_sha1_3 substringWithRange:NSMakeRange(0, 14)] stringByAppendingString:@"j"], [[md5_sha1_3 substringWithRange:NSMakeRange(14, 14)] stringByAppendingString:@"x"], [[md5_sha1_3 substringWithRange:NSMakeRange(28, 14)] stringByAppendingString:@"q"], [[md5_sha1_3 substringWithRange:NSMakeRange(32, 14)] stringByAppendingString:@"y"], [[md5_sha1_3 substringWithRange:NSMakeRange(56, 14)] stringByAppendingString:@"3"]];
    
    NSString * md5_sha1_5 =[NSString stringWithFormat:@"%@%@", [md5_sha1_4 substringWithRange:NSMakeRange(40, 35)],[md5_sha1_4 substringWithRange:NSMakeRange(0, 40)]];
    
    return md5_sha1_5;
}

@end
