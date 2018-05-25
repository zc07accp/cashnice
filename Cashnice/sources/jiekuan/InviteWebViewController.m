//
//  BannerWebViewController.m
//  Cashnice
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 l. All rights reserved.
//

#import "InviteWebViewController.h"
#import "HandleComplete.h"
#import "WebShareView.h"

@interface InviteWebViewController () <HandleCompletetExport>
{
    UIView *_naviBar;
    UILabel *_titleLabel;
    UIButton *_backButton;
    UIButton *_rightButton;
    
    WKWebViewConfiguration *_config;

}
@property (nonatomic, strong) WebShareView *shareView;

@end

@implementation InviteWebViewController

- (void)viewDidLoad {
    
    //self.webVIewConfiguration =
    
    [super viewDidLoad];
    [self setNavButton];
    self.title = @"邀请好友";
    //[self configCustomNaviBar];
    
    /*
    UIView *superView = self.view;
    [self.webVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        //make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.top.mas_equalTo(64);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
     */
}

- (WKWebViewConfiguration *)webVIewConfiguration{
    
    if (_config) {
        return _config;
    }
    
    _config = [[WKWebViewConfiguration alloc]init];
    
    HandleComplete *handle = [HandleComplete new] ;
    handle.chainedHandle = self;
    /*
    if (! _completeHandle) {
        handle.targetViewController = self;
        //self.completeHandle = handle;
    }else{
        handle.chainedHandle = self.completeHandle;
    }
     */
    
    [_config.userContentController addScriptMessageHandler:handle name:@"share"];
    
    return _config;
    
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

// 点击导航“关闭”按钮
- (void)customNavBackPressed{
    
    //
    
    NSString *currentURL = self.webVIew.URL.absoluteString;
    
    if ([currentURL mycontainsString:NET_PAGE_INVITE_DETAIL]) {
        
        /*
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEB_DOC_URL_ROOT, NET_PAGE_INVITE_INDEX]];
        [self.webVIew loadRequest:[NSURLRequest requestWithURL:url]];
        */
        
        [self.webVIew goBack];
        
    }else{
        //[self.navigationController setNavigationBarHidden:NO];
        return [super customNavBackPressed];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"邀请好友web"];
    
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"邀请好友web"];
    
    //[self.navigationController setNavigationBarHidden:NO];
}

//- (void)setNavRightBtn{
//    
//    [super setNavRightBtn];
//    self.rightNavBtn.frame = CGRectMake(0, 0, 45, 45);
//    //[self.rightNavBtn setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//    //[self.rightNavBtn  setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//    self.rightNavBtn.layer.borderColor = [UIColor clearColor].CGColor;
//    
//    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share.png"]];
//    [self.rightNavBtn addSubview:imgv];
//    imgv.right = self.rightNavBtn.right-2;
//    imgv.top = 6;
//    
//}

 -(void)loadRequest{
    
    [self removeNoNetwork];
    
    NSURL *url = [NSURL URLWithString:[self.urlStr stringByAppendingString:@"?app=1"]];
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:url]];
     
    //NSLog(@"url = %@", url);
}


- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _naviBar.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
    //_naviBar.alpha = 0.7;
    
    _backButton = [[UIButton alloc]init];
    _backButton.titleLabel.font = [UtilFont systemLargeNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(customNavBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [_backButton setTitle:@"关闭" forState:UIControlStateNormal];
    _backButton.backgroundColor = [UIColor clearColor];;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UtilFont systemNormal:20];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"邀请好友"; //self.atitle;
    [_titleLabel sizeToFit];
    //    _titleLabel.backgroundColor = [UIColor redColor];
    
    [_naviBar addSubview:_titleLabel];
    [_naviBar addSubview:_backButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_naviBar);
        make.top.equalTo(_naviBar).mas_offset(20);
        make.bottom.equalTo(_naviBar);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_naviBar).mas_offset(5);
        make.top.equalTo(_naviBar).mas_offset(20);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
//        make.bottom.equalTo(_naviBar);
    }];
    
    [self.view addSubview:_naviBar];
    
    /*
    _rightButton = [[UIButton alloc]init];
    _rightButton.titleLabel.font = [UtilFont systemLargeNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];

    _rightButton.backgroundColor = [UIColor clearColor];;

    [_naviBar addSubview:_rightButton];

    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_naviBar).mas_offset(-5);
        make.top.equalTo(_naviBar).mas_offset(20);
        make.bottom.equalTo(_naviBar);
        make.width.equalTo(@40);
//        make.height.equalTo(@40);
    }];
     */
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


@end
