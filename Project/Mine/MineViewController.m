//
//  MineViewController.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableHeaderView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;
@property (strong, nonatomic) NSArray<NSString *> *vcArray;

@property (strong, nonatomic) UILabel *label;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self layoutUI];
}


#pragma mark - request

- (void)fetchData {
    
    NSLog(@"%ld", self.tableView.refreshPage);
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuseID"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellReuseID"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.detailTextLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self.tableView yy_endRefreshingHeader];
    }else {
        
        [self.tableView yy_endRefreshingFooter];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.000001;
}


#pragma mark - setter, getter

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView yy_Adapt_iOS11];

        _tableView.tableHeaderView = self.tableHeaderView;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellReuseID"];
        
        [_tableView yy_addRefreshHeaderWithStyle:(ProjectRefreshHeaderStyle_Arrow_StateLabel) refreshingTarget:self refreshingAction:@selector(fetchData)];
        [_tableView yy_addRefreshFooterWithStyle:(ProjectRefreshFooterStyleStyle_Arrow_StateLabel) refreshingTarget:self refreshingAction:@selector(fetchData)];
    }
    
    return _tableView;
}

- (UIView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _tableHeaderView.backgroundColor = kThemeColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageView.center = _tableHeaderView.center;
        imageView.backgroundColor = [UIColor magentaColor];
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [_tableHeaderView addSubview:imageView];
    }
    
    return _tableHeaderView;
}

- (UILabel *)label {
    
    if (_label == NULL) {
        
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor magentaColor];
        
        _label.attributedText = [@"你好呀1你好呀2你好呀3你好呀4你好呀5" yy_changeToAttributedStringWithTextArray:@[@"你", @"呀"] textColor:[UIColor greenColor] fontSize:(20) deletelineColor:[UIColor yellowColor]];
    }
    
    return _label;
}


#pragma mark - layoutUI

- (void)layoutUI {
    
    // 导航栏
    self.navigationItem.title = @"我的";
    
    // view
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight);
    
    [self.view addSubview:self.label];
    self.label.frame = CGRectMake(0, 382, kScreenWidth, 50);
}


#pragma mark - initialize

- (void)initialize {
    
    self.titleArray = @[@"充值", @"设置"];
    self.vcArray = @[@"PayViewController", @"SettingViewController"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
