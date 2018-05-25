//
//  RepaymentViewController.m
//  YQS
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "RepaymentViewController.h"
#import "ServiceMessageViewController.h"
#import "MyLoansListViewController.h"
#import "SinaCashierWebViewController.h"
#import "SinaCashierModel.h"
#import "BillInfoViewController.h"

typedef NS_ENUM(NSUInteger, RepaymentProcessType) {
    RepaymentProcessTypeNone,
    RepaymentProcessTypeAuth,
    RepaymentProcessTypeRepay,
};

@interface RepaymentViewController () <HandleCompletetExport> {
    NSString *_confirmButtonTitle;
    double _repayValue ;
}

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaymentCountlabel;
@property (weak, nonatomic) IBOutlet UILabel *balancelabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanlabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (assign, nonatomic) RepaymentProcessType repaymentProcessType;


- (IBAction)repaymentActionButton:(id)sender;
@end

@implementation RepaymentViewController
BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNavButton];
    
    [self createUI];
    
    [self connectToServer];
}

- (void)createUI{
    self.confirmButton.titleLabel.font  = CNFont_32px;
    self.repaymentCountlabel.font       = CNFont_34px;
    self.contentLabel.font              = CNFont_58px;
    self.yuanlabel.font                 = CNFont_28px;
    self.balancelabel.font              = CNFont_28px;
    
    NSString *countString ;
    if (self.repaymentType == RepaymentViewTypeGuarantee) {
        //担保金还款
        _repayValue = [self.dataDict[@"money"] doubleValue];
        countString = @"当前有1笔借款，需要您支付担保金";
        _confirmButtonTitle = @"确定支付";
    }else{
        //借款还款
        _repayValue = [self.dataDict[@"money"] doubleValue];
        countString = @"当前有1笔应还款，本息共计";
        _confirmButtonTitle = @"确定还款";
    }
    
    self.contentLabel.text =[NSString stringWithFormat:@"%@", [Util formatRMBWithoutUnit:@(_repayValue)]];
    self.repaymentCountlabel.text = countString;
    double balance = 0;//[ZAPP.myuser getAccountVal];
    self.balancelabel.text = [NSString stringWithFormat:@"您的账户余额为%@，请确保您的账户余额资金充足！", [Util formatRMB:@(balance)]];
    
    [self.confirmButton setTitle:_confirmButtonTitle forState:UIControlStateNormal];
    
    self.title = self.dataDict[@"loantitle"] ;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.repaymentProcessType == RepaymentProcessTypeAuth){
        [self repaymentAfterAuth];
    }
}

- (void)connectToServer {
    progress_show
    
    WS(ws);

    [ZAPP.netEngine getWithDrawLimit:0 complete:^{
        progress_hide
        NSDictionary *limtDcit = ZAPP.myuser.withdrawLimitRespondDict;
        double balance = [limtDcit[@"balance"] doubleValue];
        ws.balancelabel.text = [NSString stringWithFormat:@"您的账户余额为%@，请确保您的账户余额资金充足！", [Util formatRMB:@(balance)]];
    } error:^{
        progress_hide
        ;
    }];
}

- (IBAction)repaymentActionButton:(id)sender {
    
if (self.repaymentType == RepaymentViewTypeGuarantee) {
        //担保金还款
        [self guarantee];
    }else{
        //借款还款
        [self repayment];
    }
    
    /*
    [self processedNextButton];
    
    NSString *nextdebtid = [NSString stringWithFormat:@"%ld", [self.dataDict[@"debtid"] integerValue]];//nextdebtid
    NSString *nextdebtrepayval = [NSString stringWithFormat:@"%@", @([self.dataDict[@"money"] doubleValue])];//nextdebtrepayval
    
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    __weak typeof(self) weakSelf = self;
    progress_show
    [self disprocessedNextButton];
    [model repaymentAction:nextdebtrepayval loanId:nextdebtid success:^(NSData *contentData) {
        progress_hide
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.loadData = contentData;
        web.titleString = @"还款";
        web.completeHandle = weakSelf;
        [weakSelf.navigationController pushViewController:web animated:YES];
    } failure:^(NSString *error) {
        progress_hide
        [self disprocessedNextButton];
    }];
    */
    /*
    [ZAPP.netEngine huankuanWithComplete:^{
        [self setData];
        progress_hide
    } error:^{
        //[self loseData];
        progress_hide
        [self disprocessedNextButton];
    } value:nextdebtrepayval debtid:nextdebtid];
     */
}

- (void)guarantee{
    [self processedNextButton];
    
    NSString *ulw_id = [NSString stringWithFormat:@"%zd", [self.dataDict[@"ulw_id"] longValue]];
    NSString *money = [NSString stringWithFormat:@"%@", @([self.dataDict[@"money"] doubleValue])];
    
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    __weak typeof(self) weakSelf = self;
    progress_show
    [self disprocessedNextButton];
    [model guaranteeAction:money loanId:ulw_id success:^(NSData *contentData) {
        progress_hide
        self.repaymentProcessType = RepaymentProcessTypeRepay;  //处理同还款
        [weakSelf pushSinaCashierWithResult:contentData andContent:nil];
    } failure:^(NSString *error) {
        progress_hide
        [weakSelf disprocessedNextButton];
    }];
}

- (void)repayment{
    [self processedNextButton];
    
    NSString *debtid = [NSString stringWithFormat:@"%ld", [self.dataDict[@"debtid"] longValue]];
    NSString *money = [NSString stringWithFormat:@"%@", @([self.dataDict[@"money"] doubleValue])];
    
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    __weak typeof(self) weakSelf = self;
    progress_show
    [self disprocessedNextButton];
    [model repaymentAction:money loanId:debtid success:^(NSData *contentData, NSString *contentString) {
        progress_hide
        [weakSelf pushSinaCashierWithResult:contentData andContent:contentString];
    } failure:^(NSString *error) {
        progress_hide
        [weakSelf disprocessedNextButton];
    }];
}


- (void)repaymentAfterAuth{
    [self processedNextButton];
    
    NSString *debtid = [NSString stringWithFormat:@"%ld", [self.dataDict[@"debtid"] longValue]];
    NSString *money = [NSString stringWithFormat:@"%@", @([self.dataDict[@"money"] doubleValue])];
    
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    __weak typeof(self) weakSelf = self;
    //progress_show
    [self disprocessedNextButton];
    [model repaymentAction:money loanId:debtid success:^(NSData *contentData, NSString *contentString) {
        progress_hide
        if (contentString.length > 1) {
            
        }else{
            [weakSelf pushSinaCashierWithResult:contentData andContent:contentString];
        }
    } failure:^(NSString *error) {
        progress_hide
        [weakSelf disprocessedNextButton];
    }];
}

- (void)pushSinaCashierWithResult:(NSData *)contentData andContent:(NSString *)contentString{
    
    SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
    
    if (contentData) {
        self.repaymentProcessType = RepaymentProcessTypeRepay;
        web.loadData = contentData;
    }else if(contentString){
        self.repaymentProcessType = RepaymentProcessTypeAuth;
        web.URLPath = contentString;
    }
    web.completeHandle = self;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)complete{
    self.navigationController.navigationBarHidden = NO;
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (self.repaymentProcessType == RepaymentProcessTypeRepay) {
        self.repaymentProcessType = RepaymentProcessTypeNone;
        if (viewControllers.count > 1) {
            for (UIViewController *vc  in viewControllers) {
                if ([vc isKindOfClass: [BillInfoViewController class]]
                    //  || [vc isKindOfClass: [ServiceMessageViewController class]]
                    ) {
                    [self performSelectorOnMainThread:@selector(pushBillInfoView:) withObject:vc waitUntilDone:YES];
                    return;
                }
            }
            [super customNavBackPressed];
        }
    }else if (self.repaymentProcessType == RepaymentProcessTypeAuth){
        //self.repaymentProcessType = RepaymentProcessTypeNone;
        [super customNavBackPressed];
    }
    
}

- (void)processedNextButton {
    [self.confirmButton setEnabled:NO];
    self.confirmButton.backgroundColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    [self.confirmButton setTitle:@"处理中" forState:UIControlStateNormal];
}

- (void)disprocessedNextButton {
    [self.confirmButton setEnabled:YES];
    self.confirmButton.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
    [self.confirmButton setTitle:_confirmButtonTitle forState:UIControlStateNormal];
}

- (void)setData{
    [Util toastStringOfLocalizedKey:@"tip.repaymentProcessing"];
    [self customNavBackPressed];
}

//- (void)customNavBackPressed{
//    self.navigationController.navigationBarHidden = NO;
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    if (viewControllers.count > 1) {
//        for (UIViewController *vc  in viewControllers) {
//            if ([vc isKindOfClass: [BillInfoViewController class]]
//                //  || [vc isKindOfClass: [ServiceMessageViewController class]]
//                ) {
//                [self performSelectorOnMainThread:@selector(pushBillInfoView:) withObject:vc waitUntilDone:YES];
//                return;
//            }
//        }
//        [super customNavBackPressed];
//    }
//}

- (void)pushBillInfoView:(UIViewController *)vc{
    self.navigationController.navigationBarHidden = NO;
    [(BillInfoViewController *)vc refreshViewAndDelay];//刷新状态
    [self.navigationController popToViewController:vc animated:YES];
}

@end
