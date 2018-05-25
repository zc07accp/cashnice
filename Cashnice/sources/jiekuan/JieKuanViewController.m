//
//  JieKuanViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "JieKuanViewController.h"
#import "JiekuanTableViewCell.h"
#import "PersonHomePage.h"
#import "QuerenTouzi.h"
#import "AllShouxinPeople.h"
#import "CashniceLoanTableViewCell.h"
#import "WeiXinEngine.h"
#import "InvestmentFPDetailViewController.h"
#import "InvestmentAction.h"
#import "NoticeManager.h"
#import "GetUserInfoEngine.h"
#import "BILLWebViewUtil.h"
#import "JieKuanUtil.h"
#import "UpdateManager.h"
#import "RealReachability.h"
#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"
#import "LoanEngine.h"
#import "SystemOptionsEngine.h"
#import "EScrollerView.h"
#import "BannerWebViewController.h"
#import "GeTuiSdk.h"
#import "CustomActivityView.h"
#import "CouponNetEngine.h"
#import "RedMoneyListViewController.h"
#import "WebDetail.h"
#import "CouponGiftViewController.h"
#import "ScoreWebViewController.h"
#import "ContactMgr.h"
#import "HistoryPageContainerViewController.h"
#import "CNServiceWarningViewFactory.h"
#import "ServiceMsgEngine.h"

static CGFloat const SCROLLVIEW_BANNER_HEIGHT = 45;

@interface JieKuanViewController () <CashniceLoanTableViewCell,EScrollerViewDelegate, CustomActivityViewDelegate, CouponJSHandleExport, CNWarningViewDelegate, CouponJSHandleExport>
{
    NSInteger rowCnt;
    NSInteger rowHeight;
    
    int curPage;
    int pageCount;
    int totalCount;
    
    NSDate *lastDate;
    
//    BOOL showESView;
    CGFloat esViewHeight;
    
    CGFloat warningViewHeight;
    
    NSArray *bannerArr;
    
//    BOOL hasReuest
    
//    double _balanceVal;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

//@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) GetUserInfoEngine *engine;
@property (strong, nonatomic) LoanEngine *loan_engine;
@property (strong, nonatomic) SystemOptionsEngine *s_engine;
@property (strong, nonatomic) ServiceMsgEngine *notice_engine;
@property (strong, nonatomic) EScrollerView *esView;
@property (strong, nonatomic) CustomActivityView *activityView;

@property (strong, nonatomic) CustomActivityView *currentActivityView;
@property (strong,nonatomic) ContactMgr *contactMgr;

@property (strong, nonatomic) CNWarningView *warningView;


@property (strong, nonatomic) NSDictionary *noticeDict;

//@property (strong, nonatomic) NSMutableArray *willLoadViewArray;

@end

@implementation JieKuanViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    
    
    self.table.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    //self.table.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.table.header.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    
//    showESView = YES;
    
    rowCnt = 0;
    curPage = 0;
    pageCount = 0;
    rowHeight = 196;
    esViewHeight = MainScreenWidth *(1.0/3.16);
    warningViewHeight = [ZAPP.zdevice getDesignScale:20];

    [Util setScrollHeader:self.table target:self header:@selector(rhManual:) dateKey:[Util getDateKey:self]];
    [Util setScrollFooter:self.table target:self footer:@selector(rf)];
    
    
//    for (UIView *view in self.navigationItem.titleView.subviews)
//    {
//        if(view)
//        {
//            [view removeFromSuperview];
//        }
//    }
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,32,44)];
//    [titleView setBackgroundColor:[UIColor greenColor]];
//    self.navigationItem.titleView = titleView;

//    self.title = @"投资";
//    [self setLeftNavLogo];
    
    [self setNavRightBtn];
    [self setTitleLogo];

    WS(weakSelf)
    [self.engine getUserInfoSuccess:^{
        DDLogInfo(@"getUserInfoSuccess ok");
        
        //注册个推别名
        //NSString *alias = ZAPP.myuser.gerenInfoDict[@"p2paccount"];
        [GeTuiSdk bindAlias:ZAPP.myuser.gerenInfoDict[@"p2paccount"] andSequenceNum:@"alias"];
        
        [weakSelf.s_engine getVISASuccess:^{
            
        } failure:^(NSString *error) {
            
        }];
        
        [weakSelf.s_engine getUserIdentifyProgressSuccess:^{
        } failure:^(NSString *error) {
            
        }];
        
        [weakSelf.s_engine getUserTransferSwitchComplete:^(BOOL opened) {
            
        }];
        
    } failure:^(NSString *error) {
        
    }
     ];
    
    //读取本地banner数据
    [self updateBannerUI:[self.s_engine readLocalBannerData]];
    //读取本地列表数据
    [self updateUI: [self.loan_engine readlocalData]];
    
    //请求新的banner
    [self requestBanner];
    
    //刷取账号余额
    //[self refreshVanlance];

    //请求授权
    [ContactMgr requestAuthen:^(BOOL authened){
        if (authened) {
            //上传通讯录
            [self.contactMgr uploadContacts:nil];
        }
    }];
    
}
#pragma --新添加

- (void)actionb{
    [self popWaringView];
}
#pragma --新添加
- (void)actionc{
    [self.table adjustState:NO parent:self];
    [self dismissWaringView];
}


- (void)warningViewAction{
    
    NSString *url = EMPTYSTRING_HANDLE(_noticeDict[@"jump_url"]);
    if(_noticeDict && url.length > 0){
        WebDetail *x = ZSTORY(@"WebDetail");
        x.userAssistantPath = @{@"name" : @"消息详情"};
        x.absolutePath =  [NSString stringWithFormat:@"%@%@" ,WEB_DOC_URL_ROOT, url];
        [self.navigationController pushViewController:x animated:YES];
        
    
        [self.notice_engine setNoticeRead:[_noticeDict[@"noticeid"] integerValue] success:^{
            
        } failure:^(NSString *error) {
            
        }];
    }
}

- (void)getNotice{
    [self.notice_engine getNoticeWithSuccess:^(NSDictionary * dict) {
        self.noticeDict = dict;
    } failure:^(NSString *error) {
        ;
    }];
}

- (void)setNoticeDict:(NSDictionary *)noticeDict{
    if (noticeDict) {
        _noticeDict = noticeDict;
        
        //Message
        NSString *msg = noticeDict[@"message"];
        self.warningView.externelTitle = msg;
        
        [self showWarningView];
    }
}

-(ContactMgr *)contactMgr{
    
    if(!_contactMgr){
        _contactMgr = [[ContactMgr alloc]init];
    }
    return _contactMgr;
}


-(void)setTitleLogo{
    
    
#ifndef HUBEI
    
    //Left
    UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth320?80:120, 18)];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
#else
    
    //Left
    UIView *containerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 34)];
    
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hb_logo"]];
    
#endif
    
    logo.frame = containerView2.bounds;
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [containerView2 addSubview:logo];
    containerView2.backgroundColor = [UIColor clearColor];

    self.navigationItem.titleView = containerView2;
    
}

-(void)setNavRightBtn{
    self.isRightNavBtnBorderHidden = YES;
    [super setNavRightBtn];
    
    self.rightNavBtn.left = 23;
    self.rightNavBtn.width = 22;
    self.rightNavBtn.height = 22;
    self.rightNavBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightNavBtn setBackgroundImage:[UIImage imageNamed:@"qiandao_"] forState:UIControlStateNormal];
}

-(void)rightNavItemAction{
    
    NSString *httpPrefix = @"";
    if (USESSL) {
        httpPrefix = @"https://";
    }else{
        httpPrefix = @"http://";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@", [YQS_SERVER_URL rangeOfString:httpPrefix].location == NSNotFound?httpPrefix:@"", YQS_SERVER_URL, @"/score/index/user_id/",[ZAPP.myuser getUserID]];
    
    [self pushScoreVC:url];
}

-(void)pushScoreVC:(NSString *)url{
    ScoreWebViewController *swvc = [[ScoreWebViewController alloc]init];
    swvc.urlStr = url;
    [self.navigationController pushViewController:swvc animated:YES];
}

- (void)loadActivityView{
    
    
    [[[CouponNetEngine alloc] init] getPopCouponSuccess:^(NSString * url) {
        
        //CustomActivityView *view = [[CustomActivityView alloc] init];
        //self.willLoadViewArray = [urls mutableCopy];
        if (url.length > 0) {
            [self.activityView addViewWithWebUrl:url];
        }
        
        /*
        for (NSString* url in urls) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    [view addViewWithWebData:data];
                });
            });
            
        }
        */
    } failure:^(NSString *error) {
        ;
    }];
    
    
    //NSArray *urls = @[@"https://newm.cashnice.com/",@"http://www.baidu.com", @"http://www.taobao.com"];
    
    //NSArray *urls = @[@"https://newm.cashnice.com/", @"http://www.taobao.com"];
    
    //NSArray *urls = @[@"https://newm.cashnice.com/"];
    
    //[view show];
}

- (void)activityViewDidClose:(id)view {
   
    self.activityView = nil;
    
}
//
//- (void)activityView:(id)view willGoWeb:(NSString *)webUrl{
//    
//    CouponGiftViewController *wvc = [[CouponGiftViewController alloc]init];
//    wvc.urlStr = webUrl;
//    wvc.atitle = @"转赠";
//    
//    [ZAPP.tabViewCtrl.selectedViewController pushViewController:wvc animated:YES];
//    if ([view respondsToSelector:@selector(close)]) {
//        [view performSelector:@selector(close)];
//    }
//}

- (void)activityView:(id)view willGoWeb:(NSString *)webUrl title:(NSString *)title{

    /*
     WebDetail *webVC = ZSTORY(@"WebDetail");
     webVC.userAssistantPath = @{@"name" : @"转赠"};
     webVC.absolutePath = [NSString stringWithFormat:@"%@", webUrl];
     [self.navigationController pushViewController:webVC animated:YES];
     */
    CouponGiftViewController *wvc = [[CouponGiftViewController alloc]init];
    wvc.urlStr = webUrl;
    if ([title length] > 0) {
        wvc.atitle = title;
    }else{
        wvc.atitle = @"转赠";
    }
    wvc.parameterizedTitle = YES;
    
    [ZAPP.tabViewCtrl.selectedViewController pushViewController:wvc animated:YES];
    if ([view respondsToSelector:@selector(close)]) {
        [view performSelector:@selector(close)];
    }
}

- (void)activityView:(id)view willGoNative:(NSInteger)native {
    
    //goNative(1) 我的红包
    //goNative(2) 加息券
    if (1 == native) {
        //NSLog(@"我的红包");
        [self seeRedPacket];
    }else if(2 == native){
        //NSLog(@"加息券");
        [self seeRedInterest];
    }
    
    if ([view respondsToSelector:@selector(close)]) {
        [view performSelector:@selector(close)];
    }
    
}
//红包
- (void)seeRedPacket{
    
    RedMoneyListViewController *vc = REDSTORY(@"RedMoneyListViewController");
    [vc setValue:@(REDMONEY_TYPE_CASH) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

//优惠券
- (void)seeRedInterest{
    
    RedMoneyListViewController *vc = REDSTORY(@"RedMoneyListViewController");
    [vc setValue:@(REDMONEY_TYPE_ALLINTEREST) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showWarningView {
    //-(void):(BOOL)withBanner parent:(UIViewController *)vc bannerView:(UIView *)bannerView
    [self.table adjustState:YES parent:self bannerView:self.warningView];
}

- (void)popWaringView {
    [self.table adjustState:YES parent:self];
}

- (void)dismissWaringView {
    [self.table adjustState:NO parent:self];
}
//
//-(void)goNe{
//    [self.table adjustState:YES parent:self];
//}

-(GetUserInfoEngine *)engine{
    
    if (!_engine) {
        _engine = [[GetUserInfoEngine alloc]init];
    }
    return _engine;
}

-(LoanEngine *)loan_engine{
    
    if (!_loan_engine) {
        _loan_engine = [[LoanEngine alloc]init];
    }
    return _loan_engine;
}

-(SystemOptionsEngine *)s_engine{
    
    if (!_s_engine) {
        _s_engine = [[SystemOptionsEngine alloc]init];
    }
    return _s_engine;
}

-(ServiceMsgEngine *)notice_engine{
    
    if (!_notice_engine) {
        _notice_engine = [[ServiceMsgEngine alloc]init];
    }
    
    return _notice_engine;
}

- (CNWarningView *)warningView{
    if (! _warningView) {
        /*
        _warningView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, warningViewHeight)];
        _warningView.backgroundColor = HexRGB(0xf2f2f2);
        
        UIImage *image = [UIImage imageNamed:@"gonggao.png"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        
        [_warningView addSubview:imgView];
        
        CGFloat padding = [ZAPP.zdevice getDesignScale:10];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(padding * 1.6);
            make.left.equalTo(_warningView.mas_left).mas_offset(padding * 2);
            make.centerY.equalTo(_warningView);
        }];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        
        UILabel *ntcLab = [[UILabel alloc] init];
        ntcLab.font = CNFont(16);
        ntcLab.textColor = HexRGB(0xff0000);
        ntcLab.text = @"【公告】";
        [_warningView addSubview:ntcLab];
        
        [ntcLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).mas_offset(padding/2);
            make.centerY.equalTo(_warningView);
        }];
        
        UILabel *cntLab = [[UILabel alloc] init];
        cntLab.font = CNFont(16);
        cntLab.textColor = HexRGB(0x333333);
        cntLab.text = @"友情提示：投资有风险，请理性参与！";
        [_warningView addSubview:cntLab];
        
        [cntLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ntcLab.mas_right).mas_offset(padding/2);
            make.centerY.equalTo(_warningView);
        }];
        */
        _warningView = [CNServiceWarningViewFactory getViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCROLLVIEW_BANNER_HEIGHT)];
        //_warningView.externelTitle = @"友情提示：投资有风险，请理性参与！";
        _warningView.delegate = self;
    }
    return _warningView;
}

-(EScrollerView *)esView{
    
    if(!_esView){
        _esView = [[EScrollerView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, esViewHeight)];
        _esView.delegate = self;
    }
    
    return _esView;
}

#pragma mark - server

- (void)rhManual : (id)obj {
    
    curPage = 0;
    [self requestBanner];
    [self connectToServer];
}

- (void)rh {
    curPage = 0;
    [self.table.header beginRefreshing];
}

- (void)rhAppear {
    if (lastDate == nil) {
        [self rh];
    }
    else {
        NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:lastDate];
        if (t > UPDATE_TIME_INTERVAL) {
            [self rh];
        }
    }
}

- (void)rf {
    curPage++;
    [self connectToServer];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)updateBannerUI:(NSArray *)arr{
    
    bannerArr = arr;
    if(bannerArr.count){
        [self.esView reloadData:bannerArr];
        [self.esView startRoll:1];
    }else{
        [self.esView stopRoll];
    }
    
    [self.table reloadData];
}

-(void)updateUI:(NSDictionary *)dic{
    
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    curPage = [Util curPage:dic];
    pageCount = [Util pageCount:dic];
    totalCount = [Util totalCount:dic];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = [[dic objectForKey:NET_KEY_LOANCOUNT] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[dic objectForKey:NET_KEY_LOANS]];
    }
    
    rowCnt = [self.dataArray count];
    [self.table.header endRefreshing];
    [self.table.footer endRefreshing];
    
    [self ui];
}

- (CustomActivityView *)activityView{
    if (! _activityView) {
    //只有一个WebView，每次重建
        _activityView = [[CustomActivityView alloc] init];
        _activityView.delegate = self;
        _activityView.jsHandle = self;
    }
    return _activityView;
}

- (void)setData {
    
    //    [self dismissWaringView];
    curPage = [Util curPage:ZAPP.myuser.loanListDict];
    pageCount = [Util pageCount:ZAPP.myuser.loanListDict];
    totalCount = [Util totalCount:ZAPP.myuser.loanListDict];
    
    if (curPage == 0) {
        [self.dataArray removeAllObjects];
    }
    
    int cnt = [[ZAPP.myuser.loanListDict objectForKey:NET_KEY_LOANCOUNT] intValue];
    if (cnt > 0) {
        [self.dataArray insertPage:curPage objects:[ZAPP.myuser.loanListDict objectForKey:NET_KEY_LOANS]];
    }
    
    rowCnt = [self.dataArray count];
    [self.table.header endRefreshing];
    [self.table.footer endRefreshing];
    
    [self ui];
}

- (void)loseData {
    [self.table.header endRefreshing];
    [self.table.footer endRefreshing];
}

- (void)ui {
    
    self.table.footer.hidden = ((curPage + 1) >= pageCount);
    [self.table reloadData];
    
}

-(void)requestBanner{
    DLog();
    
    WS(ws)
    //获取广告位
    [self.esView stopRoll];
    
    [self.s_engine getBannersSuccess:^(NSArray *arr) {
         [ws updateBannerUI:arr];
    } failure:^(NSString *error) {
        //获取数据失败，也要恢复滚动
        [ws startRoll];
    }];
}

-(void)startRoll{
    if(bannerArr.count){
        [_esView startRoll:1];
    }
    
}

- (void)connectToServer {
    //    [self.op cancel];
    [self.loan_engine cancleAllHttpRequest];
    self.loan_engine = nil;
    
    if ([ZAPP.myuser getUserID].length < 1) {
        return;
    }
    
    bugeili_net_new_block(^{
        [self loseData];
    });
    
    if(self.dataArray.count== 0){
        progress_show
    }
    
    lastDate = [NSDate date];
    
    
    WS(ws)
    
    [self.loan_engine getLoanList:curPage pageSize:DEFAULT_PAGE_SIZE success:^(NSDictionary * dic) {
        
        if(ws.dataArray.count== 0){
            progress_hide
        }
        
        [ws updateUI:dic];
        
    } failure:^(NSString *error) {
        
        if(ws.dataArray.count== 0){
            progress_hide
        }
        
        [ws loseData];
    }];
    
    [self getNotice];
    //UpdateTrigger
    [self loadActivityView];
    
    //    self.op =
    //    [ZAPP.netEngine getLoanListWithPageIndex:curPage pagesize:DEFAULT_PAGE_SIZE complete:^{
    //        [ws setData];
    //        progress_hide
    //    } error:^{
    //        [ws loseData];
    //        progress_hide
    //    }];
    
    UpdateAndSharedTrigger
}

/*
- (void)refreshVanlance{
    
    //WS(ws);
    
    if (_balanceVal < 0.001) {
        //progress_show
    }
    
    [ZAPP.netEngine getTransferLimitComplete:^{
        //progress_hide
        NSDictionary *limtDcit = ZAPP.myuser.withdrawLimitRespondDict;
        // 账户余额
        _balanceVal = [limtDcit[@"balance"] doubleValue];
    } error:^{
        //progress_hide;
    }];
}
 */


- (void)systemRegionUpdate:(NSNotification *)ntf{
    [self connectToServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
//    self.title = @"投资";
    
    [self ui];
    [self setNavLeftWarnBadge:[ZAPP.znotice getNtfNum]];

    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_esView stopRoll];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rhManual:) name:MSG_system_region_update object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popWaringView) name:MSG_system_service_updating object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWaringView) name:MSG_system_service_recovery object:nil];
    
    if (curPage == 0) {
        [self connectToServer];
    }else{
        [self getNotice];
        //UpdateTrigger
        [self loadActivityView];
    }

    //这里不要用self.esview
    [self startRoll];
    
    [MobClick beginLogPageView:@"投资首页"];
    
    [ZAPP.znotice load];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"投资首页"];
    
    [self.loan_engine cancleAllHttpRequest];
    self.loan_engine = nil;
    
    [self loseData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self getNotice];
    //UpdateTrigger
    [self loadActivityView];
}

#pragma mark - server end

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return rowCnt+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 0){
        return bannerArr.count?1:0;
    }
    
    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0;
    }
    
    return [ZAPP.zdevice getDesignScale:section-1 ? 10 : 0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    
    return [ZAPP.zdevice getDesignScale:(section == rowCnt) ? 20 : 0];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return esViewHeight;
    }else{
        return [ZAPP.zdevice getDesignScale:rowHeight];
    }

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)touziPressed:(int)rowIndexHere {
    /*
     BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
     if (inBlackList) {
     [Util toastStringOfLocalizedKey:@"tip.enterBlackList"];
     return;
     }
    
    
    if (_balanceVal < 0.001) {  //[ZAPP.myuser hasMoneyInAccount]
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Util getStringInvestWithNoMoney] message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles: @"充值", nil];
        [alert show];
        return;
    } 
    */
    InvestmentAction *t = ZINVSTFP(@"InvestmentAction");
    
    
    if (rowIndexHere - 1 < self.dataArray.count) {
        [t setTheDataDict:[self.dataArray objectAtIndex:rowIndexHere-1]];
        [self.navigationController pushViewController:t animated:YES];
    }

}

- (void)shouxinbuttonPressed:(NSInteger)rowIndexHere {
    AllShouxinPeople *all    = ZSEC(@"AllShouxinPeople");
    
    if (rowIndexHere - 1 < self.dataArray.count) {
        NSDictionary *loanDict = [self.dataArray objectAtIndex:rowIndexHere-1];
        int loanid = [[loanDict objectForKey:NET_KEY_LOANID] intValue];
        [all setLoanID:loanid];
        [all setLoanDict:loanDict];
        [self.navigationController pushViewController:all animated:YES];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (buttonIndex == 1) {
            [self changeTabToGeren];
        }
    }
}

-(void)cashniceLoanGuaranteeAction:(NSIndexPath *)indexPath {
    
    if (indexPath.section-1>=self.dataArray.count) {
        return;
    }
    
    // 抵押用户详情
    NSDictionary *loanDict = self.dataArray[indexPath.section - 1];
    if ([JieKuanUtil isPrivilegedWithLoan:loanDict]) {
        [BILLWebViewUtil presentPrivilegedUserWithViewController:self];
    }else{
        [self shouxinbuttonPressed:indexPath.section ];
    }
}

-(void)cashniceLoanInvestAction:(NSIndexPath *)indexPath {
    [self touziPressed:(int)indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (indexPath.section == 1) {
        
        static NSString *CellIdentifier = @"cell_id_warning";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (!self.warningView.superview) {
                [cell.contentView addSubview:self.warningView];
            }
        }
        
        return cell;
        
    }else
     */
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"cell_id_es";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (!self.esView.superview) {
                [cell.contentView addSubview:self.esView];
            }
        }
        
        return cell;
        
    }else{
        static NSString *cellIdentifier=@"loanListCell";
        CashniceLoanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(cell==nil)
        {
            cell = [[CashniceLoanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.delegate = self;
        NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.section-1];
        [cell updateCellData:dict];
        
        return cell;
    }
}

- (void)nameButtonPressedWithIndex:(int)rowIndexHere {
    NSDictionary *dict = [self.dataArray objectAtIndex:rowIndexHere - 1];
    PersonHomePage *p = DQC(@"PersonHomePage");
    [p setTheDataDict:dict];
    [self.navigationController pushViewController:p animated:YES];
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if(indexPath.section == 0){
        return;
    }
    
    
//    NSLog(@"didSelectRowAtIndexPath");
    //
    //    static BOOL state = NO;
    //
    //    [self.table adjustState:!state parent:self];
    //    state = !state;
    //
    //    return;
    
    InvestmentFPDetailViewController * detail = ZINVSTFP(@"InvestmentFPDetailViewController");
    NSDictionary *loanDict = self.dataArray[indexPath.section - 1];
    
    //    detail.delegate = self;
    detail.loanInfoDict = loanDict;
//    [self.dataArray objectAtIndex:indexPath.section];
    detail.loanid = [loanDict[@"loanid"] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)changeTabToGeren {
    [self.tabBarController setSelectedIndex:4];
}

#pragma mark EScrollerViewDelegate

-(void)EScrollerViewDidClicked:(NSUInteger)index{
   
    
    ShowUnit *showUnit = [bannerArr objectAtIndex:index];
    
    if (showUnit.type == 1) {
        
        if ([showUnit.contentUrl rangeOfString:@"Score" options:NSLiteralSearch].location != NSNotFound) {
            [self pushScoreVC:[self urlAddUserId:showUnit.contentUrl]];
        }else{
            BannerWebViewController *bannervc = [[BannerWebViewController alloc]init];
            bannervc.urlStr = [self urlAddUserId:showUnit.contentUrl];
            bannervc.atitle = showUnit.atitle;
            bannervc.desc = showUnit.desc;
            bannervc.parameterizedTitle = YES;
            
            
            WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
            
            CouponJSHandle *handle = [CouponJSHandle new] ;
            handle.chainedHandle = bannervc;
            [config.userContentController addScriptMessageHandler:handle name:@"continueInvest"];
            [config.userContentController addScriptMessageHandler:handle name:@"close"];
            [config.userContentController addScriptMessageHandler:handle name:@"goWeb"];
            [config.userContentController addScriptMessageHandler:handle name:@"goNative"];
            
            bannervc.webVIewConfiguration = config;
            
            [self.navigationController pushViewController:bannervc animated:YES];
        }
        
        
    }else if(showUnit.type == 2){
        //余额有息
        UIViewController *vc = MYINFOSTORY(@"MyRemainMoneyInterestViewController");
        [self.navigationController pushViewController:vc animated:YES];
        //        break;
    }
    else if(showUnit.type == 3){
        //历史交易
        HistoryPageContainerViewController *hpcvc = [[HistoryPageContainerViewController alloc] init];
        [self.navigationController pushViewController:hpcvc animated:YES];
        
    }

    
    
    
    
    
    
}

- (void)continueInvest{
    [ZAPP changeViewToFirstPage];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSString *)urlAddUserId:(NSString *)url{
    
    if([url rangeOfString:@"?"].location != NSNotFound){
        return [url stringByAppendingFormat:@"&userid=%@", [ZAPP.myuser getUserID]];
    }else{
        return [url stringByAppendingFormat:@"?userid=%@", [ZAPP.myuser getUserID]];
        
    }
    
}


@end
