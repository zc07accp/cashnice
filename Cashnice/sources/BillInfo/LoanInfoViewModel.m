//
//  GuaranteeInfoViewModel.m
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanInfoViewModel.h"
#import "RepaymentViewController.h"
#import "DetailListViewController.h"
#import "BILLWebViewUtil.h"

@implementation LoanInfoViewModel

- (instancetype)initWithLoanId:(NSUInteger)loanid{
    if (self = [super initWithLoanId:loanid billType:LoanBillTypeMyLoan] ) {
        return self;
    }
    return nil;
}

- (NSAttributedString *)accountPromptString{
    return [self formatTitle1];
}

- (NSString *)startPromptText{
    if (JieKuan_WaitingNow == [self loanState] || -2 == (int)[self loanState]) {
        return @"提交日";
    }else{
        return @"发布日";
    }
}

- (BOOL)showProtection{
    return JieKuan_WaitingNow == [self loanState] ||
                            -2 == (int)[self loanState] ||
                            -3 == (int)[self loanState] ;
}
- (NSArray *)actions{
    
    if ([self isOverdue] && JieKuan_FinishedNow != [self loanState]) {
        return [self showRepayAction];
    }
    
    if (-3 == (int)[self loanState]) {
        
        double canLoan = [[self model][@"can_loan"] doubleValue];
        
        return @[@[@"确认借款",canLoan>0?@(YES):@(NO), @"canLoanAction"],
                @[@"取消借款", @"closeLoan"]];
    }
    
    if (JieKuan_GoingNow == [self loanState]) {
        return @[@[@"不借了", @"closeLoan"]];
    }else if (JieKuan_FinishedAndPayed == [self loanState]){
        return @[@[@"查看我的账单", @"showBillView"]];
    }else if (JieKuan_FinishedNow == [self loanState]){
        return [self showRepayAction];
    }
    return nil;
}

- (void)canLoanAction{
    NSLog(@"确认借款");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认借款？"message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    [alert show];
}

- (void)repayAction{
    RepaymentViewController *h = ZLOAN(@"RepaymentViewController");
    h.dataDict = [self model];
    [self.vc.navigationController pushViewController:h animated:YES];
}
- (void)closeLoan{
    //NSLog(@"不借了");
    if (1 == [self loanState] || -3 == (int)[self loanState]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.myLoanDetailVC", nil) message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
    }
}
- (void)showConsequence{
    //NSLog(@"了解逾期后果");
    [BILLWebViewUtil presentOverdueRulesFrom:self.vc];
}
- (NSArray *)showRepayAction{
    return @[@[@"立即还款", @"repayAction"],
             @[@"了解逾期后果", @"showConsequence"]];
}

//#import "BillViewController.h"
//- (void)showBillView{
//    //我的账单
//    NSArray *vcs = self.vc.navigationController.viewControllers;
//    for (UIViewController *vc in vcs) {
//        if ([vc isKindOfClass:[BillViewController class]]) {
//            [self.vc.navigationController popToViewController:vc animated:YES];
//            return;
//        }
//    }
//    UIViewController *bill = ZBill(@"BillViewController");
//    [self.vc.navigationController pushViewController:bill animated:YES];
//}

- (NSString *)headImageName{
    
    if ([self isGrace]) {
        // 宽限期内
        return @"prompt_yellow.png";
    }
    
    if (JieKuan_FinishedAndPayed == [self loanState]) {
        return @"win_big.png";
    }else{
        if ([self isOverdue]) {
            return @"overdue_red.png";
        }
    }
    
    if (-3 == (int)[self loanState]) {
        return @"wait_danbao.png";
    }
    
    NSString *imageName;
    switch ([self loanState]) {
        case JieKuan_WaitingNow:
        {
            imageName = @"pending.png";
            break;
        }
        case  -2:
        {
            imageName = @"pending.png";
            break;
        }
        case JieKuan_GoingNow:
        {
            imageName = @"already.png";
            break;
        }
        case JieKuan_FinishedNow:
        {
            imageName = [self islastday] ? @"prompt_yellow.png" : @"time.png";
            break;
        }
        default:
            break;
    }
    return imageName;
}

- (void)pushDetailView{
    //借款详情
    DetailListViewController *detail = [DetailListViewController listDetailWith:@"L" loanid:self.loanId];
    [self.vc.navigationController pushViewController:detail animated:YES];
}

- (NSAttributedString *)formatTitle1{
    if ([self isOverdue] && ![self isGrace]) {
        NSString *str = [NSString stringWithFormat:@"已逾期%zd天，请立即还款",[self latedays]];
        NSMutableAttributedString *attStr = [Util getAttributedString:str font:CNFont_34px color:CN_TEXT_BLACK];
        [Util setAttributedString:attStr font:CNFont_34px color:CN_UNI_RED substr:[NSString stringWithFormat:@"%zd", [self latedays]] allstr:str];
        return attStr;
    }else{
        return [Util getAttributedString:[self model][@"title1"] font:CNFont_34px color:CN_TEXT_BLACK];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            // 关闭借款
            bugeili_net
            BOOL _isNavigationBack = NO;
            progress_show
            [ZAPP.netEngine closeTheLoanWithComplete:^{
                
                progress_hide
                [Util toastStringOfLocalizedKey:@"tip.loanOff"];
                [self.vc.navigationController popViewControllerAnimated:YES];
                
            } error:^{
                progress_hide
            } loanid:[NSString stringWithFormat:@"%zd", self.loanId] ];
        }
    }else if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            double canLoan = [[self model][@"can_loan"] doubleValue];
            LoanDetailEngine *engine = [[LoanDetailEngine alloc] init];
            WS(weakSelf);
            [engine postConfirmLoan:self.loanId value:canLoan success:^(NSDictionary *detail) {
                [weakSelf.vc.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                ;
            }];
        }
    }
    
}

@end
