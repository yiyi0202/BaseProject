//
//  NSString+TimeCycle.m
//  GuoRanHao_Merchant
//
//  Created by zoufukang on 2017/12/6.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "NSString+TimeCycle.h"

@implementation NSString (TimeCycle)

- (NSString *)yy_TimeCycleStartTimeArray:(NSArray *)startTimeArray endTimeArray:(NSArray *)endTimeArray{
    
    NSString * startTempTime = [startTimeArray componentsJoinedByString:@"-"];
    NSString * endTempTime = [endTimeArray componentsJoinedByString:@"-"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *startDate = [format dateFromString:startTempTime];
    NSDate *endDate = [format dateFromString:endTempTime];
    
    NSTimeInterval startDateSTM1 = [startDate timeIntervalSince1970];
    NSTimeInterval endDateSTM2 = [endDate timeIntervalSince1970];
    
    return nil;
}

@end
