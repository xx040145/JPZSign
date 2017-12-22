//
//  ViewController.m
//  JPZSign
//
//  Created by mac on 2017/12/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "SignViewController.h"

@interface ViewController () <SignDelegate>

@property (nonatomic, strong) UIButton *toSignVCBtn;
@property (nonatomic, strong) UIImageView *signImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.toSignVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    [self.toSignVCBtn setTitle:@"去签名" forState:UIControlStateNormal];
    self.toSignVCBtn.titleLabel.textColor = [UIColor whiteColor];
    self.toSignVCBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.toSignVCBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.toSignVCBtn];
    [self.toSignVCBtn addTarget:self action:@selector(toSignMethod) forControlEvents:UIControlEventTouchUpInside];
    
    self.signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    [self.view addSubview:self.signImgView];
    self.signImgView.backgroundColor = [UIColor lightGrayColor];
}

- (void)toSignMethod {
    SignViewController *signVC = [[SignViewController alloc] init];
    signVC.delegate = self;
    [self.navigationController pushViewController:signVC animated:YES];
}

#pragma SignDelegate
- (void)signCompleteWithImage:(UIImage *)img base64str:(NSString *)base64str{
    self.signImgView.image = img;
    
    //可以在这里执行网络请求、图片上传等操作，成功后pop掉签名页
    SignViewController *signVC = self.navigationController.viewControllers.lastObject;
    [signVC popViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
