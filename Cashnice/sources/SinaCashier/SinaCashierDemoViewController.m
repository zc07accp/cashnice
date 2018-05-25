//
//  SinaCashierDemoViewController.m
//  Cashnice
//
//  Created by a on 16/8/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SinaCashierDemoViewController.h"
#import "HandleComplete.h"
#import "Base64EncoderDecoder.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SinaCashierWebViewController.h"
#import "SinaCashierModel.h"
#import "zlib.h"


@interface SinaCashierDemoViewController () <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    SinaCashierModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation SinaCashierDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[SinaCashierModel alloc] init];
    
    _contentArray = @[@"设置密码", @"修改密码", @"找回密码", @"查询是否设置密码", @"修改绑定的手机号", @"找回绑定的手机号",
                      @"我的银行卡管理", @"充值", @"提现", @"投资", @"还款", @"测试"];
    self.title = @"新浪收银台Demo";
    
    [self setupUI];
}

- (void)setupUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)setPassword{
    __weak id weakSelf = self;
    progress_show
    [_model setPayPasswordWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
    } failure:^(NSString *error) {
        progress_hide;
    }];
}

- (void)modifyPassWord{
    __weak id weakSelf = self;
    progress_show
    [_model modifyPayPasswordWithsuccess:^(NSString *URL, NSData *Content) {
        progress_show
        [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

- (void)findPassWord{
    __weak id weakSelf = self;
    progress_show
    [_model findPayPasswordWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

//查询是否设置密码
- (void)isSetPayPassword{
    progress_show
    [_model queryIsSetPayPasswordWithsuccess:^(BOOL isSetPayPassword) {
        progress_hide
        NSString *title = isSetPayPassword ? @"已设置密码" : @"未设置密码";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

//修改绑定的手机号

- (void)modifyVerifyMobile {
    __weak id weakSelf = self;
    progress_show
    [_model modifyVerifyMobileWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

//找回绑定的手机号
- (void)findVerifyMobile{
    __weak id weakSelf = self;
    progress_show
    [_model findVerifyMobileWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
    } failure:^(NSString *error) {
       progress_hide
    }];
}
 
//银行卡管理
- (void)bankcard{
    __weak id weakSelf = self;
    progress_show
    [_model bankCardManagementWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        [weakSelf pushToSinaWebViewWithURLPath:URL orContentData:Content];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

//投资
- (void)investAction{
    progress_show
    [_model investAction:@"100" loanId:@"2047" couId:@"" bicid:@"" success:^(NSData *contentData) {
        progress_hide
        [self pushToSinaWebViewWithContentData:contentData];
    } failure:^(NSDictionary *error) {
        progress_hide
    }];
}

//还款
- (void)repaymentAction{
    
    progress_show
    [_model repaymentAction:@"100" loanId:@"1857" success:^(NSData *contentData, NSString *contentString) {
        progress_hide
        [self pushToSinaWebViewWithContentData:contentData];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

//充值
- (void)recharge{
    __weak id weakSelf = self;
    progress_show
    [_model recharge:@"3" success:^(NSData *contentData) {
        progress_hide
        [weakSelf pushToSinaWebViewWithContentData:contentData];
    } failure:^(NSString *error) {
        progress_hide
    }];
    
//    [ZAPP.netEngine sinaRechargeWithComplete:^{
//        NSDictionary *response = ZAPP.myuser.visaValidationCodeRespondDict;
//        NSString *content = response[@"content"];
//        NSData *decodedData = [Base64EncoderDecoder base64Decode:content];
//        NSData *unzipedData = [[self class] ungzipData:decodedData];
//        NSString *string = [[NSString alloc] initWithData:unzipedData encoding:NSASCIIStringEncoding]; //转成字符串
//        NSLog(@"%@", string);
//        
//        
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 414, 600)];
//        webView.delegate = self;
//        [webView loadData:unzipedData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
//        [self.view addSubview:webView];
////
////        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////        FunTest *test = [FunTest new] ;
////        context[@"jsAndroid"] = test;
//        
//    } error:^{
//        ;
//    } val:@"3"];
}

//体现
- (void)withdraw{
    __weak id weakSelf = self;
    progress_hide
    [_model withdraw:@"1.11" success:^(NSData *contentData) {
        progress_hide
        [weakSelf pushToSinaWebViewWithContentData:contentData];
    } failure:^(NSString *error) {
        progress_hide
    }];
    
    /*
    [ZAPP.netEngine sinaWithdrawWithComplete:^{
        NSDictionary *response = ZAPP.myuser.visaValidationCodeRespondDict;
        NSString *content = response[@"content"];
        NSData *decodedData = [Base64EncoderDecoder base64Decode:content];
        NSData *unzipedData = [[self class] ungzipData:decodedData];
//        NSString *string = [[NSString alloc] initWithData:unzipedData encoding:NSASCIIStringEncoding]; //转成字符串
//        NSLog(@"%@", string);
        
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 414, 600)];
//        webView.delegate = self;
//        [webView loadData:unzipedData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
//        [self.view addSubview:webView];
        
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.loadData = unzipedData;
        [self.navigationController pushViewController:web animated:YES];
        
    } error:^{
        ;
    } val:@"1"];
     */
}

- (void)pushToSinaWebViewWithURLPath:(NSString *)URLPath orContentData:(NSData *)contentData{
    if (URLPath.length) {
        [self pushToSinaWebViewWithURLPath:URLPath];
    }else if (contentData){
        [self pushToSinaWebViewWithContentData:contentData];
    }
}

- (void)pushToSinaWebViewWithURLPath:(NSString *)URLPath{
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    web.URLPath = URLPath;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)pushToSinaWebViewWithContentData:(NSData *)contentData{
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    web.loadData = contentData;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    HandleComplete *handle = [HandleComplete new] ;
    handle.targetViewController = self;
    
    context[@"jsAndroid"] = handle;
    
    [context evaluateScript:[NSString stringWithFormat:@"complete()"]];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *path = [[request URL] absoluteString];
    NSLog(@"%@", path);
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"SinaDemoCell";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd：%@", indexPath.row, _contentArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger rowIndex = indexPath.row;
    
    NSLog(@"%@", _contentArray[rowIndex]);
    
    switch (rowIndex) {
        case 0:
        {
            //设置密码
            [self setPassword];
        }
            break;
        case 1:
        {
            //修改密码
            [self modifyPassWord];
        }
            break;
        case 2:
        {
            //找回密码
            [self findPassWord];
        }
            break;
        case 3:
        {
            //@"查询是否设置密码"
            [self isSetPayPassword];
        }
            break;
        case 4:
        {
            //@"修改绑定的手机号"
            [self modifyVerifyMobile];
        }
            break;
        case 5:
        {
            //@"找回绑定的手机号"
            [self findVerifyMobile];
        }
            break;
        case 6:
        {
            //@"我的银行卡管理"
            [self bankcard];
        }
            break;
        case 7:
        {
            //@"充值"
            [self recharge];
        }
            break;
        case 8:
        {
            //提现
            [self withdraw];
        }
            break;
        case 9:
        {
            //投资
            [self investAction];
        }
            break;
        case 10:
        {
            //还款
            [self repaymentAction];
        }
            break;
        case 11:
        {
            //测试
#ifdef TEST_TEST_SERVER
            
            
            
            [self pushToSinaWebViewWithURLPath:@"https://rc1newm.cashnice.com/wpay/return/service_name/create_hosting_collect_trade?sinaPnsVersion=v0.1"];
            
            return;
            
//            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//            NSString *htmlPath = @"https://rc1newm.cashnice.com/wpay/return/service_name/create_hosting_collect_trade?sinaPnsVersion=v0.1";
//            NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]];
//            [webView loadRequest:rq];
//            webView.delegate = self;
//            [self.view addSubview:webView];
            
//            JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//            FunTest *test = [FunTest new] ;
//            context[@"jsAndroid"] = test;
#endif
        }
            break;
        default:
            break;
    }
}

- (UITableView *)tableView{
    if (! _tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



@end
