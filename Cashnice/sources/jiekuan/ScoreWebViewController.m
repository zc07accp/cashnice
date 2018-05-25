//
//  ScoreWebViewController.m
//  Cashnice
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 l. All rights reserved.
//

#import "ScoreWebViewController.h"
#import "ScoreJSHandle.h"

@interface ScoreWebViewController () <ScoreJSHandleExport>

@end

@implementation ScoreWebViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"积分";
    self.parameterizedTitle = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavButton];

}

- (void)scoreJSHandleInvest{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)scoreJSHandleLoan{
    [ZAPP.tabViewCtrl setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)scoreJSHandleRecharge{
    UIViewController *recharge = ZSEC(@"SinaRechargeViewController");
    [self.navigationController pushViewController:recharge animated:YES];
}

- (void)scoreJSHandleBank{
    [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
}

- (void)scoreJSHandleEmail{
    [self.navigationController pushViewController:[MeRouter editUserEmailViewController] animated:YES];
}

- (void)scoreJSHandleLicense{
    [self.navigationController pushViewController:[MeRouter businessLicense] animated:YES];
}


- (WKWebViewConfiguration *)webVIewConfiguration{
    if (! [super webVIewConfiguration]) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        
        ScoreJSHandle *handle = [ScoreJSHandle new] ;
        handle.chainedHandle = self;
        /*
         if (! _jsHandle) {
         //handle.targetViewController = self;
         //self.completeHandle = handle;
         }else{
         handle.chainedHandle = self.jsHandle;
         }
         */
        [config.userContentController addScriptMessageHandler:handle name:@"invest"];
        [config.userContentController addScriptMessageHandler:handle name:@"bank"];
        [config.userContentController addScriptMessageHandler:handle name:@"recharge"];
        [config.userContentController addScriptMessageHandler:handle name:@"loan"];
        [config.userContentController addScriptMessageHandler:handle name:@"email"];
        [config.userContentController addScriptMessageHandler:handle name:@"license"];
        
        return config;
    }else{
        return [super webVIewConfiguration];
    }
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
