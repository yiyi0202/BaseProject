//
//  NSString+Regex.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/25.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)yy_isPhoneNumber {
    
    NSString *regexString = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)yy_isEmail {
    
    NSString *regexString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

// 此处设置密码由 6~16 个字母和数字组成
- (BOOL)yy_isPassword {

    NSString *regexString = @"[A-Za-z0-9]{6,16}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

// 此处采用 6 位数字的短信验证码
- (BOOL)yy_isMessageVerificationCode {
    
    NSString *regexString = @"[0-9]{6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)yy_isIDCard {
    
    NSString *regexString = @"(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)yy_isChinese {
    
    NSString *regexString = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)yy_isBankCard {
    
    NSString *lastNum = [[self substringFromIndex:(self.length - 1)] copy];// 取出最后一位
    NSString *forwardNum = [[self substringToIndex:(self.length - 1)] copy];// 前 15 或 18 位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i ++) {
        
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray *forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count - 1); i > -1; i --) {// 前 15 位或者前 18 位倒序存进数组
        
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];// 奇数位 * 2 的积 < 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];// 奇数位 * 2 的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];// 偶数位数组
    
    for (int i = 0; i < forwardDescArr.count; i ++) {
        
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) {// 偶数位
            
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else {// 奇数位
            
            if (num * 2 < 9) {
                
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else {
                
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal % 10 ==0) ? YES : NO;
}

- (BOOL)yy_isPostCode {
    
    // 国内邮编为 6 位数字
    NSString *regexString = @"^[0-8]\\d{5}(?!\\d)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:self];
}

@end
