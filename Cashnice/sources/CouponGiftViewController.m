//
//  CouponGiftViewController.m
//  Cashnice
//
//  Created by apple on 2017/4/5.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CouponGiftViewController.h"
#import "CouponJSHandle.h"
#import "WebShareView.h"

@interface CouponGiftViewController ()<CouponJSHandleExport>
{
    UIView *_naviBar;
    UIButton *_backButton;
    UILabel *_titleLabel;

}
@property (nonatomic, strong) WebShareView *shareView;
@end

@implementation CouponGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self configCustomNaviBar];

    //self.title =  @"转赠";

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"活动"];
    
    
    
    
    
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"活动"];
    
//    [self.navigationController setNavigationBarHidden:NO];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWebView{
    
    self.webVIewConfiguration = [[WKWebViewConfiguration alloc]init];
    
    CouponJSHandle *handle = [CouponJSHandle new] ;
    handle.chainedHandle = self;

//    [self.webVIewConfiguration.userContentController addScriptMessageHandler:handle name:@"coupongiftsuc"];
    [self.webVIewConfiguration.userContentController addScriptMessageHandler:handle name:@"share"];
    [self.webVIewConfiguration.userContentController addScriptMessageHandler:handle name:@"success"];
    
    [super initWebView];
    
}

//- (void)configCustomNaviBar {
//    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
//    _naviBar.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
//    //_naviBar.alpha = 0.7;
//    
//    _backButton = [[UIButton alloc]init];
//    _backButton.titleLabel.font = [UtilFont systemLargeNormal];
//    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_backButton addTarget:self action:@selector(customNavBackPressed) forControlEvents:UIControlEventTouchUpInside];
//    [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    _backButton.backgroundColor = [UIColor clearColor];;
//    
//    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.font = [UtilFont systemNormal:20];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.text = @"转赠";
//    [_titleLabel sizeToFit];
//    //    _titleLabel.backgroundColor = [UIColor redColor];
//    
//    [_naviBar addSubview:_titleLabel];
//    [_naviBar addSubview:_backButton];
//    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_naviBar);
//        make.top.equalTo(_naviBar).mas_offset(20);
//        make.bottom.equalTo(_naviBar);
//    }];
//    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_naviBar).mas_offset(10);
//        make.top.equalTo(_naviBar).mas_offset(20);
//        make.bottom.equalTo(_naviBar);
//    }];
//    
//    [self.view addSubview:_naviBar];
//}

// 点击导航“关闭”按钮
//- (void)customNavBackPressed{
//    
//    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)couponJSHandleGiftSuc{
    
    POST_REDMONEYLISTFRESH_NOTI;
}

- (void)shareWithObject:(id)object{
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        
        self.shareView.dest = EMPTYSTRING_HANDLE(dict[@"invite_url"]);
        self.shareView.title = EMPTYSTRING_HANDLE(dict[@"invite_title"]);
        self.shareView.desc = EMPTYSTRING_HANDLE(dict[@"invite_desc"]);
        
        [self showShareView];
    }
    
}

- (void)showShareView{
    [self.shareView trigger];
}


- (WebShareView *)shareView{
    if (! _shareView) {
        
        _shareView = [[WebShareView alloc] initWithParentVC:self];
        
    }
    return _shareView;
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
