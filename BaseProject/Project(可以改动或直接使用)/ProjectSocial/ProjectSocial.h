//
//  ProjectSocial.h
//  BaseProject
//
//  Created by 意一yiyi on 2018/1/4.
//  Copyright © 2018年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSUInteger, ProjectSocialType) {
    
    ProjectSocialTypeShareSDK = 0,
    ProjectSocialTypeUM
};

@protocol ProjectSocialDelegate <NSObject>

@optional
- (void)shareDidSuccess;
- (void)shareDidFail;
- (void)shareDidCancel;

- (void)loginDidSuccess_ShareSDK:(SSDKUser *)userInfo;
- (void)loginDidSuccess_UM:(UMSocialUserInfoResponse *)userInfo;
- (void)loginDidFail;
- (void)loginDidCancel;

@end

@interface ProjectSocial : NSObject

/** 代理对象 */
@property (weak,   nonatomic) id<ProjectSocialDelegate> delegate;

/** 分享参数 */
@property (copy,   nonatomic) NSDictionary *shareParams;// key：title、text、image、url


/**
 *  配置社会化组件
 *
 *  @param  socialType  要集成哪家的SDK：ShareSDK或者友盟，默认ShareSDK
 */
+ (void)configureSocialWithSocialType:(ProjectSocialType)socialType;

- (void)shareWithDefaultStyle;
- (void)shareToWeibo;
- (void)shareToWechatSession;
- (void)shareToWechatTimeline;
- (void)shareToQQ;
- (void)shareToQZone;

- (void)loginWithWeibo;
- (void)loginWithWechat;
- (void)loginWithQQ;

@end
