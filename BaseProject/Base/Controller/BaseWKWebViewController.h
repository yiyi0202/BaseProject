//
//  BaseWKWebViewController.h
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface BaseWKWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;

/// 进度条填充色，默认绿
@property (nonatomic, strong) UIColor *progressViewTintColor;

/// 要加载的url
@property (nonatomic, copy) NSString *urlString;
/// 要加载的本地文件
@property (nonatomic, copy) NSString *filePath;

/// 需要注册的方法名数组：JS调用OC方法时，我们需要注册方法
@property (nonatomic, copy) NSArray<NSString *> *methodNameArray;


/**
 *  用来生成一个JS对象，以便OC调用JS方法给JS传递多参时，直接给JS传一个对象过去
 */
- (NSString *)generateJSObjectWithDictionary:(NSDictionary *)dictionary;


/**
 *  清除缓存
 */
- (void)clearCaches;

@end
