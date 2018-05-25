//
//  GuaranteeInfoViewModel.m
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentInfoViewModel.h"
#import "InvesDetailListViewController.h"
#import "BILLWebViewUtil.h"
#import "TransferCashViewController.h"

@implementation InvestmentInfoViewModel

- (instancetype)initWithLoanId:(NSUInteger)loanid betid:(NSUInteger)betid{
    
    if (self = [super initWithLoanId:loanid betid:betid billType:LoanBillTypeMyInvestment] ) {
        
        return self;
    }
    return nil;
}

- (NSAttributedString *)accountPromptString{
    return [self formatTitle1];
}

- (NSString *)accountString{
    
    //逾期
    if (self.loanState != JieKuan_FinishedAndPayed && self.isOverdue) {
        //不在宽限期
        if (! [self isGrace]) {
            return EMPTYSTRING_HANDLE([self model][@"title5"]);
        }
    }
    
    return [super accountString];
}

//投资本金
- (NSNumber *)mainvalNumber{
    return @([[self model][@"loanmainval"] doubleValue]);
}

//转让提示
- (NSString *)title4PromptString{
    return [self model][@"title4"];
}

//是否有转让功能
- (BOOL)isTransferEnabled{
    return ([[self model][@"allow_turn"] integerValue] != 2);
}

//是否可转让
- (BOOL)isTransferable{
    return ([[self model][@"allow_turn"] integerValue] == 1);
}

- (TRANSFER_OPERATION_PROGRESS)transferOperationProgress{
    return [[self model][@"ub_turn"] integerValue];
}

- (BOOL)showProtection{
    if ([self isGrace]) {
        // 宽限期内
        return  YES;
    }else if (JieKuan_FinishedAndPayed == [self loanState]) {
        return NO;
    }else if ([self isOverdue]) {
        return NO;
    }else if ([self transferOperationProgress] == TRANSFER_OPERATION_PROGRESS_OUT) {
        return NO;
    }else{
        return YES;
    }
}

- (NSArray *)actions{
    
    if (![self isOverdue]                                       &&
        [self loanState]                 == JieKuan_FinishedNow &&
        [self transferOperationProgress] == TRANSFER_OPERATION_PROGRESS_NON &&
        [self isTransferEnabled]         == YES) {
        return @[@[@"转让变现", @([self isTransferable]), @"showTransferView"]];
    }else if (JieKuan_FinishedAndPayed == [self loanState] ||
              (JieKuan_FinishedNow == [self loanState] && [self transferOperationProgress] == TRANSFER_OPERATION_PROGRESS_OUT)) {
        return @[@[@"查看我的账单", @"showBillView"]];
    }else if ([self isOverdue] && ![self isGrace]) {
        return @[@[@"催收进展", @"showProgress"]];
    }else{
        return nil;
    }
}

- (void)showTransferView{
    TransferCashViewController *tsf = SENDLOANSTORY(@"TransferCashViewController");
    tsf.betId = [self betid];
    [self.vc.navigationController pushViewController:tsf animated:YES];
}

- (NSString *)headImageName{
    if ([self transferOperationProgress]!=TRANSFER_OPERATION_PROGRESS_OUT &&
        [self isOverdue] &&
        ![self isGrace]) {
        //返回头像
        return [self loanuserheadimg];
    }else{
        return @"win_big.png";
    }
}

- (void)showProgress{
    //NSLog(@"催收进展");
    [BILLWebViewUtil presentOverdueCollection:[self loanId] vc:self.vc];
}

- (void)pushDetailView{
    //投资详情
    InvesDetailListViewController *detail = (InvesDetailListViewController *)[DetailListViewController listDetailWith:@"B" loanid:self.loanId];
    detail.betId = [self betid];
    [self.vc.navigationController pushViewController:detail animated:YES];
}

- (NSAttributedString *)formatTitle1{
    if ( [self transferOperationProgress]!=TRANSFER_OPERATION_PROGRESS_OUT &&
         [self isOverdue] &&
        ![self isGrace]) {
        return [Util getAttributedString:EMPTYSTRING_HANDLE([self model][@"title1"]) font:CNFont_34px color:CN_UNI_RED];
    }else{
        return [Util getAttributedString:EMPTYSTRING_HANDLE([self model][@"title1"]) font:CNFont_34px color:CN_TEXT_BLACK];
    }
    
    
}

@end
