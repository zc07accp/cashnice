//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "BigAmountLBXScanViewController.h"
//#import "MyQRViewController.h"
//#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanVideoZoomView.h"
#import "BigAmountConfirmationViewController.h"
#import "CustomPromptAlertView.h"

@interface BigAmountLBXScanViewController () <CustomIOSAlertViewDelegate> {
    UIView *_naviBar;
    UIButton *_backButton;
    UILabel *_titleLabel;
}
@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
@end

@implementation BigAmountLBXScanViewController

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavButton];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
    
    self.title = @"扫一扫";
    
    self.navigationController.navigationBar.barTintColor = ZCOLOR(COLOR_NAV_BG_RED);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawPrompt];
    
//    [self.qRScanView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).mas_offset(164);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    
    if (_isQQSimulator) {
        
         [self drawBottomItems];
        [self drawTitle];
         [self.view bringSubviewToFront:_topTitle];
    }
    else
        _topTitle.hidden = YES;
    
    //检查相机权限
    if ([self cameraAvailable]) {
        
    }

}

- (BOOL)cameraAvailable{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        
        NSString *msg = [NSString stringWithFormat:@"请在%@的\"设置-隐私-相机\"选项中，允许%@访问你的照相机。",[UIDevice currentDevice].model,appName];
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
        
        return NO;
    }
    return YES;
}

- (void)customNavBackPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }    
}

//
- (void)drawPrompt{
    if (_promptString) {
        UILabel *label = [[UILabel alloc] init];
        label.text = _promptString;
        label.font = [UtilFont systemLargeNormal];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        [self.view addSubview:label];
        
        CGFloat scanRectWidth = self.view.width - self.style.xScanRetangleOffset*2;
        CGFloat topOffset = self.view.height/2 - scanRectWidth/2 - self.style.centerUpOffset;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).mas_offset(topOffset + scanRectWidth + 40);
        }];
        
    }
}

- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
      
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {            
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
                
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
   
}

- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMyQR = [[UIButton alloc]init];
    _btnMyQR.bounds = _btnFlash.bounds;
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    [_bottomItemsView addSubview:_btnMyQR];   
    
}







- (void)showError:(NSString*)str
{
//    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

// ZXing Scan
- (void)scanZxingResultWithArray:(NSArray*)result
{
    bool _isNavigationBack = NO;
    progress_show;
    
    if (result.count < 1)
    {
        progress_hide
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //NSLog(@"scanResult:%@",result[0]);
    
    
    //LBXScanResult *scanResult = array[0];
    
    NSString*strResult = result[0];
    
    NSRange tokenRange = [strResult rangeOfString:@"token="];
    
    do {
        if (tokenRange.location != NSNotFound) {
            NSString *tokenStr = [strResult substringFromIndex:tokenRange.location + tokenRange.length];
            
            NSError *error;
            NSData *data = [tokenStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dictResult  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
           
            WS(ws);

            if (dictResult && !error) {
                NSString *content = dictResult[@"content"];
                NSString *type = dictResult[@"type"];
                if (content.length > 0 && [type isEqualToString:@"cashnicelogin"]) {
                    
                    //Step 1
                    [ZAPP.netEngine postQrCode:tokenStr step:@"1" complete:^{
                        ;
                    } error:^{
                        ;
                    }];
                    
                    BigAmountConfirmationViewController *vc = ZSEC(@"BigAmountConfirmationViewController");
                    vc.qrCode = tokenStr;
                    [ws.navigationController pushViewController:vc animated:YES];
                    progress_hide
                    return;
                }else{
                    break;
                }
            }else{
                break;
            }
            
        }else{
            break;
        }
        
    } while (0);
    

    progress_hide
    
    [self popAlertMsgWithScanResult:nil];
    
    return;

    
    //self.scanImage = result[1];
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    /*
    ScanResultViewController *vc = [ScanResultViewController new];
    vc.imgScan = result[1];
    
    vc.strScan = result[0];
    
    vc.strCodeType = result[2];
    */
}

// Native Scan
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
   // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        URL_OPEN_SETTING
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self reStartDevice];
    [alertView close];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    
    CustomPromptAlertView *alertView = [[CustomPromptAlertView alloc] initWithTitle:@"提示" andInfo:CNLocalizedString(@"alert.message.qrScanError", nil)];
    alertView.delegate = self;
    [alertView show];
//    
//    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.tixianViewController", nil) closeDelegate:self buttonTitles:@[@"我知道了"]];
//    alertView.tag = 0;
//    [alertView show];
//    [alertView formatAlertButton];
    
    /*
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        
        //点击完，继续扫码
        [weakSelf reStartDevice];
    } buttonsStatement:@"知道了",nil];
     */
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
//    ScanResultViewController *vc = [ScanResultViewController new];
//    vc.imgScan = strResult.imgScanned;
//    
//    vc.strScan = strResult.strScanned;
//    
//    vc.strCodeType = strResult.strBarCodeType;
//    
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

//开关闪光灯
- (void)openOrCloseFlash
{
    
    [super openOrCloseFlash];
   
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)myQRCode
{
//    MyQRViewController *vc = [MyQRViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}



@end
