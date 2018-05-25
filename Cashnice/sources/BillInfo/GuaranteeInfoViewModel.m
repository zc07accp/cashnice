//
//  GuaranteeInfoViewModel.m
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaranteeInfoViewModel.h"
#import "RepaymentViewController.h"
#import "DetailListViewController.h"
#import "BILLWebViewUtil.h"

@implementation GuaranteeInfoViewModel

- (instancetype)initWithLoanId:(NSUInteger)loanid{
    if (self = [super initWithLoanId:loanid billType:LoanBillTypeMyGuarantee] ) {
        return self;
    }
    return nil;
}

- (NSString *)headImageName{
    if ([self isOverdue] && ![self isGrace]) {
        //返回头像
        return [self loanuserheadimg];
    }else{
        return @"win_big.png";
    }
}

- (NSAttributedString *)accountPromptString{
    return [self formatTitle1];
}
- (BOOL)showProtection{
    if ([self isGrace]) {
        // 宽限期内
        return  YES;
    }else{
        return ![self isOverdue] &&
            (JieKuan_GoingNow == [self loanState] || JieKuan_FinishedNow == [self loanState]);
    }
}

- (NSArray *)actions{
    if (JieKuan_FinishedAndPayed == [self loanState]) {
        return nil;
    }
    
    if ([self isOverdue] && ![self isGrace]) {
        if (0 == [self isdeducted]) {
            //逾期中，未支付担保金
            return @[[self payForGuaranteeAction], [self showConsequenceAction]];
        }else{
            return @[[self showConsequenceAction]];
        }
    }else{
        return nil;
    }
}

- (NSArray *)payForGuaranteeAction{
    return @[@"立即支付担保金", @"payForGuarantee"];
}

- (NSArray *)showConsequenceAction{
    return @[@"了解逾期后果", @"showConsequence"];
}

- (NSInteger)isdeducted{
    return [[self model][@"isdeducted"] integerValue];
}

- (void)payForGuarantee{
    //NSLog(@"立即支付担保金");
    RepaymentViewController *h = ZLOAN(@"RepaymentViewController");
    h.dataDict = [self model];
    h.repaymentType = RepaymentViewTypeGuarantee;
    [self.vc.navigationController pushViewController:h animated:YES];
}

- (void)showConsequence{
    //NSLog(@"了解逾期后果");
    [BILLWebViewUtil presentOverdueRulesFrom:self.vc];
}

- (void)pushDetailView{
    //担保详情
    DetailListViewController *detail = [DetailListViewController listDetailWith:@"W" loanid:self.loanId];
    [self.vc.navigationController pushViewController:detail animated:YES];
    
}

- (NSAttributedString *)formatTitle1{
    if ([self isOverdue] && ![self isGrace]) {
        if (2 == [self isdeducted] || JieKuan_FinishedAndPayed == [self loanState]) {
            //担保金已退款
            NSString *str = [NSString stringWithFormat:@"%@已全部还清本次借款，收回担保金", [self loanusername]];
            NSMutableAttributedString *attStr = [Util getAttributedString:str font:CNFont_34px color:CN_TEXT_BLACK];
            [Util setAttributedString:attStr font:CNFont_34px color:CN_UNI_RED substr:[self loanusername] allstr:str];
            return attStr;
        }else if(1 == [self isdeducted]){
            //逾期中，已成功支付担保金
            NSString *str = [NSString stringWithFormat:@"%@已逾期%zd天，担保金为", [self loanusername], [self latedays]];
            NSMutableAttributedString *attStr = [Util getAttributedString:str font:CNFont_34px color:CN_TEXT_BLACK];
            [Util setAttributedString:attStr font:CNFont_34px color:CN_UNI_RED substr:[self loanusername] allstr:str];
            [Util setAttributedString:attStr font:CNFont_34px color:CN_UNI_RED substr:[NSString stringWithFormat:@"%zd", [self latedays]] allstr:str];
            return attStr;
        }else{
            //逾期中，未支付担保金
            NSString *str = [NSString stringWithFormat:@"%@已逾期%zd天，请立即支付担保金", [self loanusername], [self latedays]];
            NSMutableAttributedString *attStr = [Util getAttributedString:str font:CNFont_34px color:CN_TEXT_BLACK];
            [Util setAttributedString:attStr font:CNFont_34px color:CN_UNI_RED substr:[self loanusername] allstr:str];
            [Util setAttributedString:attStr font:CNFont_34px color:CN_UNI_RED substr:[NSString stringWithFormat:@"%zd", [self latedays]] allstr:str];
            return attStr;
        }
    }else{
        return [Util getAttributedString:[self model][@"title1"] font:CNFont_34px color:CN_TEXT_BLACK];
    }
}

@end
