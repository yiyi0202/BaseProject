//
//  NSString+Money.m
//  GuoRanHao_Merchant
//
//  Created by 意一yiyi on 2017/12/11.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSString+Money.h"

@implementation NSString (Money)

- (NSString *)yy_formatMoneyString {
    
    return [NSString stringWithFormat:@"%.2f", [self floatValue]];
}

@end
