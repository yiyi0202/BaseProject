//
//  RGLocationManager.m
//  RGAlive
//
//  Created by 意一yiyi on 2017/6/6.
//  Copyright © 2017年 robin. All rights reserved.
//

#import "RGLocationManager.h"

static CGFloat const admissibleErrorDistance = 5.f;

@interface RGLocationManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) NSString *city;

@end

@implementation RGLocationManager

- (void)configureLocationManager {
    
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {// 如果刚开始没有定位权限
        
        [self.manager requestWhenInUseAuthorization];
    }
    
    self.manager.desiredAccuracy= kCLLocationAccuracyBest;
    
    self.geocoder = [[CLGeocoder alloc] init];
}

- (void)startLocating {
    
    [self.manager startUpdatingLocation];
}

- (void)stopLocating {
    
    [self.manager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

// 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLoaction = [locations lastObject];
    if (currentLoaction.horizontalAccuracy < admissibleErrorDistance || currentLoaction.verticalAccuracy < admissibleErrorDistance) {
        
    }
    
    // 地球坐标转换为火星坐标
    currentLoaction = [currentLoaction transformLocationFromEarthToMars];
    
    [self getCityNameWithCoor:currentLoaction.coordinate];
    

    if ([self.delegate respondsToSelector:@selector(locatingDidSuccessWithCoordinate:)]) {
        
        [self.delegate locatingDidSuccessWithCoordinate:currentLoaction.coordinate];
    }

    [self stopLocating];
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(locatingDidFailWithError:)]) {
        
        [self.delegate locatingDidFailWithError:error];
    }
    
    [self stopLocating];
    NSLog(@"定位失败!");
}


#pragma mark - private methods

// 反编码
- (void)getCityNameWithCoor:(CLLocationCoordinate2D)coordinate {
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"反编码失败:%@",error);
        }
        
        CLPlacemark *placeMark = [placemarks lastObject];
        // 返回的城市 : 国家, 省份, 县, 街道啥啥啥存在一个字典里, 遍历字典
        [placeMark.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSLog(@"反编码================================%@, %@=========================", key, obj);
        }];
    }];
}

@end
