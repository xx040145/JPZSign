//
//  SignViewController.m
//  InvestmentAssistant
//
//  Created by mac on 2017/12/20.
//  Copyright © 2017年 jpcf. All rights reserved.
//

#import "SignViewController.h"
#import "DrawingBoardView.h"
#import "AppDelegate.h"

@interface SignViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *resignBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet DrawingBoardView *drawView;
/** 图片数据流 */
@property (nonatomic,strong) NSData *imageData;

@end

@implementation SignViewController

- (NSData *)imageData {
    if (!_imageData) {
        _imageData = [NSData data];
    }
    return _imageData;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //是否可以左滑
    [self.navigationController.interactivePopGestureRecognizer setEnabled:self.gesturePopEnable];
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //改变AppDelegate的appdelegete.allowRotation属性
    AppDelegate *appDelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegete.allowRotation = YES;
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //VC的左滑功能重置为可以
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //改变AppDelegate的appdelegete.allowRotation属性
    AppDelegate *appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegete.allowRotation = NO;
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resignBtn.layer.borderColor = [UIColor colorWithRed:208/255.0 green:211/255.0 blue:221/255.0 alpha:1.0].CGColor;
    self.resignBtn.layer.borderWidth = 1.0;
    self.backBtn.layer.borderColor = self.resignBtn.layer.borderColor;
    self.backBtn.layer.borderWidth = self.resignBtn.layer.borderWidth;
    
    __weak typeof(self) weakSelf = self;
    //是否有绘画，判定确认btn是否可点
    self.drawView.drawCallBack = ^(BOOL isFinished) {
        [weakSelf sureBtnEnable:isFinished];
    };
    
    //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [self sureBtnEnable:NO];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 事件监听
//重新签名btn
- (IBAction)resignBtnClick:(id)sender {
    [self sureBtnEnable:NO];
    [self.drawView clearContent];
}

//返回btn
- (IBAction)backBtnClick:(id)sender {
    [self popViewController];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

//确认btn
- (IBAction)sureBtnClick:(id)sender {
    UIImage *img = [self changeToImage];
    NSString *signGraphic = [self UIImageToBase64Str:img];
    [self.delegate signCompleteWithImage:img base64str:signGraphic];
//    self.drawView.backgroundColor = [UIColor colorWithHex:0xEBEBEB];
}

//转换图片
- (UIImage *)changeToImage {
    self.drawView.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(self.drawView.frame.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.drawView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    return image;
}

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
    return encodedImageStr;
}

//确定btn是否可点，和颜色显示
- (void)sureBtnEnable:(BOOL)bl{
    self.sureBtn.enabled = bl;
    self.sureBtn.alpha = bl ? 1 : 0.3;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//是否可以旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    [super prefersStatusBarHidden];
    return YES;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
