//
//  CLLocation+Category.h
//  MapDemo
//
//  Created by 意一yiyi on 2017/6/30.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Category)

/// 将地球坐标转换为火星坐标
- (CLLocation *)transformLocationFromEarthToMars;

/// 将火星坐标转换为百度坐标
- (CLLocation *)transformLocationFromEarthToBaidu;

@end
