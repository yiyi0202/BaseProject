//
//  LoginViewController.m
//  BaseProject
//
//  Created by 意一yiyi on 2018/1/9.
//  Copyright © 2018年 意一yiyi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)login:(id)sender {
    
    [ProjectPush setAlias:@"18635565881"];
}

- (IBAction)logout:(id)sender {
    
    [ProjectPush deleteAlias];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
