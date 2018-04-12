//
//  BaseRequest.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/21.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "BaseRequest.h"

@interface BaseRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation BaseRequest

#pragma mark - life cycle

static BaseRequest *request = nil;
+ (instancetype)sharedRequest {
    
    return [[[self class] alloc] init];
}


#pragma mark - public method

- (void)startMonitoringReachabilityWithDefaultStyle:(BOOL)flag status:(void(^)(BaseRequestReachabilityStatus status))block {
    
    if (flag) {
        
        UILabel *notReachableLabel = [[UILabel alloc] init];
        notReachableLabel.backgroundColor = [UIColor blackColor];
        notReachableLabel.alpha = 0.618;
        notReachableLabel.text = @"好像断网了！";
        notReachableLabel.textColor = [UIColor whiteColor];
        notReachableLabel.textAlignment = NSTextAlignmentCenter;
        
        [kWindow addSubview:notReachableLabel];
        [kWindow bringSubviewToFront:notReachableLabel];
        notReachableLabel.hidden = YES;
        notReachableLabel.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, 0);
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable:
                {
                    notReachableLabel.hidden = NO;
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        notReachableLabel.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight - kStatusBarHeight);
                        [kWindow layoutIfNeeded];
                    }];
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        notReachableLabel.frame = CGRectMake(0, kStatusBarHeight, kScreenWidth, 0);
                        [kWindow layoutIfNeeded];
                    }];
                    
                    notReachableLabel.hidden = NO;
                }
                    break;
            }
        }];
    }else {
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    
                    block(BaseRequestReachabilityStatusUnknown);
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    
                    block(BaseRequestReachabilityStatusNotReachable);
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    
                    block(BaseRequestReachabilityStatusReachableViaWWAN);
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    
                    block(BaseRequestReachabilityStatusReachableViaWiFi);
                    break;
            }
        }];
    }
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)get:(NSString *)urlString
     params:(NSDictionary *)params
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *targetParams = nil;
    if ([self respondsToSelector:@selector(handleParams:targetParams:)]) {// 如果外界调用了添加共性参数, 那么只要调用一下该方法, targetParams 就会是添加后的 params
        
        [self handleParams:params targetParams:&targetParams];
    }else {// 否则返回源参数
        
        targetParams = [params copy];
    }
    
    
    // 发起请求
    [self.httpSessionManager GET:urlString parameters:targetParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([self respondsToSelector:@selector(preHandleRawData:formatData:error:)]) {// 如果外界对源数据进行了预处理, 那么返回预处理后的数据
            
            id formatData = nil;
            NSError *error = nil;
            
            [self preHandleRawData:responseObject formatData:&formatData error:&error];
            
            // 这里是请求成功, 但是请求到了错误的状态码和错误信息的情况
            if (error) {
                
                failure(task, error);
            }else {
                
                // 这里是请求成功, 并且请求到了正确的状态码和真正要使用的数据的情况
                success(task, formatData);
            }
        }else {// 否则返回原始数据
            
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        failure(task, error);
    }];
}

- (void)post:(NSString *)urlString
      params:(NSDictionary *)params
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *targetParams = nil;
    if ([self respondsToSelector:@selector(handleParams:targetParams:)]) {
        
        [self handleParams:params targetParams:&targetParams];
    }else {
        
        targetParams = [params copy];
    }
    
    [self.httpSessionManager POST:urlString parameters:targetParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([self respondsToSelector:@selector(preHandleRawData:formatData:error:)]) {
            
            id formatData = nil;
            NSError *error = nil;
            
            [self preHandleRawData:responseObject formatData:&formatData error:&error];
            
            if (error) {
                
                failure(task, error);
            }else {
                
                success(task, formatData);
            }
        }else {
            
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task, error);
    }];
}

- (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
          data:(NSData *)data
      mimeType:(NSString *)mimeType
  serverColumn:(NSString *)serverColumn
      progress:(void (^)(NSString *progress))progress
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *targetParams = nil;
    if ([self respondsToSelector:@selector(handleParams:targetParams:)]) {
        
        [self handleParams:params targetParams:&targetParams];
    }else {
        
        targetParams = [params copy];
    }
    
    // 在网络开发中, 上传文件时不允许文件重名, 所以这里采用当前系统时间为文件名
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
    if ([mimeType isEqualToString:@"Image"]) {
        
        fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
    }else if ([mimeType isEqualToString:@"Audio"]) {
        
        fileName = [NSString stringWithFormat:@"%@.mp3", fileName];
    }else if ([mimeType isEqualToString:@"Video"]) {
        
        fileName = [NSString stringWithFormat:@"%@.mp4", fileName];
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:targetParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:serverColumn fileName:fileName mimeType:mimeType];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress * _Nonnull uploadProgress) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  // 上传进度
                                                  // int64_t uploadProgress.totalUnitCount 上传文件的总大小
                                                  // int64_t uploadProgress.completedUnitCount 当前已上传的大小
                                                  progress([NSString stringWithFormat:@"%.1f%%", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount * 100]);
                                              });
                                          }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              
                                              if (!error) {
                                                  
                                                  if ([self respondsToSelector:@selector(preHandleRawData:formatData:error:)]) {
                                                      
                                                      id formatData = nil;
                                                      NSError *error = nil;
                                                      
                                                      [self preHandleRawData:responseObject formatData:&formatData error:&error];
                                                      
                                                      if (error) {
                                                          
                                                          failure(nil, error);
                                                      }else {
                                                          
                                                          success(nil, formatData);
                                                      }
                                                  }else {
                                                      
                                                      success(nil, responseObject);
                                                  }
                                              } else {
                                                  
                                                  failure(nil, error);
                                              }
                                          }];
    
    [uploadTask resume];
}

- (void)upload:(NSString *)urlString
        params:(NSDictionary *)params
         datas:(NSArray<NSData *> *)datas
     mimeTypes:(NSArray<NSString *> *)mimeTypes
  serverColumn:(NSString *)serverColumn
      progress:(void (^)(NSString *progress))progress
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *targetParams = nil;
    if ([self respondsToSelector:@selector(handleParams:targetParams:)]) {
        
        [self handleParams:params targetParams:&targetParams];
    }else {
        
        targetParams = [params copy];
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:targetParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i < datas.count; i ++) {
            
            // 在网络开发中, 上传文件时不允许文件重名, 所以这里采用当前系统时间为文件名
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
            if ([mimeTypes[i] isEqualToString:@"Image"]) {
                
                fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
            }else if ([mimeTypes[i] isEqualToString:@"Audio"]) {
                
                fileName = [NSString stringWithFormat:@"%@.mp3", fileName];
            }else if ([mimeTypes[i] isEqualToString:@"Video"]) {
                
                fileName = [NSString stringWithFormat:@"%@.mp4", fileName];
            }
            
            [formData appendPartWithFileData:datas[i] name:serverColumn fileName:fileName mimeType:mimeTypes[i]];
        }
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request
                                          progress:^(NSProgress * _Nonnull uploadProgress) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  // 上传进度
                                                  // int64_t uploadProgress.totalUnitCount 上传文件的总大小
                                                  // int64_t uploadProgress.completedUnitCount 当前已上传的大小
                                                  progress([NSString stringWithFormat:@"%.1f%%", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount * 100]);
                                              });
                                          }
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              
                                              if (!error) {
                                                  
                                                  if ([self respondsToSelector:@selector(preHandleRawData:formatData:error:)]) {
                                                      
                                                      id formatData = nil;
                                                      NSError *error = nil;
                                                      
                                                      [self preHandleRawData:responseObject formatData:&formatData error:&error];
                                                      
                                                      if (error) {
                                                          
                                                          failure(nil, error);
                                                      }else {
                                                          
                                                          success(nil, formatData);
                                                      }
                                                  }else {
                                                      
                                                      success(nil, responseObject);
                                                  }
                                              } else {
                                                  
                                                  failure(nil, error);
                                              }
                                          }];
    
    [uploadTask resume];
}


#pragma mark - setter, getter

- (AFHTTPSessionManager *)httpSessionManager {
    
    if (_httpSessionManager == nil) {
        
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kDomainName] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        _httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求序列化器
        _httpSessionManager.requestSerializer.timeoutInterval = 11;// 请求超时时长
        
        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];// 响应序列化器
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];// 可接受的数据类型
    }
    
    return _httpSessionManager;
}

@end
