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

/// 进度条填充色, 默认绿
@property (nonatomic, strong) UIColor *progressViewTintColor;

/// 要加载的 url
@property (nonatomic,   copy) NSString *urlString;
/// 要加载的本地文件
@property (nonatomic,   copy) NSString *filePath;

/// JS 通过指定的方法给我们传值或者想调用我们 OC 的方法时, 注册的消息名数组
@property (nonatomic,   copy) NSArray<NSString *> *jsMessageNameArray;


/**
 *  OC 调用 JS 方法给 JS 传递多参, 用来生成一个 JS 对象, 直接给 JS 传一个对象过去
 */
- (NSString *)generateJSObjectWithDictionary:(NSDictionary *)dictionary;

@end
