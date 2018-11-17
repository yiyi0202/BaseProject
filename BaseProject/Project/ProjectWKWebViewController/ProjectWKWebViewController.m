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
    
    self.methodNameArray = @[@"callMethod"];
}

#pragma mark - WKNavigationDelegate

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
 
    NSDictionary *messageBody = [self getMessageBodyWithType:2];
    if ([message.name isEqualToString:@"callMethod"]) {
        
//        [self performSelector:NSSelectorFromString(messageBody[@"methodName"]) withObject:@"name" withObject:@"age"];
        NSString *methodName;
        NSArray *methodParameters = [messageBody[@"methodParameters"] copy];
        if (methodParameters.count == 0) {
            
            methodName = messageBody[@"methodName"];
        }else {
            
            methodName = [NSString stringWithFormat:@"%@:", messageBody[@"methodName"]];
        }
        [self performSelector:NSSelectorFromString(methodName) withObject:methodParameters];
    }
}
/*/=================================================================//

wkhinvoke.getMethod({
                      @"methodName"       :   @"setNameAndAge",
                      @"methodParameters" :   @["panda", 11]
                      })

XXXinvoke.setName()
XXXinvoke.setName("panda")
XXXinvoke.setNameAndAge("panda", 11)
//=================================================================//
@{
    @"methodName"       :   @"setName",
    @"methodParameters" :   @[]
}

@{
    @"methodName"       :   @"setName",
    @"methodParameters" :   @[@"panda"]
}

@{
    @"methodName"       :   @"setAge",
    @"methodParameters" :   @[11]
}

@{
    @"methodName"       :   @"setNameAndAge",
    @"methodParameters" :   @[@"panda", 11]
}
//=================================================================//
void setName {
    
    
}

void setName(String name) {
    
    
}

void setAge(int age) {
    
    
}

void setNameAndAge(String name, int age) {
    
    
}
//=================================================================//
- (void)setName {
    
    
}

- (void)setAge:(int)age {
    
    
}

- (void)setName:(NSString *)name andAge:(int)age {
    
    
}

- (void)setNameAndAge:(NSDictionary *)params {
    
    
}
//=================================================================/*/

- (void)setName {
    
    NSLog(@"你没给我名字啊");
}

- (void)setPersonalInfo:(NSArray *)params {
    
    NSLog(@"%@", params);
}

- (void)setName:(NSString *)name andAge:(NSInteger)age {
    
    NSLog(@"%@, %ld", name, age);
}

- (void)setName:(NSString *)name andAge:(NSInteger)age andSex:(NSString *)sex {
    
    NSLog(@"%@, %ld, %@", name, age, sex);
}

- (NSDictionary *)getMessageBodyWithType:(NSInteger)type {
    
    NSDictionary *messageBody;
    switch (type) {
        case 0:
            messageBody = [@{
                            @"methodName":@"setName",
                            @"methodParameters":@[]
                            } copy];
            return messageBody;
            break;
        case 1:
            messageBody = [@{
                            @"methodName":@"setName:",
                            @"methodParameters":@[@{@"firstname":@"panda", @"lastname":@"da"}]
                            } copy];
            return messageBody;
            break;
        case 2:
            messageBody = [@{
                             @"methodName":@"setPersonalInfo",
                             @"methodParameters":@[@"panda", @"11"]
                            } copy];
            return messageBody;
            break;
        case 3:
            messageBody = [@{
                             @"methodName":@"setName:andAge:andSex:",
                             @"methodParameters":@[@"panda", @"11", @"male"]
                            } copy];
            return messageBody;
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark - OC 方法

- (void)shareResultWithDict:(NSDictionary *)dictionary {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
