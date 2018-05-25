//
//  WebViewController.m
//  Haen
//
//  Created by zengyuan on 16/6/15.
//  Copyright © 2016年 ;. All rights reserved.
//

#import "WebViewController.h"
#import "BrokenNetworkView.h"

@interface WebViewController ()<WKNavigationDelegate>
@property(nonatomic, strong) BrokenNetworkView *netView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    
    [self initWebView];
    
    //网络不给力
    if (![UtilDevice isNetworkConnected]){
        [self showNetView];
    }else{
        [self loadRequest];
    }

    self.title = self.atitle;

    //prevent loading too long time
    [self performSelector:@selector(cancelProgress) withObject:nil afterDelay:10];
    
}

-(void)initWebView{
    if (self.webVIewConfiguration) {
        self.webVIew = [[WKWebView alloc]initWithFrame:CGRectZero configuration:self.webVIewConfiguration];
    }else{
        self.webVIew = [[WKWebView alloc]init];
    }
    self.webVIew.navigationDelegate = self;
    [self.view addSubview:self.webVIew];

    UIView *superView = self.view;
    [self.webVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(superView.mas_bottom);
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
///KVO 
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webVIew) {
            self.title = self.webVIew.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelProgress) object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (self.parameterizedTitle) {
        //添加观察者
        [self.webVIew addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.parameterizedTitle) {
        [self.webVIew removeObserver:self forKeyPath:@"title"];
    }
}

-(void)cancelProgress{
    progress_hide
}

-(void)removeNoNetwork{
    if(self.netView){
        [self.netView removeFromSuperview];
        self.netView = nil;
    }
}

-(void)loadRequest{
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    
    NSLog(@"%@", url);

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
        self.netView.width = self.view.width;
        self.netView.height = self.view.height;
//        UIView*superView = self.view;
//        [self.netView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.width.equalTo(superView);
//            make.top.equalTo(self.mas_topLayoutGuideBottom);
//            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
//
//        }];
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    progress_show
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    progress_hide

    if ([UtilDevice webViewFailCausedByNetwork:error]) {
        [self showNetView];
        return;
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self removeNoNetwork];
    progress_hide
    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    progress_hide
}


- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    progress_hide
}


- (void)customNavBackPressed{
    
    if (self.webVIew.canGoBack) {
        [self.webVIew goBack];
    }else{
        [super customNavBackPressed];
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
