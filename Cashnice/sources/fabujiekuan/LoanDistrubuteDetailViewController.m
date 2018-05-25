//
//  LoanDistrubuteDetailViewController.m
//  YQS
//
//  Created by a on 16/1/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanDistrubuteDetailViewController.h"
#import "SendLoanViewController.h"
#import "RTLabel.h"

@interface LoanDistrubuteDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *loanorderLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@end

@implementation LoanDistrubuteDetailViewController

BLOCK_NAV_BACK_BUTTON
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"借款成功预览"];
    [self setTitle:@"借款详情"];
    [self setNavButton];
    
    
    //[self refreshUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"借款成功预览"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshUI];
}

- (void)customNavBackPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refreshUI{
    NSInteger amount = [self.loanDict[@"loanmainval"] integerValue];
    NSString *amountStr = [Util formatRMB:[NSNumber numberWithInteger:amount]];
    
    self.amountLabel.text = amountStr;
    
    //标号
    NSString *loantitle = self.loanDict[@"loantitle"];
    self.orderIdLabel.text = loantitle;
    
    //发布时间
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *timeString= [formatter stringFromDate:date];
//    
    self.timelabel.text = self.loanDict[@"loancreatetime"];
    
    //借款单号
    NSString *loanorderno = self.loanDict[@"loanorderno"];
    self.loanorderLabel.text = loanorderno;
    
    NSInteger loanstate = [self.loanDict[@"loanstatus"] integerValue];
    if (loanstate == -3) {
        self.infoLable.text = @"您的借款正在担保确认中";
    }
}

- (IBAction)completeAction:(id)sender {
//    NSArray *vcs = self.navigationController.viewControllers;
//    if (vcs.count >= 2) {
//        UIViewController *vc = vcs[vcs.count-1 -1];
//        if ([vc isKindOfClass:[SendLoanViewController class]]) {
//            SendLoanViewController *xz = (SendLoanViewController *)vc;
//            [xz refreshUILoanComplete];
//            [self.navigationController popToViewController:xz animated:YES];
//        }
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self customNavBackPressed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
