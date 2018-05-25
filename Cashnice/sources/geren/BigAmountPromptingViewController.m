//
//  BigAmountPromptingViewController.m
//  Cashnice
//
//  Created by a on 16/8/30.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BigAmountPromptingViewController.h"
#import "CNActionButton.h"
#import "BigAmountLBXScanViewController.h"

@interface BigAmountPromptingViewController ()


@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet CNActionButton *scanButton;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *promptLabels;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *roundPointViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointWidthConstraint;


@end

@implementation BigAmountPromptingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanButton.enabled = YES;
    
    CGFloat pointWidth = 10.0f;
    self.pointWidthConstraint.constant = pointWidth;
    [self.roundPointViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.layer.cornerRadius = pointWidth / 2;
        view.layer.masksToBounds = YES;
    }];
    
    [self.promptLabels enumerateObjectsUsingBlock:^(UILabel*  _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.font = [UtilFont systemLargeNormal];
        /*          the content come from stroyboard now
        if (0 == idx) {
#ifdef HUBEI
            lab.text = @"请您使用IE浏览器访问cashnice官方网站\nwww.cashnice.com，点击\"大额充值\"；";
#else
            lab.text = @"请您使用IE浏览器访问cashnice官方网站\nwww.cashnice.com，点击\"大额充值\"；";
#endif
        }
        */
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [super viewWillDisappear:animated];
}

- (IBAction)scanAction:(id)sender {
    
    [self presentScanView];
    
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)presentScanView{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 60;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 10;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    
    //使用的支付宝里面网格图片
    UIImage *imgPartNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    style.animationImage = imgPartNet;
    
    
    BigAmountLBXScanViewController *vc = [BigAmountLBXScanViewController new];
    vc.style = style;
    vc.promptString = @"扫描大额充值二维码";
    //开启只识别框内
    vc.isOpenInterestRect = YES;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
