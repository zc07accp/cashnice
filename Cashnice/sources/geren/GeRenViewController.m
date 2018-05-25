//
//  GeRenViewController.m
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//
//#import "EditUserProfile.h"
#import "GeRenViewController.h"
#import "PersonInfo.h"
#import "GeRenTableViewCell.h"
#import "NewInstruction.h"
#import "Jiekuan1.h"
#import "Jiekuan2.h"
#import "Jiekuan3.h"
#import "ChongzhiViewController.h"
#import "SettingViewController.h"
#import "BillNewViewCtrl.h"
#import "WebDetail.h"
#import "NewIdEdit.h"
#import "NewNewShenFen.h"
#import "ServiceMessageViewController.h"
#import "BillViewController.h"
#import "ShareWXFriendsViewController.h"
#import "ShareView.h"
#import "SocietyPositionViewController.h"
#import "MyInvestmentsListViewController.h"
#import "MyLoansListViewController.h"
#import "GuaranteeListViewController.h"
#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"
#import "SinaCashierDemoViewController.h"
#import "UpdateManager.h"
#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"
#import "UnlockTestViewController.h"
#import "LocalAuthen.h"
#import "UIImage+FEBoxBlur.h"
#import "CustomPromptAlertView.h"
#import "GestureUnlockContainerView.h"
#import "LocalViewGuide.h"
#import "GetUserInfoEngine.h"
#import "SystemOptionsEngine.h"
#import "MeRouter.h"
#import "SelRedMoneyViewController.h"
#import "MeNextGetMoneyView.h"
#import "InvestmentCalendarViewController.h"
#import "SmartBidViewController.h"
#import "LicenseUploadViewController.h"

@interface GeRenViewController () <HandleCompletetExport>{
    
    NSDate *lastDate;
    UIButton *backBtn;
}

@property (weak, nonatomic) IBOutlet UILabel *           personQianMingPlaceholder;
@property (strong, nonatomic) NSArray *                  rowNumInSection;
@property (strong, nonatomic) NSArray *                  rowNameArray;
@property (weak, nonatomic) IBOutlet UITableView *       table;
@property (weak, nonatomic) IBOutlet UIScrollView *      scroll;
@property (strong, nonatomic) PersonInfo *               geren;
@property (strong, nonatomic) ChongzhiViewController*    chongzhi;
@property (strong, nonatomic) MKNetworkOperation *       op;
@property (strong, nonatomic) HeadImageView             *headView;

//@property (strong, nonatomic) UIView                    *titleView;
@property (strong, nonatomic) UILabel                   *vLabel;
@property (strong, nonatomic) UILabel                   *user_titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_button_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_info_height;
@property (strong, nonatomic) IBOutlet UIView* gerenView;
@property (strong, nonatomic) IBOutlet UIView* stateView;


@property (weak, nonatomic) IBOutlet UILabel *investmentNum;
@property (weak, nonatomic) IBOutlet UILabel *loansNum;
@property (weak, nonatomic) IBOutlet UILabel *guarNum;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemLabels;

@property (weak, nonatomic) IBOutlet UIView *yueryouxiCoverView;
@property (weak, nonatomic) IBOutlet UIView *zhuanzhangCoverView;
@property (weak, nonatomic) IBOutlet UIView *smartBidCoverView;

@property (weak, nonatomic) IBOutlet UIView *calendarView;

@property (strong, nonatomic) GetUserInfoEngine *userInfoEngine;
@property (strong, nonatomic) SystemOptionsEngine *s_engine;
@property (strong, nonatomic) MeNextGetMoneyView *mngmview;
@property (weak, nonatomic) IBOutlet UIView *meNextGetMoneyBKView;

@property (weak, nonatomic) IBOutlet UILabel *lastestReceivableVal; //最近一笔应收投资金额

@property (weak, nonatomic) IBOutlet UILabel *lastestReceivableValUnit;
@property (strong, nonatomic) UIView *fakeView;

@property (strong, nonatomic) UIView *headerTopView;

@end


@implementation GeRenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.backgroundColor = [UIColor clearColor];
    
    [Util setScrollHeader:self.scroll target:self header:@selector(rhManual) dateKey:[Util getDateKey:self]];
    
    self.investmentNum.text =
    self.loansNum.text =
    self.guarNum.text = @"  ";
    
    self.investmentNum.font =
    self.loansNum.font =
    self.guarNum.font = [UtilFont systemBold:24];
    
    for (UILabel *l in self.itemLabels) {
        //l.font = [UtilFont systemLarge];
        l.font = CNFontNormal;
        l.textColor = CN_TEXT_GRAY_9;
    }
  
    [self setTransferEntranceState:ZAPP.myuser.showTransferEntrance];

    if (!IPHONE4S) {
        //隐藏浮层
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.1];
    }
    
//    //为了解决导航条的区域不够的
//    self.fakeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
//    [self.view addSubview:self.fakeView];
//    self.fakeView.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
//    UIButton*btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
//    [self.fakeView addSubview:btnLeft];
//    [btnLeft addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton*btnCenter = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-50, 0, 100, 40)];
    [self.fakeView addSubview:btnCenter];
    [btnCenter addTarget:self action:@selector(tapHeader) forControlEvents:UIControlEventTouchUpInside];

//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self mngmview];
  
    [self.view addSubview:self.headerTopView];
    self.fd_prefersNavigationBarHidden = YES;
}


-(void)dealloc{
}

-(GetUserInfoEngine *)userInfoEngine{
    
    if (!_userInfoEngine) {
        _userInfoEngine = [[GetUserInfoEngine alloc]init];
    }
    return _userInfoEngine;
}

-(UIView*)headerTopView{
    
    if (!_headerTopView) {
        _headerTopView = [[UIView alloc]init];
        _headerTopView.frame = CGRectMake(0, 0, self.view.width, 100);
        _headerTopView.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
        
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(10, 30, 40, 40);
        [_headerTopView addSubview:backBtn];

        if (!self.headView.superview) {
            [_headerTopView addSubview:self.headView];
        }

        [_headView addSubview:self.vLabel];
        [self.vLabel.superview bringSubviewToFront:self.vLabel];
        
        UserLevelType x = [ZAPP.myuser getUserLevel];
        self.vLabel.hidden =  !(x == UserLevel_VIP);
        NSLog(@"vLabel.superview = %@, _headView = %@",self.vLabel.superview, _headView);
        
        
        if (!self.user_titleLabel.superview) {
            [self.headerTopView addSubview:self.user_titleLabel];
        }
        self.user_titleLabel.text = [Util getUserRealNameOrNickName:[ZAPP.myuser gerenInfoDict]];
        
    }
    return _headerTopView;
}


-(SystemOptionsEngine *)s_engine{
    
    if (!_s_engine) {
        _s_engine = [[SystemOptionsEngine alloc]init];
    }
    return _s_engine;
}

-(MeNextGetMoneyView *)mngmview{
    
    if (!_mngmview) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeNextGetMoneyView" owner:self options:nil];
        _mngmview  = nib[0];
        [self.meNextGetMoneyBKView addSubview:_mngmview];
    }
    return _mngmview;
}

-(void)delay{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rec = [self.smartBidCoverView.superview convertRect:self.smartBidCoverView.frame toView:window];
    
    ZAPP.lvg = [[LocalViewGuide alloc]init];
//    ZAPP.lvg.reltivShow2Rect = rec;
    [ZAPP.lvg showSmartBid:rec];
    
    
}

- (IBAction)DetailItemAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            //我的投资
            MyInvestmentsListViewController *jie =  ZINVST(@"MyInvestmentsListViewController");
            [self.navigationController pushViewController:jie animated:YES];
            //            Jiekuan2 *jie = ZJIEKUAN(@"Jiekuan2");
            break;

        }
        case 2:
        {
            //我的借款
            //            Jiekuan3 *jie = ZJIEKUAN(@"Jiekuan3");
            MyLoansListViewController *jie = ZLOAN(@"MyLoansListViewController");
            [self.navigationController pushViewController:jie animated:YES];
            break;
        }
        case 3:
        {
            //我的担保
            //            Jiekuan1 *jie = ZJIEKUAN(@"Jiekuan1");
            UIViewController *jie = ZGUARANTEE(@"GuaranteeListViewController");
            [self.navigationController pushViewController:jie animated:YES];
            
            break;
        }
        case 4:
        {
            //我的账单
            BillViewController *bill = ZBill(@"BillViewController");
            [self.navigationController pushViewController:bill animated:YES];
            break;
        }
        case 5:
        {
            [self.navigationController pushViewController:[MeRouter newPersonDetailViewController] animated:YES];
            break;
            
        }
        case 6:
        {
            //管理银行卡
            
            if ([ZAPP.myuser hasBankCardNumber]) {
                //已经绑卡
                __weak id weakSelf = self;
                SinaCashierModel *model = [[SinaCashierModel alloc] init];
                progress_show
                [model bankCardManagementWithsuccess:^(NSString *URL, NSData *Content) {
                    progress_hide
                    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
                    web.URLPath = URL;
                    web.titleString = @"管理银行卡";
                    web.completeHandle = weakSelf;
                    [self.navigationController pushViewController:web animated:YES];
                } failure:^(NSString *error) {
                    progress_hide
                }];
                break;
            }else{
                //UIViewController *vc =  ZBANK(@"AddingCardViewController");
                [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
                break;
            }
        }
        case 7:
        {
            //CertificatePreviewViewController *x = [[CertificatePreviewViewController alloc] init];
            //x.isDebter = YES;
            //x.userPerationEnabled = YES;
            
            //SinaCashierDemoViewController *x1 = [[SinaCashierDemoViewController alloc] init];
            //[self.navigationController pushViewController:x1 animated:YES];
            //return;
            
//#ifdef TEST_TEST_SERVER
//            UIViewController *vc =  ZSTORY(@"BindBankOneStepViewController");
//            [self.navigationController pushViewController:vc animated:YES];
////            CustomPromptAlertView *alertView = [[CustomPromptAlertView alloc] initWithTitle:@"提示" andInfo:CNLocalizedString(@"alert.message.qrScanError", nil)];
////            [alertView show];
//            break;
//#endif
            
            /*//用户指南
             NewInstruction *x = ZSTORY(@"NewInstruction");
             */
            //智能投标
            SmartBidViewController *x = [[SmartBidViewController alloc]init];
            [self.navigationController pushViewController:x animated:YES];
            break;
        }
        case 8:
        {
            //余额有息
            UIViewController *vc = MYINFOSTORY(@"MyRemainMoneyInterestViewController");
            [self.navigationController pushViewController:vc animated:YES];
            break;

        }
            
        case 9:
        {
            //转账
            UIViewController *x = ZPERSON(@"TransferIndexViewController");
            [self.navigationController pushViewController:x animated:YES];;
            break;
            
        }
            
        default:
            break;
    }
}

- (void)complete {
    
    POST_VISABANK_FRESH_NOTI
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rhManual {
    [self connectToServer];
}

- (void)rh {
    //[self connectToServer];
    [self.scroll.header beginRefreshing];
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

- (void)setData {
    [self.scroll.header endRefreshing];
    [self ui];
    [Util saveHeadImgUrl:[[ZAPP.myuser gerenInfoDict] objectForKey:NET_KEY_HEADIMG]];
}
//
//- (void)loseData {
//    [self.scroll.header endRefreshing];
//}


-(void)cancleRequest{
    
    [self.op cancel];
    self.op = nil;
    
    [self.scroll.header endRefreshing];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [MobClick endLogPageView:@"个人中心"];
    [self cancleRequest];
    //	[self.op cancel];
    //	self.op = nil;
    //	[self loseData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.scroll.header endRefreshing];
    [self.scroll.footer endRefreshing];
    
    
    
//    [self remove];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];

//    [self remove];
}

//-(void)remove{
//    
//    if (_vLabel.superview) {
//        _vLabel.hidden = YES;
//        [_vLabel removeFromSuperview];
//        _vLabel = nil;
//    }
//
//    if([_headView superview]){
//        _headView.hidden = YES;
//        [_headView removeFromSuperview];
//        _headView = nil;
//        NSLog(@"_headView removeFromSuperview");
//    }
//    
//    
//    if([_user_titleLabel superview]){
//_user_titleLabel.hidden = YES;
//    [_user_titleLabel removeFromSuperview];
//    _user_titleLabel = nil;
//    }
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
    [self.navigationController setNavigationBarHidden:YES];
    [self rhManual];
    [self ui];

    [self requestTransferEntrance];

//    NSLog(@"........ %.2f",self.calendarView.height + self.calendarView.origin.y + 20);
//    NSLog(@"........ %.2f",self.scroll.origin.y);
    self.scroll.contentSize = CGSizeMake(self.scroll.width, 520);
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
}


-(void)setTransferEntranceState:(BOOL)show{
    //hide transfer btn
    for(UIView *subView in self.zhuanzhangCoverView.subviews){
        
        subView.hidden = show ?NO:YES;
        subView.userInteractionEnabled = show ? YES: NO;
    }
}

-(void)requestTransferEntrance{
    
    WS(weakSelf)
    
    [self.s_engine getUserTransferSwitchComplete:^(BOOL opened) {
        [weakSelf setTransferEntranceState:opened];
    }];
    
}

- (UILabel *)user_titleLabel {
    if (! _user_titleLabel) {
//        _user_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 14+26, 100, 30)];
        _user_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2+10, _headView.center.y-15, 100, 30)];
        _user_titleLabel.left = self.headView.right + 4;
        _user_titleLabel.textColor = [UIColor whiteColor];
        _user_titleLabel.font = [UIFont systemFontOfSize:20.0f];
        _user_titleLabel.textAlignment = NSTextAlignmentLeft;

    }
    return _user_titleLabel;
}

- (UILabel *)vLabel{
    if (! _vLabel) {
        CGFloat vLableWidth = [ZAPP.zdevice getDesignScale:22];
        _vLabel = [[UILabel alloc]initWithFrame:CGRectMake(60-vLableWidth, 60-vLableWidth, vLableWidth, vLableWidth)];
        
        _vLabel.layer.cornerRadius = vLableWidth/2;
        _vLabel.layer.masksToBounds = YES;
        _vLabel.backgroundColor = ZCOLOR(COLOR_BILL_BG_YELLOW);
        _vLabel.font = [UtilFont systemLargeNormal];
        _vLabel.textColor = [UIColor whiteColor];
        _vLabel.textAlignment = NSTextAlignmentCenter;
//        _vLabel.bottom = self.headView.height;
//        _vLabel.right = self.headView.width;
        _vLabel.text = @"V";
    }
    return _vLabel;
}

//- (UIView *)titleView{
//    if (! _titleView) {
//        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0,-10,160,90)];
//        [_titleView setBackgroundColor:[UIColor clearColor]];
//
//        
//        [_titleView addSubview:self.vLabel];
//  
//        [self.navigationController.navigationBar addSubview:self.user_titleLabel];
////        [_titleView addSubview:self.user_titleLabel];
//    }
//    return _titleView;
//}

- (HeadImageView *)headView{
    if (! _headView) {
//        _headView = [[HeadImageView alloc]initWithFrame:CGRectMake(0, 26, 60, 60)];
        _headView = [[HeadImageView alloc]initWithFrame:CGRectMake(self.navigationController.navigationBar.width/2-60, backBtn.center.y-20, 60, 60)];
        
//        self.titleView.backgroundColor = [UIColor redColor];
        _headView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader)];
        [_headView addGestureRecognizer:tap];
        
    }
    return _headView;
}
//
//- (HeadImageView *)fakeheadView{
//    if (! _fakeheadView) {
//        
//        _fakeheadView = [[HeadImageView alloc]initWithFrame:CGRectMake(self.view.width/2-60, -30, 60, 60)];
//
////        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        
////        _fakeheadView = [[HeadImageView alloc]initWithFrame:CGRectMake(0, 26, 60, 60)];
//        
//        [self.fakeView addSubview:_fakeheadView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader)];
//        [_fakeheadView addGestureRecognizer:tap];
//        
//    }
//    return _fakeheadView;
//}
//



-(void)tapHeader{
    [self.navigationController pushViewController:[MeRouter newPersonDetailViewController] animated:YES];

}

- (void)settingAction{
    //设置
    UIViewController *setting = ZPERSON(@"SettingViewController");
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rh) name:MSG_login_to_server_suc object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popWaringView) name:MSG_system_service_updating object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWaringView) name:MSG_system_service_recovery object:nil];
    
    if ([ZAPP.zlogin isLogined]) {
        [self rhAppear];
    }
    [self ui];
}

- (void)connectToServer {
    [self.op cancel];
    bugeili_net
    
    lastDate = [NSDate date];
    
    WS(weakSelf)

    [self.userInfoEngine getUserInfoSuccess:^{
        [weakSelf setData];
        UpdateAndSharedTrigger
    } failure:^(NSString *error) {
        [weakSelf.scroll.header endRefreshing];
        
    }];
    
    
}

- (void)ui {
    NSDictionary *dict       = [ZAPP.myuser gerenInfoDict];
    BOOL shouldHide = (dict == nil);
    self.view.hidden          = NO;
    self.scroll.hidden = NO;
    self.gerenView.hidden = shouldHide;
    self.geren.view.hidden    = shouldHide;
    self.chongzhi.view.hidden = shouldHide;
    self.table.hidden         = NO;
    [self.geren setTheInfoDict:dict];
    [self.chongzhi setTheData:dict];
    

    self.investmentNum.text = [NSString stringWithFormat:@"%d", [[dict objectForKey:NET_KEY_BETCOUNT] intValue]];
    self.loansNum.text = [NSString stringWithFormat:@"%d", [[dict objectForKey:NET_KEY_LOANCOUNT] intValue]];
    self.guarNum.text = [NSString stringWithFormat:@"%d", [[dict objectForKey:NET_KEY_GUARANTEEVAL] intValue]];
    
    [self.headView setHeadImgeUrlStr:[[ZAPP.myuser gerenInfoDict] objectForKey:NET_KEY_HEADIMG]];

    
    self.user_titleLabel.text = [Util getUserRealNameOrNickName:[ZAPP.myuser gerenInfoDict]];//[[ZAPP.myuser gerenInfoDict] objectForKey:NET_KEY_USERREALNAME];
    UserLevelType x = [ZAPP.myuser getUserLevel];
    if (x == UserLevel_VIP) {
        self.vLabel.hidden = NO;
    }else{
        self.vLabel.hidden = YES;
    }
    
//    //$
//    self.vLabel.hidden = NO;
    
    NSString* lastestreceivabletime = EMPTYSTRING_HANDLE([dict objectForKey:@"lastestreceivabletime"]) ;
    
    NSString* lastestreceivableval = [Util formatRMBWithoutUnit:EMPTYOBJ_HANDLE([dict objectForKey:@"lastestreceivableval"])];
    
    if ([lastestreceivabletime length] == 0) {
        _mngmview.infoLabel.text = @"日历";
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSString*temp=[formater stringFromDate:[NSDate date]];
        _mngmview.fullDateStr = temp;
        _lastestReceivableVal.hidden=YES;
        _lastestReceivableValUnit.hidden = YES;

    }else{
        _mngmview.infoLabel.text = @"下次收款";
        _mngmview.fullDateStr = lastestreceivabletime;
        _lastestReceivableVal.hidden=NO;
        _lastestReceivableValUnit.hidden = NO;

    }
    

    self.lastestReceivableVal.text = lastestreceivableval;
}

- (void)popWaringView {
    [self.scroll adjustState:YES parent:self];
}

- (void)dismissWaringView {
    [self.scroll adjustState:NO parent:self];
}

- (NSArray *)rowNumInSection {
    if (_rowNumInSection == nil) {
        NSMutableArray *numarr = [NSMutableArray array];
        for (int i = 0; i < self.rowNameArray.count; i++) {
            [numarr addObject:@([[self.rowNameArray objectAtIndex:i] count])];
        }
        _rowNumInSection = [NSArray arrayWithArray:numarr];
    }
    return _rowNumInSection;
}

- (NSArray *)rowNameArray {
    if (_rowNameArray == nil) {
        _rowNameArray = @[@[@"我的投资",@"我的借款",@"我授信的借款", @"管理/绑定银行卡", @"我的资料", @"我的账单"], @[@"设置"]];
        
    }
    return _rowNameArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rowNumInSection.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.rowNumInSection objectAtIndex:section] integerValue];
}
- (BOOL)lastRow:(NSIndexPath *)indexPath {
    return indexPath.row == [[self.rowNumInSection objectAtIndex:indexPath.section] integerValue] - 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:TABLE_TEXT_ROW_HEIGHT];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:10];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor        = [UIColor clearColor];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeRenTableViewCell *cell;
    static NSString *   CellIdentifier = @"cell";
    cell                = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.sepLine.hidden = [self lastRow:indexPath];
    
    cell.biaoti.text = [[self.rowNameArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    int offset = 1;
    
    cell.detail.hidden = (indexPath.section != (1 - offset));
    if (indexPath.section == (1 - offset)) {
        int num  = 0;
        NSDictionary *dict = [ZAPP.myuser gerenInfoDict];
        if (indexPath.row == 0) {
            num = [[dict objectForKey:NET_KEY_BETCOUNT] intValue];
        }
        else if (indexPath.row == 1) {
            num = [[dict objectForKey:NET_KEY_LOANCOUNT] intValue];
        }
        else if (indexPath.row == 2) {
            num = [[dict objectForKey:NET_KEY_GUARANTEEVAL] intValue];
        }
        else {
            num = -1;
        }
        if (num == -1) {
            cell.detail.text = @"";
        }
        else {
            cell.detail.text = [NSString stringWithFormat:@"%d", num];
        }
    }
    else {
        cell.detail.text = @"";
    }
    
    cell.arrow.hidden = indexPath.section == 4;
    
    
    return cell;
}

//- (void)editUserProfile {
//    
//    [self.navigationController pushViewController:[MeRouter newPersonDetailViewController] animated:YES];
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if (alertView.tag == 9) {
            [ZAPP loginout];
        }
    }
}


- (void)neweditshenfen {
    //我的资料 认证资料
    //NewNewShenFen *e = ZEdit(@"NewNewShenFen");
    //[self.navigationController pushViewController:e animated:YES];
}

- (void)xinshouzhinan {
    NewInstruction *x = ZSTORY(@"NewInstruction");
    [self.navigationController pushViewController:x animated:YES];
}

//- (IBAction)editUserDataPressed {
////    [self editUserProfile];
//}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[PersonInfo class]]) {
        [self.geren setIsNotMe:NO];
        self.geren = ((PersonInfo *)[segue destinationViewController]);
    }
    else if ([[segue destinationViewController] isKindOfClass:[ChongzhiViewController class]]) {
        self.chongzhi = ((ChongzhiViewController*)[segue destinationViewController]);
    }
}


-(void)cap{
    
//    UIViewController *dztar=self.navigationController;
   
    
    /*
     UITabBarController *dztar=self.tabBarController;
     
     ParentController *pusher=[self.viewControllers objectAtIndex:[self.viewControllers count]-1];
     UIViewController *capture= pusher.isInTabbarController? dztar:self;
     */
    
    //opaque 一定要设置为NO
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *screenWindow = appDelegate.window;
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [CIImage imageWithCGImage:img.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        //设置模糊程度
        [filter setValue:@15.0f forKey: @"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGRect frame = [ciImage extent];
        NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
        UIImage * blurImage = [UIImage imageWithCGImage:outImage];
        dispatch_async(dispatch_get_main_queue(), ^{
//            coreImgv.image = blurImage;
            
            UIImageView*imgView = [[UIImageView alloc]initWithFrame:screenWindow.bounds];
            imgView.image = blurImage;
            imgView.contentMode = UIViewContentModeScaleToFill;
            [[UIApplication sharedApplication].keyWindow addSubview:imgView];

//            UIImageWriteToSavedPhotosAlbum(blurImage, nil, nil, nil); //将截图存入相册

        });
    });
    
//    UIImage*newImg = [UIImage coreBlurImage:img withBlurNumber:10];
//    UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil); //将截图存入相册
//
    
}


- (IBAction)seeInvestCalendar:(id)sender {
    InvestmentCalendarViewController *cal = ZPERSON(@"InvestmentCalendarViewController");
    [self.navigationController pushViewController:cal animated:YES];
}



@end
