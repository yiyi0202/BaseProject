//
//  RGLocationManager.h
//  RGAlive
//
//  Created by 意一yiyi on 2017/6/6.
//  Copyright © 2017年 robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Category.h"

@protocol RGLocationManagerDelegate <NSObject>

- (void)locatingDidSuccessWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)locatingDidFailWithError:(NSError *)error;

@end

@interface RGLocationManager : NSObject

// 定位配置
- (void)configureLocationManager;

// 开始定位
- (void)startLocating;

// 结束定位
- (void)stopLocating;

@property (weak, nonatomic) id<RGLocationManagerDelegate> delegate;

@end
