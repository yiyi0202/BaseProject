//
//  HomepageViewController.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "HomepageViewController.h"
#import "LoginViewController.h"

@interface HomepageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) CGFloat scrollScale;// 滑动比例
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationBarAlpha = 0;// 透明导航栏
    [self scrollViewDidScroll:self.tableView];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self setNeedsStatusBarAppearanceUpdate];
    CGFloat offsetY = scrollView.contentOffset.y;
    self.scrollScale = (offsetY - Navigation_Bar_Height) / Navigation_Bar_Height;// 滑动一个导航栏的距离开始显示, 再滑动一个导航栏的距离就全部显示出来
    
    if (self.scrollScale < 0) {
        
        self.navigationBarAlpha = 0;
    }
    
    if (self.scrollScale > 1) {
        
        self.navigationBarAlpha = 1;
    }
    
    if (self.scrollScale >= 0 && self.scrollScale <= 1) {
        
       self.navigationBarAlpha = self.scrollScale;
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuseID" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    UIView *someAlertView = [[UIView alloc] init];
    someAlertView.backgroundColor = [UIColor magentaColor];
    
    ProjectMaskView *maskView = [ProjectMaskView showToView:Key_Window withCustomSubview:someAlertView subviewLayout:^{
        
        someAlertView.frame = CGRectMake(Screen_Width - 80, Screen_Height, 50, 180);
        someAlertView.center = Key_Window.center;
    } subviewAnimation:nil];
    
    maskView.tapBlock = ^{
        
        [ProjectMaskView hideFromView:Key_Window withSubviewAnimation:nil];
    };
}


#pragma mark - private method

- (void)leftBarButtonItemAction:(UIBarButtonItem *)leftBarButtonItem {
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];    
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)rightBarButtonItem {
    
    ProjectWKWebViewController *vc = [[ProjectWKWebViewController alloc] init];
    // 加载本地文件
    vc.filePath = @"index.html";
//    vc.urlString = @"http://teststore.guoss.cn/";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - layoutUI

- (void)layoutUI {
    
    // 导航栏
    self.navigationItem.title = @"首页";
    self.navigationItem.leftBarButtonItem = [self generateLeftBarButtonItemWithTitle:@"登录"];
    self.navigationItem.rightBarButtonItem = [self generateRightBarButtonItemWithTitle:@"简书"];
    
    // view
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - Tab_Bar_Height);
}


#pragma mark - setter, getter

- (UITableView *)tableView {

    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView yy_AdaptiOS11];
        
        _tableView.tableHeaderView = self.tableHeaderView;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellReuseID"];
    }
    
    return _tableView;
}

- (UIView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width / 3.0 * 2.0)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_tableHeaderView.frame];
        tempImageView.backgroundColor = [UIColor clearColor];
        tempImageView.image = [UIImage imageNamed:@"首页大图"];
        [_tableHeaderView addSubview:tempImageView];
    }
    
    return _tableHeaderView;
}


#pragma mark - initialize

- (void)initialize {
    
    self.dataArray = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3"] mutableCopy];
}


#pragma mark - 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (self.scrollScale <= 1) {

        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

        return UIStatusBarStyleLightContent;
    }else {

        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
        return UIStatusBarStyleDefault;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
