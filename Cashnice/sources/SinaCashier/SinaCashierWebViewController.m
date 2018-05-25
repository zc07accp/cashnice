//
//  SinaCashierWebViewController.m
//  Cashnice
//
//  Created by a on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SinaCashierWebViewController.h"
#import "HandleComplete.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "zlib.h"
#import <WebKit/WebKit.h>
#import "InvestmentAction.h"

@interface SinaCashierWebViewController () <WKNavigationDelegate,WKScriptMessageHandler>
{
    NSURL *_baseURL;
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation SinaCashierWebViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    [self.leftNavBtn setImage:nil forState:UIControlStateNormal];
    [self.leftNavBtn setTitle:@"关闭" forState:UIControlStateNormal];
    self.title = @"新浪收银台";//self.titleString;
    
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.top.equalTo(self.mas_topLayoutGuideTop).mas_offset(64);
//        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
//    }];
   
    

    
    if (! _baseURL) {
        _baseURL = [[NSURL alloc] initWithString:@"https://pay.sina.com.cn"];
    }if (self.URLPath.length) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.URLPath]];
        [self.webView loadRequest:request];
    }else if (self.loadData.length) {
        
        NSString *contentString = [[NSString alloc] initWithData:self.loadData encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:contentString baseURL:_baseURL];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"新浪收银台"];
    
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"新浪收银台"];
    
    //[self.navigationController setNavigationBarHidden:NO];
}

-(void)dealloc{
    progress_hide
}


// 点击导航“关闭”按钮
- (void)customNavBackPressed{
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSString *currentURL = self.webView.URL.absoluteString;
    if ([currentURL hasPrefix:@"https://pay.sina.com.cn/website/view/1.html"]  ||
        [currentURL hasPrefix:@"https://pay.sina.com.cn/cashdesk-web/view/1.html"]) {
        [self.completeHandle complete];
        
        return;
    }
    
    NSArray *vcs = self.navigationController.viewControllers;
    if (vcs.count >= 2) {
        UIViewController *vc = vcs[vcs.count-2];
        //直接返回我要投资页面，红包、加息券清空，
        if ([vc isKindOfClass:[InvestmentAction class]]) {
            InvestmentAction *iv = (InvestmentAction *)vc;
            [iv refreshCouponAndCalcInterest];
            //[iv orderCalcValues];
        }
    }
    
    if (self.navigationBackHandler) {
        _navigationBackHandler();
    }else{
        return [super customNavBackPressed];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    progress_show
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    progress_hide
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    progress_hide
    
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    if (! _completeHandle) {
//        HandleComplete *handle = [HandleComplete new] ;
//        handle.targetViewController = self;
//        
//        self.completeHandle = handle;
//    }
//    
//    context[@"jsAndroid"] = self.completeHandle;
//    [context evaluateScript:[NSString stringWithFormat:@"complete()"]];
    
//    [webView evaluateJavaScript:@"complete()" completionHandler:nil];
    
    //[webView evaluateJavaScript:@"window.webkit.messageHandlers.complete.postMessage(null);"
    //          completionHandler:nil];
}

- (WKWebView *)webView{
    if (! _webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        
        HandleComplete *handle = [HandleComplete new] ;
        if (! _completeHandle) {
            handle.targetViewController = self;
            //self.completeHandle = handle;
        }else{
            handle.chainedHandle = self.completeHandle;
        }
        [config.userContentController addScriptMessageHandler:handle name:@"complete"];
        [config.userContentController addScriptMessageHandler:handle name:@"cancel"];
        //状态栏尺寸
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        //导航栏尺寸
        CGRect rectNav = self.navigationController.navigationBar.frame;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - rectStatus.size.height - rectNav.size.height) configuration:config];
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}
//
//-(void)webHandler{
//}



@end
