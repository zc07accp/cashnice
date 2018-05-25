//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "SendLoanViewController.h"
#import "NewBorrowViewController.h"
#import "NoLevel.h"
#import "WebDetail.h"
#import "YaoqingHaoyou.h"
#import "ShouxinList.h"
#import "LoanDistrubuteDetailViewController.h"
#import "RTLabel.h"
#import "AFFNumericKeyboard.h"
#import "LoanDaysCell.h"
#import "CNActionButton.h"
#import "UpdateManager.h"
#import "CNServiceWarningViewFactory.h"
#import "UIScrollView+UIScrollVIew_BannerTipWithMJFresh.h"
#import "ContactMgr.h"
#import "SendLoanEngine.h"
#import "CNServiceWarningViewFactory.h"
#import "SelRedMoneyViewController.h"
#import "SinaCashierWebViewController.h"
#import "NoticeManager.h"
#import "NewLoanProtocolViewController.h"

static CGFloat const SCROLLVIEW_BANNER_HEIGHT = 45;

@interface SendLoanViewController ()<SelRedMoneyDelegate, RTLabelDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,HandleCompletetExport>
{
    CGFloat amountVal;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *creditLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *          tongyibutton;
@property (weak, nonatomic) IBOutlet RTLabel *rtLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayCntTextField;
@property (weak, nonatomic) IBOutlet CNActionButton * next;
@property (weak, nonatomic) IBOutlet UITextField *loanDayLabel;
@property (weak, nonatomic) IBOutlet UITextField *loanRateLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *viewLabels;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *viewTextFields;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *optionArrow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineItemHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionArrowViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;
@property (weak, nonatomic) IBOutlet UIButton *couponDelete;
@property (weak, nonatomic) IBOutlet UIView *couponSepView;

@property (weak, nonatomic) IBOutlet UITableView *optionTableView;
@property (weak, nonatomic) IBOutlet UIView *optionArrowView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *dayInputView;
@property (weak, nonatomic) IBOutlet UIView *dayOptionView;
@property (weak, nonatomic) IBOutlet UITextField *dayInputTextField;
@property (weak, nonatomic) IBOutlet UILabel *dayInputTianLabel;

@property (nonatomic) NSInteger selectedLoanDayValue;
@property (nonatomic) NSInteger selectedLoanDayIndex;
@property (nonatomic) NSInteger savedLoanDayIndex;

@property (strong, nonatomic) UIControl     *coveredView;
@property (strong, nonatomic) NSArray       *loanDaysArray; //借款天数选项
//@property (strong, nonatomic) NSDictionary  *loanMortgateConfiguration;

@property (nonatomic) NSNumber *loanRate;
@property (nonatomic) NSInteger isMortgateValue;
@property (nonatomic) BOOL isMortgated;
@property (nonatomic) BOOL isLimited;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) double remainValue;   //可借款额度
@property (nonatomic) NSInteger creditsNum; //好友数量
@property (strong,nonatomic) NSString *limitedMsg;
@property (nonatomic) NSInteger pubLoanMinDay;
@property (nonatomic) NSInteger pubLoanMaxDay;
@property (strong,nonatomic) NSDictionary *loanConfig;
@property (strong, nonatomic) CNWarningView *limitedView;

@property (nonatomic) NSInteger businessLicense; //营业执照

//借款免息券
@property (nonatomic) NSString  *content;
@property (nonatomic) NSInteger redirect;
@property (nonatomic) NSInteger debit;

@property (strong,nonatomic) ContactMgr *contactMgr;
@property (strong,nonatomic) SendLoanEngine *engine;

@property (strong, nonatomic) NSDictionary *selectedCoupon;

@end

@implementation SendLoanViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self tapBackground];
    
    //[self prepareForSetupUI];
    
    self.optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.optionViewHeight.constant = 0;
    
    amountVal = .0f;
    
    self.scrollView.hidden = YES;
    self.scrollView.delegate = self;
    self.next.enabled = YES;
    self.next.titleLabel.font = CNFont_32px;
    [self.next addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入1万的整数倍" attributes:@{ NSForegroundColorAttributeName : CN_UNI_RED, NSFontAttributeName:[UtilFont systemLargeNormal]}];

    self.amountTextField.attributedPlaceholder = attributedPlaceholder;
    self.amountTextField.textColor = CN_UNI_RED;
     */
    
    self.title = @"借款";
    [self setLeftNavLogo];
    
    self.couponDelete.hidden = YES;
    
    self.tongyibutton.selected = NO;
    
    progress_show
    
#ifdef TEST_TEST_SERVER
    
#endif
}



-(ContactMgr *)contactMgr{
    
    if(!_contactMgr){
        _contactMgr = [[ContactMgr alloc]init];
    }
    return _contactMgr;
}


-(SendLoanEngine *)engine{
    
    if(!_engine){
        _engine = [[SendLoanEngine alloc]init];
    }
    return _engine;
}

- (void)goNe{
     [self.scrollView adjustState:YES parent:self];
}

- (void)prepareForSetupUI{
    //progress_show
    
    WS(ws)
    
    [self.engine getLoanConfigWithSuccess:^(NSDictionary *loanConfigDict) {
        
        progress_hide
        ws.isFinished   = YES;
        ws.isMortgateValue = [loanConfigDict[@"status"] integerValue];
        ws.isMortgated  = [loanConfigDict[@"status"] integerValue] == 2;
        ws.isLimited    = [loanConfigDict[@"code"] integerValue] == 0;
        ws.remainValue  = [loanConfigDict[@"remain_loan_limit"] doubleValue];
        ws.creditsNum   = [loanConfigDict[@"credits"] integerValue];
        ws.loanConfig   = loanConfigDict [@"config"];
        ws.limitedMsg   = loanConfigDict [@"msg"];
        ws.businessLicense = [loanConfigDict[@"businessLicense"] integerValue];
        
        ws.content = loanConfigDict [@"content"];
        ws.redirect = [loanConfigDict[@"redirect"] integerValue];
        ws.debit = [loanConfigDict[@"debit"] integerValue];
        
        ws.pubLoanMinDay = [[ZAPP.myuser getValueOfKey:@"公开借款最小天数" fromConfig:self.loanConfig] integerValue];
        ws.pubLoanMaxDay = [[ZAPP.myuser getValueOfKey:@"公开借款最大天数" fromConfig:self.loanConfig] integerValue];
        
        [ws setupUI];
    } failure:^(NSString *error) {
        progress_hide;
    }];
    
    
    
}

- (void)setupUI{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self setNavButton];
    }
    
    self.limitedView.externelTitle = self.limitedMsg;
    if (self.isLimited) {
        [self.scrollView adjustState:YES parent:self bannerView:self.limitedView];
        self.next.enabled = NO;
    }else{
        self.next.enabled = YES;
        [self.scrollView adjustState:NO parent:self bannerView:self.limitedView];
    }
    
    //借款金额 提示内容： “请输入1万元的整数倍” 标红
    [self.amountTextField setValue:HexRGB(0xee4721) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.rtLabel.text = [NSString stringWithFormat:@"<font color=%@><a href='http://agreen.com'>已经阅读并同意</a></font><font color=%@><a href='借款协议'>《借款协议》</a></font>",COLOR_TEXT_LIGHT_GRAY,COLOR_BUTTON_BLUE];
    self.rtLabelHeight.constant = self.rtLabel.optimumSize.height;
    self.rtLabel.delegate = self;
    
    self.dayInputTextField.placeholder = [NSString stringWithFormat:@"请输入%zd-%zd", self.pubLoanMinDay, self.pubLoanMaxDay];
    
    if (self.isMortgated) {
        self.creditLimitLabel.text = [NSString stringWithFormat:@"抵押借款"];
        // "专属用户借款筹款天数"
        NSInteger mDay = [[ZAPP.myuser getValueOfKey:@"专属用户借款筹款天数" fromConfig:self.loanConfig] integerValue];
        
        // "专属借款年化利率"
        //self.loanRate = [NSNumber numberWithDouble:[[ZAPP.myuser getValueStringFromSystemPara:@"专属借款年化利率"] doubleValue]];
        
        //年化利率
        self.loanRateLabel.text = [NSString stringWithFormat:@"%@", self.loanRate];
        //筹款天数
        self.loanDayLabel.text = [NSString stringWithFormat:@"%ld",mDay];
        //打开借款天数选项
        [self setDayViewOptionable:YES];
        
        self.couponViewHeight.constant = [ZAPP.zdevice getDesignScale:50];
        self.couponSepView.hidden = NO;
        
    }else{
        //[NSNumber numberWithLong:[[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_REMAINLOANLIMIT] longValue]]
        self.creditLimitLabel.text = [NSString stringWithFormat:@"可借款额度:%@", [Util formatRMB: @(self.remainValue)]];
        
        //利率
        //self.loanRate = [NSNumber numberWithFloat:[ZAPP.myuser getMinPublicRatePerYear]];
        self.loanRateLabel.text = [NSString stringWithFormat:@"%@", self.loanRate];
        //筹款天数
        NSInteger mDay = [[ZAPP.myuser getValueOfKey:@"筹款天数" fromConfig:self.loanConfig] integerValue];
        self.loanDayLabel.text = [NSString stringWithFormat:@"%ld",mDay];
        //打开借款天数输入项
        [self setDayViewOptionable:NO];
        
        self.couponViewHeight.constant = 0;
        self.couponSepView.hidden = YES;
    }
    
    if ([self loanDaysArray].count > 0) {
        
        if ([self loanDaysArray].count == 1) {
            //不显示借款天数下拉箭头
            self.optionArrowView.hidden = YES;
            self.optionArrowViewWidth.constant = 0;
        }
        
        self.selectedLoanDayValue = [[self loanDaysArray][self.selectedLoanDayIndex][@"value"] integerValue];
        self.dayCntTextField.text = [self loanDaysArray][self.selectedLoanDayIndex][@"label"];
    }
    
    [self.amountTextField addTarget:self action:@selector(orderCalcValues) forControlEvents:UIControlEventEditingChanged];
    [self.dayCntTextField addTarget:self action:@selector(orderCalcValues) forControlEvents:UIControlEventEditingChanged];
    [self.dayInputTextField addTarget:self action:@selector(orderCalcValues) forControlEvents:UIControlEventEditingChanged];
    
    self.amountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.dayCntTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.optionTableView reloadData];
    [self rebuildFormData];
}

- (void)setDayViewOptionable:(BOOL)optionable{
    
    self.dayOptionView.hidden = !optionable;
    self.dayInputView.hidden = optionable;
    
//    if (optionable) {
//        self.dayOptionView.hidden = NO;
//    }else{
//        self.dayInputView.hidden = YES;
//    }
}

- (void)viewWillLayoutSubviews{
    
    self.lineItemHeight.constant = [ZAPP.zdevice getDesignScale:50];
    self.creditLimitLabel.font = [UtilFont system:20.0f];
    for (UILabel *l in self.viewLabels) {
        l.font = [UtilFont systemLarge];
    }
    for (UITextField *f in self.viewTextFields) {
        f.font = [UtilFont systemLarge];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    [self setLeftNavLogo];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popWaringView) name:MSG_system_service_updating object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWaringView) name:MSG_system_service_recovery object:nil];
    
    [ZAPP.netEngine getUserInfoWithComplete:^{
        [self setupUI];
        
        UpdateAndSharedTrigger
        
    } error:^{
        ;
    }];
    
    if (! self.selectedCoupon) {
        [self orderCalcValues];
    }
    
    //上传通讯录
    [self.contactMgr uploadContacts:nil];
    
    [ZAPP.znotice load];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    
//    if (! self.isFinished) {
        [self prepareForSetupUI];
//    }
    
    [MobClick beginLogPageView:@"发布借款"];
    
    self.tabBarController.navigationItem.title = @"借款";
    self.title = @"借款";
    
    [self setNavRightWarnBadge:[ZAPP.znotice getNtfNum]];

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *top = [vcs lastObject];
    if (![top isKindOfClass:[SelRedMoneyViewController class]] &&
        ![top isKindOfClass:[WebDetail class]]) {
        self.selectedLoanDayIndex = 0;
    }
    [MobClick endLogPageView:@"发布借款"];
}

- (BOOL)isFinished{
    return self.scrollView.hidden == NO;
}
- (void)setIsFinished:(BOOL)isFinished{
    self.scrollView.hidden = !isFinished;
}

- (IBAction)optionAction:(id)sender {
    
    if (!self.isMortgated) {
        //普通借款不需选择，改为输入
        return;
    }
    
    if ([self loanDaysArray].count <= 1) {
        return;
    }
    
    [self finishAction];
    
    if (self.optionViewHeight.constant > 0) {
        self.optionViewHeight.constant = 0;
        self.coveredView.hidden = YES;
        self.scrollView.scrollEnabled = YES;
    }else{
        CGFloat optionViewHeight = [ZAPP.zdevice getDesignScale:50]* ([self.loanDaysArray count]);
        //CGPoint p = [ZAPP.window convertPoint:self.optionTableView.frame.origin fromView:self.scrollView];
        
        CGPoint p = [self.scrollView convertPoint:self.optionTableView.frame.origin fromView:self.scrollView];
        
        /*
        CGFloat h = self.scrollView.height ;
        CGFloat h2 = p.y + optionViewHeight;
        CGFloat optionH = optionViewHeight;
        */
        
        if (p.y + optionViewHeight > self.scrollView.height ) {
            optionViewHeight -= (p.y + optionViewHeight - self.scrollView.height);
        }
        
        self.optionTableView.contentSize = CGSizeMake(self.optionTableView.contentSize.width, optionViewHeight);
        self.optionViewHeight.constant = optionViewHeight;
        
        CGPoint coverOrgin = CGPointMake(0, p.y + optionViewHeight);
        
        CGPoint pc = [ZAPP.window convertPoint:coverOrgin fromView:self.scrollView];
        
        CGRect rect = CGRectMake(0, pc.y, ZAPP.window.width, ZAPP.window.height);
        
        [self.coveredView setFrame:rect];
        
        self.coveredView.hidden = NO;
        
        self.scrollView.scrollEnabled = NO;
    }
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self.view layoutIfNeeded] ;
    } completion:^(BOOL finished) {
        nil;
    }];
    // 旋转箭头
    float angle = self.optionViewHeight.constant>0 ? M_PI : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        self.optionArrow.transform = CGAffineTransformMakeRotation(angle);
    }];

}
- (IBAction)coveredViewToched:(id)sender {
    [self optionAction:nil];
}

- (void)popWaringView {
    [self.scrollView adjustState:YES parent:self];
}

- (void)dismissWaringView {
    [self.scrollView adjustState:NO parent:self];
}





#pragma mark UIGestureRecognizerDelegate methods
-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];
    tap.delegate = self;
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}
-(void)tapOnce//手势方法
{
    [self finishAction];
    
    
    if (self.optionViewHeight.constant > 0) {
        self.optionViewHeight.constant = 0;
        self.coveredView.hidden = YES;
        self.scrollView.scrollEnabled = YES;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.9 initialSpringVelocity:7.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            [self.view layoutIfNeeded] ;
        } completion:^(BOOL finished) {
            nil;
        }];
        // 旋转箭头
        float angle = self.optionViewHeight.constant>0 ? M_PI : 0.0f;
        [UIView animateWithDuration:0.2f animations:^{
            self.optionArrow.transform = CGAffineTransformMakeRotation(angle);
        }];
    }
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.optionTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

- (NSInteger)friendLimit{
    return [[ZAPP.myuser getValueOfKey:@"发布借款好友数下限" fromConfig:self.loanConfig] integerValue];
}

- (NSNumber *)loanRate{
    //WithMortgate:(BOOL)mortgate fromConfig:(NSDictionary *)config
    
    NSString *key = self.isMortgated ? @"专属借款年化利率" : @"公开借款最低年化利率";
    
    return @([[ZAPP.myuser getValueOfKey:key fromConfig:self.loanConfig] doubleValue]);
}

- (NSArray *)loanDaysArray{
    return [ZAPP.myuser getInterestDayCountWithMortgate:self.isMortgated fromConfig:self.loanConfig];
}

- (void)rebuildFormData{
    if (self.loanDictRedistributed) {
        CGFloat amount = [self.loanDictRedistributed[@"loanmainval"] longValue];
        amount = amount / 1e4;
        self.amountTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:amount]];
    }
}

- (IBAction)backgroundTouched:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

- (void)refreshUI{
    
    NSInteger days = 0;
    
    if (self.isMortgated) {
        days = self.selectedLoanDayValue;
    }else{
        days = [self.dayInputTextField.text integerValue];
    }
    
    NSInteger amount = [self.amountTextField.text doubleValue] * 1e4;
    
    if (days <= 0 || amount <= 0) {
        [self refreshUIError];
        return;
    }
    
    double totalval = [ZAPP.myuser.fabuCalDict[@"totalval"] doubleValue];
    if (self.selectedCoupon) {
        //选中免息券,总额即为本金
        totalval = [self.amountTextField.text doubleValue] * 1e4;;
    }
    amountVal = totalval;
    NSString *valStr = [Util formatRMB:[NSNumber numberWithDouble:totalval]];
    self.amountLabel.text = [NSString stringWithFormat:@"到期本息合计约为:%@", valStr];
}

- (void)refreshUIError{
    self.amountLabel.text = [NSString stringWithFormat:@"到期本息合计约为:0.00元"];
    //[self.next setTheEnabled:NO];
}

- (void)refreshUILoanComplete{
    self.amountTextField.text = @"";
    self.dayInputTextField.text = @"";
    //[self.next setTheEnabled:NO];
    self.tongyibutton.selected = NO;
    
    self.selectedLoanDayIndex = 0;
    
    [self delCouponAction:nil];
    
    [self.optionTableView reloadData];
}

- (void)orderCalcValues{
    NSInteger amount = [self.amountTextField.text doubleValue] * 1e4;
    NSInteger days = 0;
    
    if (self.isMortgated) {
        days = self.selectedLoanDayValue;
    }else{
        days = [self.dayInputTextField.text integerValue];
    }
   
    CGFloat loanrate = [self.loanRate floatValue];
    
    double interest = 0.0;
    if (self.selectedCoupon) {
        interest = [self.selectedCoupon[@"rate"] doubleValue];
        interest *= kcoupan_rate_precision;
        //loanrate += interest;
    }else{
        interest = loanrate;
    }
    
    if (amount > 0 && days > 0) {
        //
        //[self.next setTheEnabled:self.tongyibutton.selected];
        //
        [ZAPP.netEngine loanCalWithComplete:^{
            
            if (amount > 0 && days > 0) {
                [self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(refreshUIError) withObject:nil waitUntilDone:YES];
            }
        } error:^{
            [self performSelectorOnMainThread:@selector(refreshUIError) withObject:nil waitUntilDone:YES];
        } mainval:amount loanrate:interest couponrate:0.0 daycount:days];
    }else {
        [self performSelectorOnMainThread:@selector(refreshUIError) withObject:nil waitUntilDone:YES];
    }
}
- (void)fabuData:(NSDictionary *)loanFabuSucDetailDict {
//    if (ZAPP.myuser.loanFabuSucDetailDict) {
        LoanDistrubuteDetailViewController *detail = ZJIEKUAN(@"LoanDistrubuteDetailViewController");
        detail.loanDict = loanFabuSucDetailDict;
        [self.navigationController pushViewController:detail animated:YES];
//    }
    [self refreshUILoanComplete];
}

- (NSInteger)getLoanDays{
    NSInteger days = self.selectedLoanDayValue;
    
    if (! self.isMortgated) {
        //普通借款，借款天数用户输入
        days = [[self.dayInputTextField text] integerValue];
    }
    return days;
}

- (NSInteger)getLoanAmount {
    return [self.amountTextField.text doubleValue] * 1e4;
}

- (void)connectToFabu {
    
    NSInteger amount = [self getLoanAmount];
    NSInteger days = [self getLoanDays];
    
    bugeili_net
    _isNavigationBack = NO;
    progress_show
//    NSInteger loanDays = [self.loanDayLabel.text integerValue];
    NSString *loanIdRedistributed = @"";
    if (_loanDictRedistributed) {
        loanIdRedistributed = _loanDictRedistributed[NET_KEY_LOANID];
    }
    WS(ws)
    
    
    
    NSMutableDictionary *para = [@{@"userid"            : [ZAPP.myuser getUserID],
                           @"loanid"            : loanIdRedistributed,
                           @"val"               : @(amount),
                           @"loantype"          : @(self.isMortgateValue),
                           @"loanrate"          : self.loanRate,
                           @"interestdaycount"  : @(days)
                           } mutableCopy];
    
    if (self.selectedCoupon) {
        NSInteger bicid = [self.selectedCoupon[@"bicid"] integerValue];
        [para setObject:@(bicid) forKey:@"couponid"];
    }
    
    [self.engine sendLoan:para success:^(NSDictionary *loanFabuSucDetailDict){
        
        [ws fabuData:loanFabuSucDetailDict];
        progress_hide
        
    } failure:^(NSString *error) {
        
//        [ws losefabuData];
        progress_hide
    }];
    
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    
    if ([url.absoluteString mycontainsString:@"agree"]) {
        self.tongyibutton.selected = !self.tongyibutton.selected;
    }else{
        
        //type=2 借款金额 loanval 借款天数  loandays 借款利率 loanrate
        NewLoanProtocolViewController *vc = [[NewLoanProtocolViewController alloc]init];
        vc.type = 2;
        vc.addtionParmas = [NSString stringWithFormat:@"loanval=%@&loandays=%@&loanrate=%@",
                            @([self getLoanAmount]),
                            @([self getLoanDays]),
                            self.loanRate];
        [self.navigationController pushViewController:vc animated:YES];
        
        /*
        WebDetail *w = ZSTORY(@"WebDetail");
        w.webType = WebDetail_borrow_xuzhi;
        //w.userAssistantPath = @{@"name": @"测试"};
        //w.absolutePath = @"https://rc1api.cashnice.com/41/";
        [self.navigationController pushViewController:w animated:YES];
        */
    }
}

- (IBAction)tongyiButtonPressed:(id)sender {

    self.tongyibutton.selected = !self.tongyibutton.selected;
}

-(void)nextButtonPresseAfterContactsTested{
    
    [self finishAction];
    
    BOOL noUserLevel = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERLEVEL] intValue] == 0);
    BOOL noRemain = ([ZAPP.myuser getRemainLoanLimit] == 0);
    
    if (self.amountTextField.text.length < 1 /*amount == 0*/) {
        [Util toastStringOfLocalizedKey:@"tip.inputtingLoanAmount"];
        return;
    }
    
    if (! self.isMortgated) {
        //普通借款
        
        NSInteger days = [[self.dayInputTextField text] integerValue];
        //借款天数用户输入
        if (days < self.pubLoanMinDay || days > self.pubLoanMaxDay) {
            
            NSString *pmt = [NSString stringWithFormat:@"借款天数请输入%zd-%zd天！", self.pubLoanMinDay, self.pubLoanMaxDay];
            
            [Util toast:pmt];
            
            return;
        }
        
        if (noRemain) {
            //判断剩余借款额度
            [Util toastStringOfLocalizedKey:@"tip.unableReleaseLoan"];
            return;
        }
        
        if (![ZAPP.myuser satisfyFriendNum:[self friendLimit]]) {
            [Util toast : [ZAPP.myuser infoNotFriendNum:[self friendLimit]]];
            
            //        [Util toast:[NSString stringWithFormat:@"%@",[ZAPP.myuser infoNotFriendNum]]];
            /*
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[ZAPP.myuser infoNotFriendNum] message:@"请邀请好友或索要授信!" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"邀请好友", @"索要授信", nil];
             alert.tag = 1001;
             [alert show];
             */
            return;
        }
        
        //检查营业执照
        if(!self.isMortgated && self.businessLicense!=1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.license", nil) message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1003;
            [alert show];
            return;
        }
        
    }else{
        if (self.dayCntTextField.text.length < 1) {
            [Util toastStringOfLocalizedKey:@"tip.inputtingBorrowDays"];
            return;
        }
    }
    //        CGFloat amount = [self.amountTextField.text doubleValue] * 1e4;
    //        NSInteger days = [self.dayCntTextField.text integerValue];
    //    if (days<30 || days>180) {
    //        [Util toastStringOfLocalizedKey:@"tip.borrowMostAndLeast"];
    //        return;
    //    }
    if (! self.tongyibutton.selected) {
        [Util toastStringOfLocalizedKey:@"tip.agreeLoanProtocal"];
        return;
    }
    
    if (noUserLevel) {
        NoLevel *borrow = ZSTORY(@"NoLevel");
        [self.navigationController pushViewController:borrow animated:YES];
        return;
    }
    //    BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
    //    if (inBlackList) {
    //        [Util toast:@"您已进入Cashnice黑名单，无法发布借款！"];
    //        return;
    //    }
    
   
    [ZAPP.myuser fabuClear];
    //NewBorrowViewController *fabu = ZBorrow(@"NewBorrowViewController");
    //[self.navigationController pushViewController:fabu animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.xuZhiVC", nil) message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1002;
    [alert show];
    
}

- (void)nextButtonPressed {
    
    //没有授权通讯录
    if (![ContactMgr addressBookAuthened]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"匹配通讯录，借款才能审批" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        alert.tag = 999;
        [alert show];
        return;
    }
    
    WS(weakSelf)
    
    //点击的时候要求上传通讯录
    [self.contactMgr uploadContacts:^(NSString *error) {
        
        if(error.length){
            [Util toast:error];
            return ;
        }else{
            [weakSelf nextButtonPresseAfterContactsTested];
        }
        
        
    }];
    
    
   
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZAPP.zdevice getDesignScale:50];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.loanDaysArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    static NSString *cellIdentifier=@"loanDaysCell";
    LoanDaysCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *loanDayDict = self.loanDaysArray[indexPath.row];
    
    cell.optionTitleLabel.text = loanDayDict[@"label"];
    
    cell.sepView.hidden = indexPath.row == [self.loanDaysArray count]-1;
    
    //NSInteger dayValueOfThisCell = [loanDayDict[@"value"] integerValue];
    //cell.optionAccessory.hidden = !(self.selectedLoanDayValue == dayValueOfThisCell);
    cell.optionAccessory.hidden = !(self.selectedLoanDayIndex == indexPath.row);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *loanDayDict = self.loanDaysArray[indexPath.row];
    self.selectedLoanDayValue = [loanDayDict[@"value"] integerValue];
    self.dayCntTextField.text = loanDayDict[@"label"];
    self.selectedLoanDayIndex = indexPath.row;
    
    [self orderCalcValues];
    
    [self.optionTableView reloadData];
    [self optionAction:nil];
}

- (IBAction)couponDidClicked:(id)sender {
    SelRedMoneyViewController *vc = REDSTORY(@"SelRedMoneyViewController");
    [vc setValue:@(REDMONEY_TYPE_DECREASEINTEREST) forKey:@"type"];
    vc.delegate = self;
    vc.invest = NO;
    vc.startmoney = [self.amountTextField.text doubleValue] * 1e4;;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)redMoneyAllDisabled:(REDMONEY_TYPE)type{
    
    if (REDMONEY_TYPE_CASH != type) {
        [self delCouponAction:nil];
        [self orderCalcValues];
    }
}

-(void)didSelectedRedMoney:(REDMONEY_TYPE)type
                    detail:(NSDictionary *)detaildic{
    //NSLog(@"%@", detaildic);
    self.selectedCoupon = detaildic;
}

- (void)setSelectedCoupon:(NSDictionary *)selectedCoupon{
    _selectedCoupon = selectedCoupon;
    if (_selectedCoupon) {
        
        double rate = [_selectedCoupon[@"rate"] doubleValue];
        rate *= kcoupan_rate_precision;
        
        self.couponLabel.text = EMPTYSTRING_HANDLE(_selectedCoupon[@"desc"]);
        //[NSString stringWithFormat:@"%@%%加息券",[Util formatFloat:@(rate)]]; //
        self.couponDelete.hidden = NO;
        [self refreshUI];
    }else{
        self.couponLabel.text = @"";
        self.couponDelete.hidden = YES;
        [self orderCalcValues];
    }
    
}

- (IBAction)delCouponAction:(id)sender {
    self.selectedCoupon = nil;
}

- (UIControl *)coveredView {
    if (! _coveredView) {
        _coveredView = [UIControl new];
        _coveredView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        
        [_coveredView addTarget:self action:@selector(optionAction:) forControlEvents:UIControlEventTouchDown];
        
        [ZAPP.window addSubview:_coveredView];
    }
    return _coveredView;
}

- (CNWarningView *)limitedView{
    if (! _limitedView) {
        _limitedView = [CNServiceWarningViewFactory getRejectionViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SCROLLVIEW_BANNER_HEIGHT)];
    }
    return _limitedView;
}

-(void)pushSina:(NSString *)url{
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    web.URLPath = url;
    //        web.URLPath = @"https:\/\/pay.sina.com.cn\/zjtg\/website\/view\/authorize.html?ft=3ffe6bed-ca0a-4a31-bea6-bb80922f5975" ;
    web.titleString = @"新浪收银台";
    web.completeHandle = self;
    WS(weakSelf)
    
    web.navigationBackHandler = ^{
        [weakSelf popToSetVC];
    };
    [self.navigationController pushViewController:web animated:YES];
}

-(void)popToSetVC{
    [self.navigationController popViewControllerAnimated:YES];
}

//授权完成
- (void)complete{
    //NSLog(@"complete ... ");
    //[self popToSetVC];
    //授权完成 发布借款
    [self connectToFabu];
}

//授权返回
- (void)cancel{
    //NSLog(@"cancel ... ");
    [self popToSetVC];
}

- (IBAction)investValChanged:(id)sender {
    [self delCouponAction:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            URL_OPEN_SETTING
        }
    }else{
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            if (alertView.tag == 1001 && buttonIndex == 1) {
                YaoqingHaoyou *y = ZSTORY(@"YaoqingHaoyou");
                [self.navigationController pushViewController:y animated:YES];
            }
            if (alertView.tag == 1001 && buttonIndex == 2) {
                ShouxinList *s = ZSEC(@"ShouxinList");
                [s setShowXintype:ShouXin_MeiYou];
                [self.navigationController pushViewController:s animated:YES];
            }
            if (alertView.tag == 1003) {
                [self.navigationController pushViewController:[MeRouter businessLicense] animated:YES];
            }
            if (alertView.tag == 1002) {
                //检查扣款权限
                if ((self.selectedCoupon) && self.redirect==1 && self.debit==1 && self.content.length  > 0) {
                    [self pushSina:self.content];
                    return;
                }
                
                [self connectToFabu];
            }
        }
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self finishAction];
}
//收起键盘
-(void)finishAction{
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    [self.view endEditing:NO];
}

@end
