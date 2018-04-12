//
//  ProjectWKWebViewController.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectWKWebViewController.h"

@interface ProjectWKWebViewController ()

@end

@implementation ProjectWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - WKNavigationDelegate

// 是否允许请求, 我们可以在此方法中拦截 webView 的 url 做相应的操作
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 开始请求
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    
}

// 请求完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    

}

// 请求失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    

}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
 
    // JS 通过指定的方法 Location
    if ([message.name isEqualToString:@"Location"]) {
        
        // 调用 OC 方法
        [self getLocation];
    }
    
    if ([message.name isEqualToString:@"Share"]) {
        
        [self shareResultWithDict:message.body];
    }
}


#pragma mark - OC 方法

- (void)getLocation {
    
    // 传递单参数的情况
    
    // 假设 JS 通过 Location 方法调用我们 OC 的方法获取位置, 然后我们 OC 又要通过调用 JS setLocation(参数 location) 方法将获取到的位置传递给前端
    
    // 假设我们经过定位获取到了位置
    NSString *location = @"浙江杭州";
    
    // OC 调用 JS 指定的方法传值给 JS, 构建一个可执行的 JS 字符串, 格式为 : JS 方法名 ('参数')， 单个参数一般是字符串用 ‘’ 包住
    NSString *jsString = [NSString stringWithFormat:@"setLocation('%@')", location];
    NSLog(@"%@", jsString);
    // 执行 JS 字符串
    [self.webView evaluateJavaScript:jsString completionHandler:nil];
}

- (void)shareResultWithDict:(NSDictionary *)dictionary {
    
    // 假设我们 OC 要通过调用 JS 的 shareResult(JS 对象) 方法将分享结果传递给前端
    // 传递多参数可以直接将 JS 对象作为参数传递给前端，这样前端就不必写 shareResult（参数1，参数2，...）这样的方法了，可以直接写 shareResult(JS 对象) 这么个方法告诉我们。其实 JS 对象也是一个指定格式字符串，这里我们写一个方法只需传递一个地点进去就可以转化出 JS 对象
    
    // 获取分享结果
    
    // OC 调用 JS 指定的方法传值给 JS, 构建一个可执行的 JS 字符串, 格式为 : JS 方法名 ({JS 对象})，多个参数构建出的 JS 对象用 {} 包住
    NSString *jsString = [NSString stringWithFormat:@"shareResult({%@})", [self generateJSObjectWithDictionary:dictionary]];
    
    // 执行 JS 字符串
    [self.webView evaluateJavaScript:jsString completionHandler:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
