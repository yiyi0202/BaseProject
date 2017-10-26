//
//  BaseWKWebViewController.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "BaseWKWebViewController.h"

@interface BaseWKWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation BaseWKWebViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];

    [self.webView addObserver:self forKeyPath:@"title" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)dealloc {

    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    if (self.jsMessageNameArray.count != 0) {
        
        for (NSString *methodName in self.jsMessageNameArray) {
            
            [self.webView.configuration.userContentController removeScriptMessageHandlerForName:methodName];
        }
    }
    
    [self clearCaches];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"]) {

        self.navigationItem.title = change[@"new"];
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        [self.progressView setProgress:[change[@"new"] doubleValue] animated:YES];
        if ([change[@"new"] doubleValue] == 1.0) {
            
            [self.progressView setProgress:0.0];
            self.progressView.transform = CGAffineTransformMakeScale(1, 0);
        }
    }
}


#pragma mark - WKNavigationDelegate

// 是否允许请求, 我们可以在此方法中拦截 webView 的 url 做相应的操作
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    self.progressView.transform = CGAffineTransformMakeScale(1, 2);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 开始请求
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 是否允许接收
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 开始接收
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

}

// 请求完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 请求失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}


#pragma mark - WKUIDelegate

// JS 想要创建新窗口时会触发该方法
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (navigationAction.targetFrame == NULL) {
        
        [self.webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

// JS 调用 alert() 方法时会触发该方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// JS 调用 confirm() 方法时会触发该方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// JS 调用 prompt() 方法时会触发该方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields[0].text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}


#pragma mark - public methods

- (NSString *)generateJSObjectWithDictionary:(NSDictionary *)dictionary {
    
    __block NSMutableArray *tempArray = [@[] mutableCopy];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *tempString = [NSString stringWithFormat:@"%@:'%@'", key, obj];
        [tempArray addObject:tempString];
    }];
    NSString *jsString = [tempArray componentsJoinedByString:@","];
    
    return jsString;
}


#pragma mark - private methods

- (void)leftBarButtonItemAction:(UIBarButtonItem *)leftBarButtonItem {
    
    if ([((UIButton *)leftBarButtonItem).titleLabel.text isEqualToString:@"关闭"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if (self.webView.canGoBack) {
            
            [self.webView goBack];
        }else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)clearCaches {
    
    [self.webView.configuration.websiteDataStore removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] modifiedSince:[NSDate dateWithTimeIntervalSince1970:0.0] completionHandler:^{
        
    }];
}


#pragma mark - layoutUI

- (void)layoutUI {
    
    // 导航栏
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [backButton setImage:[UIImage imageNamed:@"NavigationBarBackArrow"] forState:(UIControlStateNormal)];
    [backButton layoutImageAndTitle:(ImageAndTitleLayoutStyleImageLeftToLabel) imageTitleSpace:2];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:(UIControlStateNormal)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    UIBarButtonItem *backItem = [self generateLeftBarButtonItemWithCustomView:backButton];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [closeButton setTitle:@"关闭" forState:(UIControlStateNormal)];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [closeButton setTitleColor:self.navigationController.navigationBar.tintColor forState:(UIControlStateNormal)];
    [closeButton setAdjustsImageWhenHighlighted:NO];
    UIBarButtonItem *closeItem = [self generateLeftBarButtonItemWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
    
    // view
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    self.webView.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight);
    self.progressView.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, 2.0);
    self.progressView.transform = CGAffineTransformMakeScale(1, 2);
}


#pragma mark - setters, getters

- (void)setUrlString:(NSString *)urlString {
    
    _urlString = urlString;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self.webView loadRequest:request];
#pragma clang diagnostic pop
}

- (void)setFilePath:(NSString *)filePath {
    
    _filePath = filePath;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:_filePath ofType:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
#pragma clang diagnostic pop
    
    [self.webView loadRequest:request];
}

- (void)setProgressViewTintColor:(UIColor *)progressViewTintColor {
    
    _progressViewTintColor = progressViewTintColor;
    
    self.progressView.progressTintColor = _progressViewTintColor;
}

- (void)setJsMessageNameArray:(NSArray<NSString *> *)jsMessageNameArray {
    
    _jsMessageNameArray = jsMessageNameArray;
    
    if (self.jsMessageNameArray.count != 0) {
        
        for (NSString *methodName in self.jsMessageNameArray) {
            
            [self.webView.configuration.userContentController addScriptMessageHandler:self name:methodName];
        }
    }
}

- (WKWebView *)webView {
    
    if (_webView == nil) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        configuration.preferences.minimumFontSize = 40;
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.allowsInlineMediaPlayback = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.backgroundColor = kVCBackgroundColor;
        
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = YES;
        
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    
    return _webView;
}

- (UIProgressView *)progressView {
    
    if (_progressView == nil) {
        
        _progressView = [[UIProgressView alloc] init];
        
        _progressView.trackTintColor = kVCBackgroundColor;
        _progressView.progressTintColor = [UIColor colorWithRed:70 / 255.0 green:185 / 255.0 blue:66 / 255.0 alpha:1];
    }
    
    return _progressView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
