//
//  ChongzhiViewController.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ChongzhiViewController.h"
#import "Chongzhi.h"
#import "TiXian.h"
#import "BankChoose.h"
#import "CustomIOSAlertView.h"
#import "ShowCardViewController.h"
#import "SinaWithdrawViewController.h"
#import "SinaRechargeViewController.h"
#import "RedMoneyListViewController.h"
#import "AllMoneyTipAlertView.h"

@interface ChongzhiViewController () <CustomIOSAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chongzhiButton;
@property (weak, nonatomic) IBOutlet UIButton *tixianButton;
//@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *biaotiArray;
//@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *moneyArray;
//@property (strong, nonatomic)IBOutletCollection(UILabel) NSArray *timeArray;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_content_width;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_left_width;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_button_width;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_right_width;

@property (weak, nonatomic) IBOutlet UILabel *totalAssetLabel; //总资产
@property (weak, nonatomic) IBOutlet UILabel *yesProfitLabel; //昨日收益

@property (weak, nonatomic) IBOutlet UILabel *label1; //可用余额
@property (weak, nonatomic) IBOutlet UILabel *label2; //可用红包
@property (weak, nonatomic) IBOutlet UILabel *label3; //可用加息券

@property (weak, nonatomic) IBOutlet UIView *label123Bk;


//@property (weak, nonatomic) IBOutlet UILabel *m1;
//@property (weak, nonatomic) IBOutlet UILabel *m2;
@property (weak, nonatomic) IBOutlet UILabel *m3;
//@property (weak, nonatomic) IBOutlet UILabel *m4;
//@property (weak, nonatomic) IBOutlet UILabel *m5;
//@property (weak, nonatomic) IBOutlet UILabel *d1;
//@property (weak, nonatomic) IBOutlet UILabel *d2;
//@property (weak, nonatomic) IBOutlet UILabel *l1;
//@property (weak, nonatomic) IBOutlet UILabel *l2;


@property (strong, nonatomic) NSDictionary *dataDict;
@end

@implementation ChongzhiViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.con_content_width.constant = [ZAPP.zdevice getDesignScale:390];
//    self.con_button_width.constant = [ZAPP.zdevice getDesignScale:160];
//    self.con_left_width.constant = [ZAPP.zdevice getDesignScale:20];
//    self.con_right_width.constant = [ZAPP.zdevice getDesignScale:20];

//	self.chongzhiButton.titleLabel.font = [UtilFont system:17];
//	self.tixianButton.titleLabel.font   = [UtilFont system:17];
//	[self.chongzhiButton setTitleColor:ZCOLOR(COLOR_BUTTON_RED) forState:UIControlStateNormal];
//	[self.chongzhiButton setTitleColor:ZCOLOR(COLOR_BUTTON_RED_CLICK) forState:UIControlStateHighlighted];
//	[self.tixianButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
//	[self.tixianButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE_CLICK) forState:UIControlStateHighlighted];

//    self.chongzhiButton.layer.cornerRadius = 5;self.chongzhiButton.layer.masksToBounds = YES;
//    self.tixianButton.layer.cornerRadius = 5;self.tixianButton.layer.masksToBounds = YES;
//
//	for (UILabel *lb in self.biaotiArray) {
//		lb.textColor = ZCOLOR(COLOR_TEXT_BLACK);
//		lb.font      = [UtilFont systemLarge];
//	}
//
//    int i = 0;
//	for (UILabel *lb in self.moneyArray) {
//        if (i < 2) {
//		lb.textColor = ZCOLOR(COLOR_TEXT_GRAY);
//        }
//        else if (i == 2) {
//		lb.textColor = ZCOLOR(COLOR_BUTTON_RED);
//            
//        }
//        else {
//		lb.textColor = [DefColor bgGreenColor];
//            
//        }
//		lb.font      = [UtilFont systemLarge];
//        
//        i++;
//	}
//
//	for (UILabel *lb in self.timeArray) {
//		lb.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
//		lb.font      = [UtilFont systemLarge];
//	}
//    
    
    NSDictionary *bankCards =  ZAPP.myuser.bankcardListRespondDict;
    if (! bankCards) {
        progress_show
        [ZAPP.netEngine getUserBankcardListWithComplete:^{
            progress_hide;
        } error:^{
            progress_hide;
        }];
    }
    
    
    
    
}

- (void)uiLabels {

    CGFloat money3 = [[self.dataDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue];

    if (ScreenWidth320) {
        self.totalAssetLabel.font = [UIFont systemFontOfSize:20];
        self.yesProfitLabel.font = [UIFont systemFontOfSize:20];
        
        [self.label123Bk mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@57);
        }];
    }
    
    
    self.totalAssetLabel.text = [Util formatRMBWithoutUnit:@([EMPTYOBJ_HANDLE(ZAPP.myuser.gerenInfoDict[@"total_assets"]) doubleValue])];
    self.yesProfitLabel.text = [@"+" stringByAppendingString:[Util formatRMBWithoutUnit:@([EMPTYOBJ_HANDLE(ZAPP.myuser.gerenInfoDict[@"yesterday_profit"]) doubleValue])]];
    
 
    self.label1.text = [NSString stringWithFormat:@"账户余额(元)\n%@", [Util formatRMBWithoutUnit:@(money3)]];
    self.label2.text = [NSString stringWithFormat:@"可用红包(个)\n%@", ZAPP.myuser.gerenInfoDict[@"redcoupon"]];
    self.label3.text = [NSString stringWithFormat:@"可用优惠券(个)\n%@",ZAPP.myuser.gerenInfoDict[@"interestcoupon"]];

    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setTheData:(NSDictionary *)dict {
    self.dataDict = dict;
    [self uiLabels];
    
}

//体现的提示
- (void)showTixianAlertView{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.tixianViewController", nil) closeDelegate:self buttonTitles:@[@"去绑定", @"取消"]];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
}

//充值的提示
- (void)showChongzhiAlertView{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.chongzhiViewController", nil) closeDelegate:self buttonTitles:@[@"去绑定", @"取消"]];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
}

- (void)customIOS7dialogButtonTouchUpInside:(CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 1) {
        if (alertView.tag == 0) {
            //绑定银行卡
            [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
        }
    }
    [alertView close];
}

- (IBAction)chongzhipressed:(id)sender {
    
//#ifdef TEST_TEST_SERVER
//    return;
//#endif
    
#ifdef TEST_CHONGZHI_PAGE
    Chongzhi *c = ZSEC(@"Chongzhi");
    c.delegate = self.delegate;
    c.level = 1;
    [self.navigationController pushViewController:c animated:YES];
    return;
#endif
    
    /*
    if ([ZAPP.myuser hasBankBinded]) {
    }
    else {
        [self showBindAlertView];
        return;
    }
    */

    if ([ZAPP.myuser hasBankBinded]) {                   //if ([ZAPP.myuser hasDefaultBank]) {
        // 选择银行卡
        //BankChoose *e = ZSEC(@"BankChoose");
        //[self.navigationController pushViewController:e animated:YES];
        SinaRechargeViewController *recharge = ZSEC(@"SinaRechargeViewController");
        [self.navigationController pushViewController:recharge animated:YES];
    }
    else {
        [self showChongzhiAlertView];
        return;
    }
    
    /* */
}
- (IBAction)tixianpressed:(id)sender {
    
    
    if ([ZAPP.myuser hasBankCardNumber]) {
        if (![ZAPP.myuser hasMoneyInAccount]) {

            [Util toastStringOfLocalizedKey:@"tip.hasMoneyInAccountEmpty"];
            return; 
        }
        SinaWithdrawViewController *withdraw = ZSEC(@"SinaWithdrawViewController");
        [self.navigationController pushViewController:withdraw animated:YES];
        //TiXian *chong = ZSEC(@"TiXian");
        //[self.navigationController pushViewController:chong animated:YES];
    }
    else {
        [self showTixianAlertView];
        return;
    }
    /* */
}

//红包
- (IBAction)seeRedPacket:(id)sender {
    
    RedMoneyListViewController *vc = REDSTORY(@"RedMoneyListViewController");
    [vc setValue:@(REDMONEY_TYPE_CASH) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
 }

//我的优惠券
- (IBAction)seeRedInterest:(id)sender {
    
    RedMoneyListViewController *vc = REDSTORY(@"RedMoneyListViewController");
    [vc setValue:@(REDMONEY_TYPE_ALLINTEREST) forKey:@"type"];
    [self.navigationController pushViewController:vc animated:YES];
}

//总资产介绍
- (IBAction)seeTotalAssetsInfo:(id)sender {
    //    NSString *userid = [self.dataDict objectForKey:NET_KEY_USERID];
    //    if ([userid notEmpty]) {
    //        __weak __typeof__(self) weakSelf = self;
    //
    //     [ZAPP.netEngine getUserInfoWithComplete:^{
    //         [weakSelf setData];
    //         progress_hide
    //
    //     }
    //     error:^{
    //             //[weakSelf loseData];
    //             progress_hide
    //         } userid:userid];
    //    }
    [self setData];
}

- (void) setData{
    NSDictionary *dict =  ZAPP.myuser.gerenInfoDict;
    AllMoneyTipAlertView *alertView =[[AllMoneyTipAlertView alloc] initWithTitle:@"总资产（元）"andInfo:CNLocalizedString([Util formatRMBWithoutUnit:@([EMPTYOBJ_HANDLE(ZAPP.myuser.gerenInfoDict[@"total_assets"]) doubleValue])],nil) andInfo1:CNLocalizedString([Util formatRMBWithoutUnit:@([[self.dataDict objectForKey:NET_KEY_ACCOUNTVAL] doubleValue])],nil) andInfo2:CNLocalizedString([Util formatRMBWithoutUnit:@([EMPTYOBJ_HANDLE(dict[@"waiting_principal"]) doubleValue])],nil) msgTextAli:NSTextAlignmentCenter];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
    alertView.bkColor = [UIColor whiteColor];
    //alertView.messageTextColor = CN_TEXT_GRAY;
    alertView.hideHeadline = YES;
}

@end
