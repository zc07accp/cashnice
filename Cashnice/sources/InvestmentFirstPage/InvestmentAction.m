//
//  InvestmentFirst.m
//  YQS
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentAction.h"
#import "AllShouxinPeople.h"
#import "RTLabel.h"
#import "WebDetail.h"
//#import "UCZProgressView.h"
#import "Chongzhi.h"
#import "InvestmentDetailViewController.h"
#import "LoanProgressView.h"
#import "SinaCashierWebViewController.h"
#import "SinaCashierModel.h"
#import "JieKuanUtil.h"
#import "SystemOptionsEngine.h"
#import "SelRedMoneyViewController.h"
#import "pgrView.h"
#import "NewLoanProtocolViewController.h"
#import "CustomTestingAlertView.h"
#import "SettingEngine.h"
#import "CouponJSHandle.h"

@interface InvestmentAction () <RTLabelDelegate, UITextFieldDelegate, HandleCompletetExport, CouponJSHandleExport, CustomTestingAlertViewDelegate, SelRedMoneyDelegate> {
        NSInteger rowCnt;
        NSInteger rowHeight;
        int curPage;
        int pageCount;
        int totalCount;
        NSDate *lastDate;
        NSInteger _selectedIndex;
    
        double _balanceVal;
}
@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *cycleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualInvestmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestRate;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cycleTime;
@property (weak, nonatomic) IBOutlet UILabel *dayLbale;
@property (weak, nonatomic) IBOutlet UILabel *investmentCount;
@property (weak, nonatomic) IBOutlet UILabel *wanLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeWanLabel;
@property (weak, nonatomic) IBOutlet UILabel *wantInvestmentLabel;


@property (weak, nonatomic) IBOutlet UILabel *investmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentPeoLabel;

@property (weak, nonatomic) IBOutlet LoanProgressView *loanProgressView;


@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumMoney;
@property (weak, nonatomic) IBOutlet UILabel *yuanSumMoney;
@property (weak, nonatomic) IBOutlet UILabel *redPrmpt;
@property (weak, nonatomic) IBOutlet UILabel *couponPrmpt;

@property (weak, nonatomic) IBOutlet UILabel *ratePrmpt;

@property (weak, nonatomic) IBOutlet UILabel *incomeInvestment;

@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet UILabel *protocalLabel;
@property (weak, nonatomic) IBOutlet UIButton * agreeButton;

@property (weak, nonatomic) IBOutlet UILabel *accountBalance;

@property (weak, nonatomic) IBOutlet UIButton *redDelete;
@property (weak, nonatomic) IBOutlet UIButton *couponDelete;
//红包修改
@property (weak, nonatomic) IBOutlet UILabel *AmountInvestment;
@property (weak, nonatomic) IBOutlet UILabel *leaveInvestmentCount;

@property (weak, nonatomic) IBOutlet UIButton *investActionButton;
@property (weak, nonatomic) IBOutlet UITextField *valTextField;

@property (weak, nonatomic) IBOutlet pgrView * pgrView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkBox;

@property (strong, nonatomic) SystemOptionsEngine *systemEngine;
@property (strong, nonatomic) SettingEngine *settingEngine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realAmountViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *packageLabel;
@property (weak, nonatomic) IBOutlet UITextField *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel     *realAmountPromptLabel;
@property (strong, nonatomic) NSDictionary *selectedPackage;
@property (strong, nonatomic) NSDictionary *selectedCoupon;

@property(assign, nonatomic) NSInteger popup;
@property(strong, nonatomic) NSString *popUrl;
@property(strong, nonatomic) CustomTestingAlertView *testingAlertView;

@end

@implementation InvestmentAction

BLOCK_NAV_BACK_BUTTON
- (void)setTheDataDict:(NSDictionary *)dict {
    self.loadDict = dict;
    //[self ui];
    self.loanid = [self.loadDict[@"loanid"] integerValue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareForUI];
    [self setupUI];
    [self setNavButton];
    
    [self foldUpTheKeyboard];
    
    [self.checkBox[0] setSelected:YES];
    _selectedIndex = 0;
    [self orderCalcValues];
    
     [Util setScrollHeader:self.scrollView target:self header:@selector(connectToServerSilent) dateKey:[Util getDateKey:self]];
    
    [self.investActionButton setTitle:@"我要投资" forState:UIControlStateNormal];
    
    self.valTextField.placeholder = [ZAPP.myuser getInvestPrompt];
    
    [self setConfiguralbePlaceholder];
    
    progress_show
    
    [self pgr];
    
    self.redDelete.hidden = YES;
    self.couponDelete.hidden = YES;
}

- (void)pgr{
    
    double loanprogress = [self.loadDict[@"loanprogress"] doubleValue];
    //loanprogress /= 100;
    
    if (loanprogress>0 && loanprogress != self.pgrView.value) {
        [self.pgrView setProgress:loanprogress];
    }
    
    //[self.pgrView setNeedsDisplay];
    
    
    /*
    pgrView *v = [[pgrView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    v.backgroundColor = [UIColor cyanColor];
    [v setProgress:0.5];
    
    [self.view addSubview:v];
    */
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self connectToServerSilent];
    [self disprocessedNextButton];
    [MobClick beginLogPageView:@"我要投资"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getPopTesting];
    
    [MobClick endLogPageView:@"我要投资"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)prepareForUI{
    
    self.protocalLabel.font =
    self.protocolButton.titleLabel.font =
    self.valTextField.font =
    self.percentLabel.font =
    self.dayLbale.font =
    self.wanLabel.font =
    self.AmountInvestment.font =
    self.yuanLabel.font =
    self.sumMoney.font =
    self.cycleTimeLabel.font =
    self.annualInvestmentLabel.font =
    self.guaranteeLabel.font =
    self.guaranteeWanLabel.font =
    self.investmentLabel.font =
    self.investmentPeoLabel.font =
    self.wantInvestmentLabel.font =
    self.redPrmpt.font =
    self.couponPrmpt.font =
    self.packageLabel.font =
    self.couponLabel.font =
    self.realAmountPromptLabel.font =
    self.yuanSumMoney.font = [UtilFont systemLargeNormal];
    
    self.accountBalance.font =
    self.incomeInvestment.font = [UtilFont systemNormal:16];
    
    self.interestRate.font =
    self.investmentCount.font =
    self.guaranteeCountLabel.font =
    self.investmentNumLabel.font =
    self.cycleTime.font =
    
    [UtilFont systemNormal:22];
    
    
    self.valTextField.delegate = self;
    for (UIButton * btn in _checkBox) {
        btn.titleLabel.font = [UtilFont systemLargeNormal];
    }
    
    
    self.investActionButton.titleLabel.font = [UtilFont systemButtonTitle];
    
}

- (void)setupUI{
    
    self.interestRate.text = [NSString stringWithFormat:@"%@%%",[self.loadDict objectForKey:@"loanrate"]];
    self.cycleTime.text = [NSString stringWithFormat:@"%@",[self.loadDict objectForKey:@"interestdaycount"]];
    
    
    double rate = [[self.loadDict objectForKey:@"loanrate"] doubleValue];
    NSString *rateStr = [NSString stringWithFormat:@"%.2f%%", rate];;
    
    NSUInteger dotLoc = [rateStr rangeOfString:@"."].location;
    
    NSMutableAttributedString *rateStrAtt = [Util getAttributedString:rateStr font:CNFont(68) color:CN_UNI_RED];
    [Util setAttributedString:rateStrAtt font:CNFont(52) color:CN_UNI_RED range:NSMakeRange(dotLoc, 3)];;
    [Util setAttributedString:rateStrAtt font:CNFont(40) color:CN_UNI_RED range:NSMakeRange(dotLoc+3, 1)];
    //[Util setAttributedString:rateStrAtt font:CNFont(52) color:CN_UNI_RED substr:@".05" allstr:@"15.05%"];
    //[Util setAttributedString:rateStrAtt font:CNFont(40) color:CN_UNI_RED substr:@"%" allstr:@"15.05%"];
    
    self.interestRate.attributedText = rateStrAtt;
    
    // |计划借款金额|
    long loanmainval = [self.loadDict[@"loanmainval"] longValue];
    
    self.title =[NSString stringWithFormat:@"%@",self.loadDict[@"loantitle"]];
    
    double mainval = loanmainval ;
    self.investmentCount.text = [NSString stringWithFormat:@"%@",[Util formatRMBWithoutUnit:@(mainval)]];
    
    //担保人数
    NSInteger guarantorCount = [self.loadDict[@"warrantycount"] integerValue];
    self.guaranteeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)guarantorCount];
    
    //投资人数
    NSInteger investerCount = [self.loadDict[@"betcount"] integerValue];
    self.investmentNumLabel.text = [NSString stringWithFormat:@"%ld", (long)investerCount];
    
    //
    self.ratePrmpt.font = CNFont_24px;
    //剩余借款金额
    double leaved = [self LeftedAmount];
    self.leaveInvestmentCount.font = CNFont_26px;
    self.leaveInvestmentCount.text = [NSString stringWithFormat:@"可投金额%@元", [Util formatRMBWithoutUnit:@(leaved)]];
    
    // 账户余额
    // self.accountBalance.text = [NSString stringWithFormat:@"账户余额:%@", [Util formatRMB:@([ZAPP.myuser getAccountVal])]];
    
    NSInteger loanstatus = [self.loadDict[@"loanstatus"] integerValue];
    if (loanstatus != 1) {
        self.investActionButton.hidden = YES;
    }else{
        self.investActionButton.hidden = NO;
    }
    /*
    [self.investActionButton setEnabled:NO];
    [self.investActionButton setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    */
    
    if ([JieKuanUtil isPrivilegedWithLoan:self.loadDict]) {
        //抵押用户
        self.guaranteeLabel.text = @"抵押用户";
        self.guaranteeCountLabel.text = @"";
        self.guaranteeWanLabel.text = @"";
    }
    
    
    //红包加息券
    NSString *packageEnable = self.loadDict[@"usecoupon"];
    NSString *couponEnable = self.loadDict[@"useinterestcoupon"];
    
    if (! [@"1" isEqualToString: packageEnable]) {
        self.packageViewHeight.constant = 0;
        self.realAmountViewHeight.constant = 0;
    }else{
        self.packageViewHeight.constant = [ZAPP.zdevice getDesignScale:50];
        self.realAmountViewHeight.constant = [ZAPP.zdevice getDesignScale:30];
    }
    
    if (! [@"1" isEqualToString: couponEnable]) {
        self.couponViewHeight.constant = 0;
    }else{
        self.couponViewHeight.constant = [ZAPP.zdevice getDesignScale:50];;
    }
    
    [self pgr];
    
    [self setupProgress];
}

- (IBAction)delRedAction:(id)sender {
    self.selectedPackage = nil;
}

- (IBAction)delCouponAction:(id)sender {
    self.selectedCoupon = nil;
}

- (IBAction)packageToSelAction:(id)sender {
   
    SelRedMoneyViewController *vc = REDSTORY(@"SelRedMoneyViewController");
    [vc setValue:@(REDMONEY_TYPE_CASH) forKey:@"type"];
    vc.delegate = self;
    vc.invest = YES;
    vc.startmoney = [self getTouziVal];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)couponToSelAction:(id)sender {
   
    SelRedMoneyViewController *vc = REDSTORY(@"SelRedMoneyViewController");
    [vc setValue:@(REDMONEY_TYPE_RAISEINTEREST) forKey:@"type"];
    vc.delegate = self;
    vc.invest = YES;
    vc.startmoney = [self getTouziVal];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //

    
}

-(void)didSelectedRedMoney:(REDMONEY_TYPE)type
                    detail:(NSDictionary *)detaildic{
    
    if (0 == type) {
        self.selectedPackage = detaildic;
    }else{
        self.selectedCoupon = detaildic;
    }
}

-(void)redMoneyAllDisabled:(REDMONEY_TYPE)type{
    
    if (REDMONEY_TYPE_CASH == type) {
        self.selectedPackage = nil;
    }else{
        self.selectedCoupon = nil;
        [self orderCalcValues];
    }
}

- (void)setSelectedPackage:(NSDictionary *)selectedPackage{
    _selectedPackage = selectedPackage;
    if (_selectedPackage) {
        
        double money =  [_selectedPackage[@"usemoney"] doubleValue];
        
        self.packageLabel.text = [NSString stringWithFormat:@"%@元红包", [Util formatFloat:@(money)]]; //EMPTYSTRING_HANDLE(_selectedPackage[@"desc"])
        self.redDelete.hidden = NO;
    }else{
        self.packageLabel.text = @"";
        self.redDelete.hidden = YES;
    }
    [self orderCalcValues];
}

- (void)setSelectedCoupon:(NSDictionary *)selectedCoupon{
    _selectedCoupon = selectedCoupon;
    if (_selectedCoupon) {
        
        double rate = [_selectedCoupon[@"rate"] doubleValue];
        rate *= kcoupan_rate_precision;
        
        self.couponLabel.text = [NSString stringWithFormat:@"%@%%加息券",[Util formatFloat:@(rate)]]; //EMPTYSTRING_HANDLE(_selectedCoupon[@"desc"])
        self.couponDelete.hidden = NO;
    }else{
        self.couponLabel.text = @"";
        self.couponDelete.hidden = YES;
    }
    
    [self orderCalcValues];
}

- (void)refreshCouponAndCalcInterest{
    self.selectedCoupon = nil;
    self.selectedPackage = nil;
    
    [self orderCalcValues];
}

- (void)setConfiguralbePlaceholder {
    
    WS(weakSelf)
    
    [self.systemEngine getSystemConfigItem:@[@"投资提示语"] success:^(NSArray *items){
        if ([items isKindOfClass:[NSArray class]] && items.count > 0) {
            for (NSDictionary *itemDict in items) {
                if ([itemDict[@"name"] isEqualToString:@"投资提示语"]) {
                    NSString *val = EMPTYSTRING_HANDLE(itemDict[@"value"]);
                    weakSelf.valTextField.placeholder = val;
                }
            }
        }
    } failure:^(NSString *error) {
        ;
    }];
    
    self.valTextField.placeholder = [ZAPP.myuser getInvestPrompt];
    
}

- (void)getPopTesting{
    [self.settingEngine getPopTestWithSuccess:^(NSDictionary *dict) {
        self.popup = [dict[@"popup"] integerValue];
        self.popUrl = dict[@"url"];
    } failure:^(NSString *error) {
        ;
    }];
}

- (void)connectToServerSilent {
    
    WS(ws);
    
    [ZAPP.netEngine getLoanDetailWithLoanID:[NSString stringWithFormat:@"%ld", (long)self.loanid] complete:^{
        
        if (ws.loadDict.count <= 1) {
            //没有传入loanDict数据
            ws.loadDict = ZAPP.myuser.loanDetailDict;
            [self orderCalcValues];
        }else{
            ws.loadDict = ZAPP.myuser.loanDetailDict;
        }
        
        [ws setupUI];
        [ws.scrollView.header endRefreshing];
        progress_hide
    } error:^{
        [ws.scrollView.header endRefreshing];
        progress_hide
    }];
    
    [self refreshVanlance];
}

- (void)connectToServer {
    bugeili_net
    WS(ws);

    //progress_show
    [ZAPP.netEngine getLoanDetailWithLoanID:[NSString stringWithFormat:@"%ld", (long)self.loanid] complete:^{
        
        [ws performSelectorOnMainThread:@selector(disprocessedNextButton) withObject:nil waitUntilDone:NO];
        progress_hide
        ws.loadDict = ZAPP.myuser.loanDetailDict;
        [ws setupUI];
        
        [ws.scrollView.header endRefreshing];
        
    } error:^{
        [ws performSelectorOnMainThread:@selector(disprocessedNextButton) withObject:nil waitUntilDone:NO];
        progress_hide
        [ws.scrollView.header endRefreshing];
    }];
    
    [self refreshVanlance];

}

- (void)refreshVanlance{
    
    WS(ws);
    
    if (_balanceVal < 0.001) {
        progress_show
    }
    
    [ZAPP.netEngine getTransferLimitComplete:^{
        progress_hide
        NSDictionary *limtDcit = ZAPP.myuser.withdrawLimitRespondDict;
        _balanceVal = [limtDcit[@"balance"] doubleValue];
        // 账户余额
        ws.accountBalance.text = [NSString stringWithFormat:@"账户余额:%@", [Util formatRMB:@(_balanceVal)]];
    } error:^{
        progress_hide;
    }];
}

- (void)setupProgress {
    CGFloat  progress = [self.loadDict[@"loanprogress"] doubleValue];
    self.loanProgressView.progress =progress;
    self.loanProgressView.bold = YES;
    if (progress == 100) {
        self.loanProgressView.status = self.loadDict[@"loanstatuslabel"];
    }
}


- (double)LeftedAmount {
    long loanmainval = [self.loadDict[@"loanmainval"] longValue];
    //实际筹得金额
    long loanedmainval = [self.loadDict[@"loanedmainval"] longValue];
    return loanmainval - loanedmainval;
}

- (void)setData {
    
    int betres = [[ZAPP.myuser.touziRespondDict objectForKey:NET_KEY_betresult] intValue];
    if (betres == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        InvestmentDetailViewController *detail = ZINVSTFP(@"InvestmentDetailViewController");
        
        detail.betid = ZAPP.myuser.touziRespondDict[@"betid"];
        
        [self.navigationController pushViewController:detail animated:YES];
        /*
        [Util toast:@"正在处理中，返回结果稍后请查看消息提醒。"];
        [self.delegate touziOkDone];
        if (self.fromTouzi) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            //我的投资列表
            UIViewController *myInvestment = ZINVST(@"MyInvestmentsListViewController");
            [self.navigationController pushViewController:myInvestment animated:YES];
        }
        */
    }
}

- (void)connectToTouzi {
    
//    
//    InvestmentDetailViewController *detail = ZINVSTFP(@"InvestmentDetailViewController");
//    detail.reponseDict = ZAPP.myuser.touziRespondDict;
//    detail.orderIdLabel.text = self.loadDict[@"loanid"];
//    detail.amountLabel.text = [Util formatRMBWithoutUnit:@([self getTouziVal])];
//    [self.navigationController pushViewController:detail animated:YES];
//    
//    return;
//    
//
    
    NSString *loanid = [self.loadDict objectForKey:NET_KEY_LOANID];
    NSString *value = [NSString stringWithFormat:@"%ld", (long)[self getTouziVal]];
    
    NSString *couId =  EMPTYSTRING_HANDLE(self.selectedPackage[@"couid"]);
    NSString *bicId =  EMPTYSTRING_HANDLE(self.selectedCoupon[@"bicid"]);
    
    [self processedNextButton];
    
    bugeili_net
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    __weak typeof(self) weakSelf = self;
    progress_show
    [model investAction:value loanId:loanid couId:couId bicid:bicId  success:^(NSData *contentData) {
        progress_hide
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.loadData = contentData;
        web.completeHandle = weakSelf;
        web.titleString = @"投资";
        [weakSelf.navigationController pushViewController:web animated:YES];
        [weakSelf performSelectorOnMainThread:@selector(disprocessedNextButton) withObject:nil waitUntilDone:NO];
    } failure:^(NSDictionary *error) {
        progress_hide
        NSArray *reps = error[@"resps"];
        if (reps.count > 0) {
            NSInteger errCode = [reps[0][@"result"] integerValue];
            if (errCode == 1011) {
                [weakSelf refreshCouponAndCalcInterest];
                //[weakSelf orderCalcValues];
            }else{
                NSString *msg = EMPTYSTRING_HANDLE(reps[0][@"msg"]);
                if (msg.length > 0) {
                    [Util toast:msg];
                }
            }
        }
        
        
        [self performSelectorOnMainThread:@selector(disprocessedNextButton) withObject:nil waitUntilDone:NO];
    }];
    /*
    progress_show
    [ZAPP.netEngine investWithComplete:^{
        [self setData];
        progress_hide
        [self.scrollView.header endRefreshing];

    } error:^{
        //[self loseData];
        //progress_hide
        [self connectToServer];
        [self.scrollView.header endRefreshing];

    } value:value loanid:loanid];
     */
}

- (void)complete{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)agreeeAction:(id)sender {
    self.agreeButton.selected = !self.agreeButton.selected;
    UIButton  *b = (UIButton*)sender;
    b.tag = 2011;
    [self investValChanged:b];
}
- (IBAction)checkPressed:(UIButton *)sender {
    _selectedIndex = sender.tag;
    
    [self refreshCouponAndCalcInterest];
    
    [self endEditing];
    [self updateButtons];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        _selectedIndex = -1;
        [self updateButtons];
    }
}

- (void)endEditing {
    [self.view endEditing:YES];
    [self.valTextField resignFirstResponder];
}

- (void)updateButtons {
    for (UIButton *x in self.checkBox) {
        x.selected = (x.tag == _selectedIndex);
    }
    if (_selectedIndex != -1) {
        self.valTextField.text = @"";
    }
}

- (IBAction)investValChanged:(id)sender {
    
    if ([self.valTextField.text integerValue] > 0) {
        _selectedIndex = -1;
        [self updateButtons];
    }

    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *b = (UIButton *)sender;
        if (b.tag == 2011) {
            //同意协议，不刷新红包
            [self orderCalcValues];
            return;
        }
    }
    [self refreshCouponAndCalcInterest];
    
    
    /*
    BOOL fillingCompleted = NO;
    
    if ([self.valTextField.text notEmpty] && self.agreeButton.selected) {
        fillingCompleted = YES;
    }
    self.investActionButton.enabled = fillingCompleted;
    [self.investActionButton setBackgroundColor:fillingCompleted?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
     */
}

- (void)refreshUI{
//    double totalval = [ZAPP.myuser.fabuCalDict[@"totalval"] doubleValue];
//    totalval -= [self getTouziVal];
//    NSString *valStr = [Util formatRMB:[NSNumber numberWithDouble:totalval]];
    
    double interestval = [ZAPP.myuser.fabuCalDict[@"interestval"] doubleValue];
    NSString *valStr = [Util formatRMB:[NSNumber numberWithDouble:interestval]];
    self.incomeInvestment.text = [NSString stringWithFormat:@"到期所得利息:%@", valStr];
}

- (void)refreshUIError{
    self.incomeInvestment.text = [NSString stringWithFormat:@"到期所得利息:0.00元"];
}

- (void)orderCalcValues{
    NSInteger amount = [self getTouziVal];
    NSInteger days = [self.loadDict[@"interestdaycount"] integerValue];
    double loanrate = [self.loadDict[@"loanrate"] doubleValue];
    
    if (self.selectedPackage) {
        //已经选择了投资红包
        double packageAmount = [self.selectedPackage[@"usemoney"] doubleValue];
        double realAmount = amount - packageAmount;
        self.realAmountPromptLabel.text = [NSString stringWithFormat:@"实际投资金额:%@", [Util formatRMB:@(realAmount)]];
    }else{
        self.realAmountPromptLabel.text = [NSString stringWithFormat:@"实际投资金额:%@", [Util formatRMB:@(amount)]];;
    }
    
    double interest = 0.0;
    if (self.selectedCoupon) {
        interest = [self.selectedCoupon[@"rate"] doubleValue];
        interest *= kcoupan_rate_precision;
        //loanrate += interest;
    }
    
    WS(ws);

    if (amount > 0 && days > 0) {
        [ZAPP.netEngine loanCalWithComplete:^{
            [ws performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:YES];
        } error:^{
            [ws performSelectorOnMainThread:@selector(refreshUIError) withObject:nil waitUntilDone:YES];
        } mainval:amount loanrate:loanrate couponrate:interest daycount:days];
    }else {
        [ws performSelectorOnMainThread:@selector(refreshUIError) withObject:nil waitUntilDone:YES];
    }
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{ 
    
}

- (IBAction)goingViewOfProtocol {
    
    //type=1 投资的借款协议 加息券和红包id couid bicid，投资金额
    NewLoanProtocolViewController *vc = [[NewLoanProtocolViewController alloc]init];
    vc.type = 1;
    NSInteger loanId =  [self.loadDict[@"loanid"] integerValue];
    NSInteger betval = [self getTouziVal];
    NSString *couId =  EMPTYSTRING_HANDLE(self.selectedPackage[@"couid"]);
    NSString *bicId =  EMPTYSTRING_HANDLE(self.selectedCoupon[@"bicid"]);
    vc.addtionParmas = [NSString stringWithFormat:@"loanid=%@&betval=%@&couId=%@&bicId=%@",@(loanId),@(betval),couId, bicId];
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    WebDetail *w = ZSTORY(@"WebDetail");
    w.webType = WebDetail_borrow_xuzhi;
    [self.navigationController pushViewController:w animated:YES];
     */
}

- (NSDictionary *)loadDict{
    if (! _loadDict) {
        _loadDict = nil;
    }
    return _loadDict;
}

- (void)foldUpTheKeyboard{
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];

}


-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}

- (IBAction)investAction:(id)sender{
    [self.view endEditing:YES];
    
    if (self.popup == 1) {
        [self.testingAlertView show];
        return;
    }
    
    if (self.valTextField.text.length <= 0 && [self getTouziVal] <= 0) {
        [Util toastStringOfLocalizedKey:@"tip.inputtingInvenstmentCount"];
        return;
    }
    
    double packageAmount = 0.0;
    if (self.selectedPackage) {
        packageAmount = [self.selectedPackage[@"usemoney"] doubleValue];
    }
    
    if ([self getTouziVal] > [self LeftedAmount]) {
        [Util toastStringOfLocalizedKey:@"tip.amountInvestmentGreaterLoanamount"];
        return;
    }
    
    /*
    // 不能超过余额
    //[ZAPP.myuser getAccountVal]
    if ([self getTouziVal] >[ZAPP.myuser getAccountVal]) {
        [Util toast:[NSString stringWithFormat:@"您当前余额不足，请先充值"]];
        return;
    }
    */
    
    /* 去掉100整数倍限制
    if ([self getTouziVal] %100 != 0) {

        [Util toastStringOfLocalizedKey:@"tip.inputtingIntegerMultiple"];
        return;
    }
    */
    
#ifndef TEST_TOUZI_PAGE
//    [[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];
//    if ([self getTouziVal] > _balanceVal+packageAmount)
//    {
//        NSString *info = CNLocalizedString(@"tip.balanceNotEnough", nil);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:info message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        alert.tag = 101;
//        [alert show];
//
//        return;
//    }
#endif
    
    if (! self.agreeButton.selected) {

        [Util toastStringOfLocalizedKey:@"tip.agreeLoanProtocal"];
        return;
    }

    [self connectToTouzi];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            Chongzhi *cz = ZSEC(@"Chongzhi");
            cz.level = 1;
            [self.navigationController pushViewController:cz animated:YES];
        }
    }
}

- (void)processedNextButton {
    [self.investActionButton setEnabled:NO];
    [self.investActionButton setTitle:@"处理中" forState:UIControlStateNormal];
    self.investActionButton.backgroundColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
}

- (void)disprocessedNextButton {
    [self.investActionButton setEnabled:YES];
    self.investActionButton.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
    [self.investActionButton setTitle:@"我要投资" forState:UIControlStateNormal];
}

- (IBAction)guaranteeButton:(id)sender {
    AllShouxinPeople * shouxin = ZSEC(@"AllShouxinPeople");
    NSInteger loanId =  [self.loadDict[@"loanid"] integerValue];
    [shouxin setLoanID:(int)loanId];
    [shouxin setLoanDict:self.loadDict];
    [self.navigationController pushViewController:shouxin animated:YES];
    
}

- (NSInteger)getTouziVal {
    
    NSInteger value = 0;
    
    switch (_selectedIndex) {
        case 0:
            value = 10000;
            break;
            case 1:
            value = 20000;
            break;
            case 2:
            value = 50000;
            break;
        default:
            value = [[self.valTextField text] integerValue];
            break;
    }
    
    return value;
}

- (void)continueInvest{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //去评估
        WebViewController *wvc = [[WebViewController alloc] init];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        
        CouponJSHandle *handle = [CouponJSHandle new] ;
        handle.chainedHandle = self;
        [config.userContentController addScriptMessageHandler:handle name:@"continueInvest"];
        
        wvc.webVIewConfiguration = config;
        
        
        wvc.parameterizedTitle = YES;
        wvc.urlStr = self.popUrl;
        [self.navigationController pushViewController:wvc animated:YES];
    }
    
    [_testingAlertView close];
}

-(SystemOptionsEngine *)systemEngine{
    
    if(!_systemEngine){
        _systemEngine = [[SystemOptionsEngine alloc]init];
    }
    
    return _systemEngine;
}

- (SettingEngine *)settingEngine{
    if (!_settingEngine) {
        _settingEngine = [[SettingEngine alloc] init];
    }
    return _settingEngine;
}

- (CustomTestingAlertView *)testingAlertView{
    //if (! _testingAlertView) {
        _testingAlertView = [[CustomTestingAlertView alloc] init];
        _testingAlertView.delegate = self;
    //}
    return _testingAlertView;
}

@end
