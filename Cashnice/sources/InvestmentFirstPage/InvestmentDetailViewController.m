//
//  InvestmentDetailViewController.m
//  YQS
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentDetailViewController.h"
#import "AllShouxinPeople.h"

@interface InvestmentDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton   * completeButton;

@property (weak, nonatomic) IBOutlet UILabel    * promptOrderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel    * promptTimelabel;
@property (weak, nonatomic) IBOutlet UILabel    * promptLoanorderLabel;

@property (strong, nonatomic) NSDictionary *reponseDict;

@end

@implementation InvestmentDetailViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavButton];
    
    [self setupUI];
    
    [self connectToServer];
    self.completeButton.titleLabel.font = [UtilFont systemButtonTitle];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"投资成功预览"];
    self.title = @"投资详情";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"投资成功预览"];
}

- (void)connectToServer {
    progress_show
    
    WS(ws);

    [ZAPP.netEngine getBetDetailWithBetid:self.betid complete:^{
        progress_hide
        SS(strongSelf, ws)
        
        NSDictionary *dict = ZAPP.myuser.gerenBetDetail;
        //借款标号
        strongSelf.orderIdLabel.text = dict[@"loan"][@"loantitle"];
        //投资时间
        NSString *bettime = dict[@"bettime"];
        strongSelf.timelabel.text = bettime;
        //金额
        double betval = [dict[@"betval"] doubleValue];
        strongSelf.amountLabel.text = [Util formatRMBWithoutUnit:@(betval)];
        //投资订单号
        NSString *orderno = dict[@"orderno"];
        strongSelf.loanorderLabel.text = orderno;
    } error:^{
        progress_hide
    }];
}

- (void)setupUI {
    
    self.orderIdLabel.font =
    self.timelabel.font =
    self.loanorderLabel.font =
    self.promptLoanorderLabel.font =
    self.promptTimelabel.font =
    self.promptOrderIdLabel.font =
    self.completeButton.titleLabel.font = [UtilFont systemLargeNormal];
    
    
    
}

- (void)customNavBackPressed {
    
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[AllShouxinPeople class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)completeAction:(id)sender {
    
    //跳转到投资首页
    [self customNavBackPressed];
    
    /*
    NSArray *vcs = self.navigationController.viewControllers;
    if (vcs.count >=2 ) {
        NSUInteger sourceIdx = vcs.count - 2;
        if (vcs.count > sourceIdx) {
            UIViewController *s = vcs[sourceIdx];
            [self.navigationController popToViewController:s animated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
     */
}

@end
