//
//  ProjectSocial.m
//  BaseProject
//
//  Created by 意一yiyi on 2018/1/4.
//  Copyright © 2018年 意一yiyi. All rights reserved.
//

#import "ProjectSocial.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <UShareUI/UShareUI.h>

/** 要集成哪家的SDK：ShareSDK或者友盟，默认ShareSDK */
ProjectSocialType type = ProjectSocialTypeShareSDK;

@interface ProjectSocial ()

@property (strong, nonatomic) NSMutableDictionary *params;// ShareSDK的分享内容
@property (strong, nonatomic) UMSocialMessageObject *messageObject;// 友盟要分享的内容

@end

@implementation ProjectSocial

//##################################################################//
//  配置，开始
//##################################################################//

/**
 *  配置社会化组件
 */
+ (void)configureSocialWithSocialType:(ProjectSocialType)socialType {
    
    type = socialType;
    
    if (type == ProjectSocialTypeShareSDK) {
        // ShareSDK的AppKey和AppSecret在Info.plist里配置
        
    }else if (type == ProjectSocialTypeUM) {
        
        [[UMSocialManager defaultManager] setUmSocialAppkey:UM_App_Key];
    }
    
    [self configureThirdPlatforms];
}

/**
 *  配置可分享到或用于登录的三方平台
 */
+ (void)configureThirdPlatforms {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [ShareSDK registerActivePlatforms:@[
                                            @(SSDKPlatformTypeSinaWeibo),
                                            @(SSDKPlatformTypeWechat),
                                            @(SSDKPlatformTypeQQ)
                                            ]
                                 onImport:^(SSDKPlatformType platformType)
         {
             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                     break;
                 case SSDKPlatformTypeWechat:
                     [ShareSDKConnector connectWeChat:[WXApi class]];
                     break;
                 case SSDKPlatformTypeQQ:
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                     break;
                 default:
                     break;
             }
         }
                          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
         {
             
             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     [appInfo SSDKSetupSinaWeiboByAppKey:Weibo_App_Key
                                               appSecret:Weibo_App_Secret
                                             redirectUri:Weibo_Redirect_URL
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:Wechat_App_Key
                                           appSecret:Wechat_App_Secret];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:QQ_App_Key
                                          appKey:QQ_App_Secret
                                        authType:SSDKAuthTypeBoth];
                     break;
                 default:
                     break;
             }
         }];
    }else if (type == ProjectSocialTypeUM) {

        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:Weibo_App_Key  appSecret:Weibo_App_Secret redirectURL:Weibo_Redirect_URL];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:Wechat_App_Key appSecret:Wechat_App_Secret redirectURL:nil];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_App_Key appSecret:nil redirectURL:QQ_Redirect_URL];

    }
}

//##################################################################//
//  配置，结束
//##################################################################//


//##################################################################//
//  分享，开始
//##################################################################//

/**
 *  构建要分享的内容
 */
- (void)setShareParams:(NSDictionary *)shareParams {
    
    _shareParams = [shareParams copy];
    
    if (type == ProjectSocialTypeShareSDK) {

        self.params = [NSMutableDictionary dictionary];
        [self.params SSDKSetupShareParamsByText:_shareParams[@"text"]
                                         images:_shareParams[@"image"]
                                            url:[NSURL URLWithString:_shareParams[@"url"]]
                                          title:_shareParams[@"title"]
                                           type:SSDKContentTypeAuto];
        [self.params SSDKEnableUseClientShare];
    }else if (type == ProjectSocialTypeUM) {
        
        self.messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareParams[@"title"] descr:_shareParams[@"text"] thumImage:_shareParams[@"image"]];
        shareObject.webpageUrl = _shareParams[@"url"];
        self.messageObject.shareObject = shareObject;
    }
}

/**
 *  ShareSDK分享到指定的平台
 */
- (void)shareToPlatform_ShareSDK:(SSDKPlatformType)platformType {
    
    [ShareSDK share:platformType parameters:self.params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            
            if ([self.delegate respondsToSelector:@selector(shareDidSuccess)]) {
                
                [self.delegate shareDidSuccess];
            }
        }else if (state == SSDKResponseStateFail){
            
            NSLog(@"ShareSDK分享失败了===========%@", error);
            
            if ([self.delegate respondsToSelector:@selector(shareDidFail)]) {
                
                [self.delegate shareDidFail];
            }
        }else if (state == SSDKResponseStateCancel){
            
            if ([self.delegate respondsToSelector:@selector(shareDidCancel)]) {
                
                [self.delegate shareDidCancel];
            }
        }
    }];
}

/**
 *  友盟分享到指定的平台
 */
- (void)shareToPlatform_UM:(UMSocialPlatformType)platformType {
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:self.messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error == nil) {
            
            if ([self.delegate respondsToSelector:@selector(shareDidSuccess)]) {
                
                [self.delegate shareDidSuccess];
            }
        }else{
            
            if (error.code == 2009) {
                
                if ([self.delegate respondsToSelector:@selector(shareDidCancel)]) {
                    
                    [self.delegate shareDidCancel];
                }
            }else {
                
                NSLog(@"友盟分享失败了===========%@", error);
                
                if ([self.delegate respondsToSelector:@selector(shareDidFail)]) {
                    
                    [self.delegate shareDidFail];
                }
            }
        }
    }];
}

/**
 *  采样SDK默认提供的分享样式分享
 */
- (void)shareWithDefaultStyle {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        NSArray *items = @[
                           @(SSDKPlatformTypeSinaWeibo),// 新浪微博
                           @(SSDKPlatformSubTypeWechatSession),// 微信好友
                           @(SSDKPlatformSubTypeWechatTimeline),// 微信朋友圈
                           @(SSDKPlatformSubTypeQQFriend),// QQ好友
                           @(SSDKPlatformSubTypeQZone)// QQ空间
                           ];
        [ShareSDK showShareActionSheet:nil
                                 items:items
                           shareParams:self.params
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               if ([self.delegate respondsToSelector:@selector(shareDidSuccess)]) {
                                   
                                   [self.delegate shareDidSuccess];
                               }
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               if ([self.delegate respondsToSelector:@selector(shareDidFail)]) {
                                   
                                   [self.delegate shareDidFail];
                               }
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               if ([self.delegate respondsToSelector:@selector(shareDidCancel)]) {
                                   
                                   [self.delegate shareDidCancel];
                               }
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }else if (type == ProjectSocialTypeUM) {
        
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            [self shareToPlatform_UM:(platformType)];
        }];
    }
}

/**
 *  分享到新浪微博
 */
- (void)shareToWeibo {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self shareToPlatform_ShareSDK:(SSDKPlatformTypeSinaWeibo)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self shareToPlatform_UM:(UMSocialPlatformType_Sina)];
    }
}

/**
 *  分享到微信好友
 */
- (void)shareToWechatSession {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self shareToPlatform_ShareSDK:(SSDKPlatformSubTypeWechatSession)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self shareToPlatform_UM:(UMSocialPlatformType_WechatSession)];
    }
}

/**
 *  分享到微信朋友圈
 */
- (void)shareToWechatTimeline {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self shareToPlatform_ShareSDK:(SSDKPlatformSubTypeWechatTimeline)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self shareToPlatform_UM:(UMSocialPlatformType_WechatTimeLine)];
    }
}

/**
 *  分享到 QQ 好友
 */
- (void)shareToQQ {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self shareToPlatform_ShareSDK:(SSDKPlatformSubTypeQQFriend)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self shareToPlatform_UM:(UMSocialPlatformType_QQ)];
    }
}

/**
 *  分享到 QQ 空间
 */
- (void)shareToQZone {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self shareToPlatform_ShareSDK:(SSDKPlatformSubTypeQZone)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self shareToPlatform_UM:(UMSocialPlatformType_Qzone)];
    }
}

//##################################################################//
//  分享，结束
//##################################################################//


//##################################################################//
//  登录，开始
//##################################################################//

/**
 *  ShareSDK用指定的平台登录
 */
- (void)loginWithPlatform_ShareSDK:(SSDKPlatformType)platformType {
    
    [ShareSDK getUserInfo:platformType
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         
         if (state == SSDKResponseStateSuccess) {
             
             if ([self.delegate respondsToSelector:@selector(loginDidSuccess_ShareSDK:)]) {
                 
                 [self.delegate loginDidSuccess_ShareSDK:user];
             }
         }else if (state == SSDKResponseStateFail){
             
             NSLog(@"ShareSDK登录失败了===========%@", error);
             
             if ([self.delegate respondsToSelector:@selector(loginDidFail)]) {
                 
                 [self.delegate loginDidFail];
             }
         }else if (state == SSDKResponseStateCancel){
             
             if ([self.delegate respondsToSelector:@selector(loginDidCancel)]) {
                 
                 [self.delegate loginDidCancel];
             }
         }
     }];
}

/**
 *  友盟用指定的平台登录
 */
- (void)loginWithPlatform_UM:(UMSocialPlatformType)platformType {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        if (error == nil) {
            
            if ([self.delegate respondsToSelector:@selector(loginDidSuccess_UM:)]) {
                
                [self.delegate loginDidSuccess_UM:resp];
            }
        }else{
            
            if (error.code == 2009) {
                
                if ([self.delegate respondsToSelector:@selector(loginDidCancel)]) {
                    
                    [self.delegate loginDidCancel];
                }
            }else {
                
                NSLog(@"友盟登录失败了===========%@", error);
                
                if ([self.delegate respondsToSelector:@selector(loginDidFail)]) {
                    
                    [self.delegate loginDidFail];
                }
            }
        }
    }];
}

/**
 *  微博登录
 */
- (void)loginWithWeibo {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self loginWithPlatform_ShareSDK:(SSDKPlatformTypeSinaWeibo)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self loginWithPlatform_UM:(UMSocialPlatformType_Sina)];
    }
}

/**
 *  微信登录
 */
- (void)loginWithWechat {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self loginWithPlatform_ShareSDK:(SSDKPlatformTypeWechat)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self loginWithPlatform_UM:(UMSocialPlatformType_WechatSession)];
    }
}

/**
 *  QQ登录
 */
- (void)loginWithQQ {
    
    if (type == ProjectSocialTypeShareSDK) {
        
        [self loginWithPlatform_ShareSDK:(SSDKPlatformTypeQQ)];
    }else if (type == ProjectSocialTypeUM) {
        
        [self loginWithPlatform_UM:(UMSocialPlatformType_QQ)];
    }
}

//##################################################################//
//  登录，结束
//##################################################################//

@end
