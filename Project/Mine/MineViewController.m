//
//  MineViewController.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/8/18.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tableHeaderView;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;
@property (strong, nonatomic) NSArray<NSString *> *vcArray;


// 头像相关
@property (strong, nonatomic) UIImagePickerController *imgPickerController;
@property (strong, nonatomic) UIImagePickerController *coverImgPickerController;
@property (assign, nonatomic) BOOL isPhotoAlbum;
@property (strong, nonatomic) UIImage *selectedImg;// 从相册选取或者拍照后选取的照片, 如果有值说明是编辑了, 否则就是非编辑
@property (strong, nonatomic) UIImage *selectedCoverImg;// 封面
// 头像相关

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self layoutUI];
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
    }
    
    return _tableHeaderView;
}

- (void)tap {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.isPhotoAlbum = YES;
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.isPhotoAlbum = NO;
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertController addAction:videoAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIImagePickerController *)imgPickerController {
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)]) {
        
        if (!_imgPickerController) {
            
            _imgPickerController = [[UIImagePickerController alloc] init];
            _imgPickerController.delegate = self;
            _imgPickerController.allowsEditing = YES;
            _imgPickerController.mediaTypes = @[@"public.image"];
        }
        
        if (self.isPhotoAlbum) {
            
            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else{
            
            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _imgPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        
        return _imgPickerController;
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持此功能!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:defaltAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return nil;
    }
}


#pragma mark - layoutUI

- (void)layoutUI {
    
    // 导航栏
    self.navigationItem.title = @"我的";
    
    // view
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
