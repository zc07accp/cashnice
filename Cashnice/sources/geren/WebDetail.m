//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "WebDetail.h"
#import <WebKit/WebKit.h>
#import "CouponJSHandle.h"
#import "WebShareView.h"
#import "BrokenNetworkView.h"
#import "RealReachability.h"
#import "UtilDevice.h"

@interface WebDetail () <WKNavigationDelegate, CouponJSHandleExport>

@property (strong, nonatomic) IBOutlet WKWebView *web;
@property (nonatomic, strong) WebShareView *shareView;
@property(nonatomic, strong) BrokenNetworkView *netView;
@end

@implementation WebDetail

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    self.web = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[self webViewConfiguration]];
    self.web.navigationDelegate = self;
    
    [self.view addSubview:self.web];
    UIView *superView = self.view;
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(superView.mas_bottom);
    }];
    
    
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
	
    //网络不给力
    if (![UtilDevice isNetworkConnected]){
        [self showNetView];
    }else{
        [self loadRequest];
    }
}

- (void)customNavBackPressed{
    if (self.web.canGoBack) {
        [self.web goBack];
    }else{
        [super customNavBackPressed];
    }
}

- (void)loadRequest{
    if (self.userAssistantPath) {
        NSString *path = self.userAssistantPath[@"path"];
        NSString *name = self.userAssistantPath[@"name"];
        NSURL *url;
        if ([self.absolutePath length] > 1) {
            url = [NSURL URLWithString:self.absolutePath];
        }else{
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cashnice/Help/%@",WEB_DOC_URL_ROOT,path]];
        }
        self.title = name;
        [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        BOOL load_from_file = NO;
        if (load_from_file) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contact" ofType:@"html"];
            NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            [self.web loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
        }
        else {
            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getUrlStringFromType]]]];
        }
    }
}

- (WKWebViewConfiguration *)webViewConfiguration{
    WKWebViewConfiguration *webVIewConfiguration = [[WKWebViewConfiguration alloc]init];
    
    CouponJSHandle *handle = [CouponJSHandle new] ;
    handle.chainedHandle = self;
    
    [webVIewConfiguration.userContentController addScriptMessageHandler:handle name:@"share"];
    
    return webVIewConfiguration;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
//    progress_show
//}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    if ([UtilDevice webViewFailCausedByNetwork:error]) {
        progress_hide
        
        [self showNetView];
        return;
    }else{
        [self hideNetView];
    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    progress_show
}
 
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    progress_hide
    [self hideNetView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    progress_hide
    if ([UtilDevice webViewFailCausedByNetwork:error]) {
        [self showNetView];
        return;
    }else{
        [self hideNetView];
    }
    
    

}

-(void)showNetView{
    
    if(!self.netView){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BrokenNetworkView" owner:self options:nil];
        self.netView = nib[0];
        WS(weakSelf)
        self.netView.freshAction = ^{
            
            progress_show
            bugeili_net_new_withouttoas_block(^{progress_hide});
            [weakSelf loadRequest];
        };
        
        [self.view addSubview:self.netView];
        //        self.netView.top = ;
        //        self.netView.left = (MainScreenWidth - self.netView.width)/2;
        UIView*superView = self.view;
        [self.netView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.mas_centerX);
            make.centerY.equalTo(superView.mas_centerY);
            make.width.equalTo(@240);
            make.height.equalTo(@224);
            
        }];
        
    }
    
}

- (void)hideNetView{
    self.netView.hidden = YES;
}
/*
- (void)webViewDidStartLoad:(UIWebView *)webView {
    progress_show
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    progress_hide
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    progress_hide
}
 
 */


- (NSString *)getUrlStringFromType {
	NSString *path = @"";
	if (self.webType == WebDetail_borrow_xuzhi) {
		path = WEB_DOC_XU_ZHI;
	}
	else if (self.webType == WebDetail_service_agreement) {
		path = WEB_DOC_AGREEMENT;
	}
	else if (self.webType == WebDetail_contact_us) {
		path = WEB_DOC_CONTACT;
    }else if (self.webType == WebDetail_RegProtocol) {
        path = WEB_DOC_REGPROTOCOL;
    }
    path = [NSString stringWithFormat:@"%@/cashnice/%@", WEB_DOC_URL_ROOT, path];
    path = [NSString stringWithFormat:@"%@?xt=%@", path, @([NSDate new].timeIntervalSince1970)];
	return path;
}

- (NSString *)getTitleFromType {
    
    if (self.userAssistantPath) {
        return self.userAssistantPath[@"name"];
    }
    
	if (self.webType == WebDetail_borrow_xuzhi) {
		return @"借款协议";
	}
	else if (self.webType == WebDetail_service_agreement) {
		return @"服务协议";
	}
	else if (self.webType == WebDetail_contact_us) {
		return @"联系我们";
    }else if (self.webType == WebDetail_RegProtocol) {
        return @"用户协议";
    }
	return @"";
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

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
[self setNavButton];
	
	[MobClick beginLogPageView:[self getTitleFromType]];
	
	[self setTitle:[self getTitleFromType]];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[MobClick endLogPageView:[self getTitleFromType]];
}




@end
