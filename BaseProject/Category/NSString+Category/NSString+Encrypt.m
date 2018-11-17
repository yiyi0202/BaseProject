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

+ (NSString *)md5EncryptString_Lowercase_FromString:(NSString *)string {
    
    // 加密数组(占16个字节)
    unsigned char resultArray[CC_MD5_DIGEST_LENGTH];
    // 加密
    CC_MD5(string.UTF8String, (CC_LONG)strlen(string.UTF8String), resultArray);
    // 密文
    NSMutableString *md5EncryptString = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [md5EncryptString appendFormat:@"%02x", resultArray[i]];// X代表十六进制
    }
    
    return md5EncryptString;
}

+ (NSString *)md5EncryptString_Uppercase_FromString:(NSString *)string {
    
    // 加密数组(占16个字节)
    unsigned char resultArray[CC_MD5_DIGEST_LENGTH];
    // 加密
    CC_MD5(string.UTF8String, (CC_LONG)strlen(string.UTF8String), resultArray);
    // 密文
    NSMutableString *md5EncryptString = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [md5EncryptString appendFormat:@"%02X", resultArray[i]];// X代表十六进制
    }
    
    return md5EncryptString;
}

+ (NSString *)sha1EncryptString_Lowercase_FromString:(NSString *)string {
    
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *sha1EncryptString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i ++) {
        
        [sha1EncryptString appendFormat:@"%02x", digest[i]];
    }
    
    return sha1EncryptString;
}

+ (NSString *)sha1EncryptString_Uppercase_FromString:(NSString *)string {
    
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *sha1EncryptString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i ++) {
        
        [sha1EncryptString appendFormat:@"%02X", digest[i]];
    }
    
    return sha1EncryptString;
}

@end
