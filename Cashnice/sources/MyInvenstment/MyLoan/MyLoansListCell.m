//
//  MyLoansListCell.m
//  YQS
//
//  Created by a on 16/5/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyLoansListCell.h"

@interface MyLoansListCell ()
{
}

@end

@implementation MyLoansListCell



- (void)updateForLoan:(NSDictionary *)loan {
    
    NSDictionary *itemDict = loan;
    
    self.loanTitleLabel.text = itemDict[@"loantitle"];
    
    NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
    
    //借款金额
    CGFloat mainVale = [itemDict[@"loanmainval"] integerValue];
    //计划借款金额
    self.mainValueLabel.text = [Util formatRMBWithoutUnit:@(mainVale)];
    
    //
    self.daysLeftLabel.text = itemDict[@"loanstatuslabel"];
    
    //利率
    self.valueRateLabel.text = [NSString stringWithFormat:@"%@", [Util formatFloat:@([itemDict[@"loanrate"] doubleValue])]];
    
    //逾期
    NSInteger isoverdue = [itemDict[@"isoverdue"] integerValue];
    
    if (loanstatus == -3) {
        //担保确认中
        self.promptInterestLabel.text = @"借款天数";
        self.PromptDistributionTimeLable.text = @"提交日";
        //利息
        self.valueInterestLable.text = [NSString stringWithFormat:@"%@天", itemDict[@"interestdaycount"]];
        self.interestYuanLabel.hidden = YES;
    }else{
        self.promptInterestLabel.text = @"利息";
        self.PromptDistributionTimeLable.text = @"发布日期";
        //利息
        self.valueInterestLable.text = [Util formatRMBWithoutUnit:@([itemDict[@"repayableinterestval"] doubleValue])];
        self.interestYuanLabel.hidden = NO;
    }
    
    if (isoverdue == 1) {
        //宽限期
        NSInteger isgrace = [itemDict[@"isgrace"] integerValue];
        if (isgrace) {
            self.thelastImage.image = [UIImage imageNamed:@"period"];
        }else{
            self.thelastImage.image = [UIImage imageNamed:@"overdue"];
        }
        
        //逾期
        self.loanStatusLabel.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
        self.loanStatusLabel.text = itemDict[@"loanUser"];
        self.loanStatusLabel.hidden = NO;
    }else {
        //未逾期
        self.loanStatusLabel.hidden = YES;
        
        if (loanstatus == 2) {
            //借款已满
            self.thelastImage.image = [UIImage imageNamed:@"thelast"];
        }else if (loanstatus == 1) {
            //筹款中
            self.thelastImage.image = [UIImage imageNamed:@"fundraising"];
        }else if (loanstatus == 3) {
            //完成还款
            self.thelastImage.image = [UIImage imageNamed:@"finish"];
        }else if (loanstatus == 7) {
            //关闭中
            self.thelastImage.image = [UIImage imageNamed:@"closing"];
        }else if (loanstatus == 0) {
            //审核中
            self.thelastImage.image = [UIImage imageNamed:@"audit"];
        }else if (loanstatus == -2) {
            //预审
            self.thelastImage.image = [UIImage imageNamed:@"audit"];
        }else if (loanstatus == -3) {
            //担保确认中
            self.thelastImage.image = [UIImage imageNamed:@"jk"];
        }
        
    }
    
    //发布日期
    NSString *distributionTime = itemDict[@"audit_time"];
    if ((0 < loanstatus)&& [distributionTime isKindOfClass:[NSString class]] && distributionTime.length >= 10) {
        self.valueDistributionTimeLabel.text = [Util shortDateFromFullFormat:distributionTime];
        self.PromptDistributionTimeLable.hidden =
        self.valueDistributionTimeLabel.hidden = NO;
    }else if(-3 == loanstatus){
        self.valueDistributionTimeLabel.text = [Util shortDateFromFullFormat:itemDict[@"loancreatetime"]];
        self.PromptDistributionTimeLable.hidden =
        self.valueDistributionTimeLabel.hidden = NO;
    }else{
        self.PromptDistributionTimeLable.hidden =
        self.valueDistributionTimeLabel.hidden = YES;
    }
    //还款日期
    NSString *repayTime = itemDict[@"repayendtime"];
    if (loanstatus == 3) {
        repayTime = itemDict[@"ur_time"];
    }
    
    if ((isoverdue || 2 == loanstatus  || 3 == loanstatus) &&
        [repayTime isKindOfClass:[NSString class]] && repayTime.length >= 10)
    {
        self.valueRepayTimeLabel.text = [Util shortDateFromFullFormat:repayTime];
        self.promptRepayTimeLabel.hidden =
        self.valueRepayTimeLabel.hidden = NO;
        
    }else{
        self.promptRepayTimeLabel.hidden =
        self.valueRepayTimeLabel.hidden = YES;
        
        
    }

}



- (void)updateForInvestment:(NSDictionary *)investment{
    
    NSDictionary *betDict = investment;
    NSDictionary * loanDict      = [betDict objectForKey:NET_KEY_LOAN];
    
    NSInteger loanstatus = [loanDict[@"loanstatus"] integerValue];
    
    //借款标题
    self.loanTitleLabel.text = loanDict[@"title"];
    
    //投资金额 betval
    self.mainValueLabel.text = [Util formatRMBWithoutUnit:@([betDict[@"betval"] doubleValue])];
    self.daysLeftLabel.text = loanDict[@"loanstatuslabel"];
    
    //receivableinterestval  应还利息
    self.valueInterestLable.text =
    [Util formatRMBWithoutUnit:@([betDict[@"receivableinterestval"] doubleValue])];
    NSInteger isoverdue = [loanDict[@"isoverdue"] integerValue];
    
    self.overDueLabel.hidden = YES;
    
    if (isoverdue == 1) {
        
        if ([loanDict[@"ub_turn"] integerValue] == 1) {
            //已转让
            self.thelastImage.image = [UIImage imageNamed:@"rolloff"];
            self.loanStatusLabel.hidden = YES;
        }else{
            
            //宽限期
            NSInteger isgrace = [loanDict[@"isgrace"] integerValue];
            if (isgrace) {
                self.thelastImage.image = [UIImage imageNamed:@"period"];
            }else{
                self.thelastImage.image = [UIImage imageNamed:@"overdue"];
            }
            
            //逾期
            self.loanStatusLabel.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
            self.loanStatusLabel.text = loanDict[@"loanUser"];
            self.loanStatusLabel.hidden = NO;
            
            
            self.overDueLabel.text = EMPTYSTRING_HANDLE(loanDict[@"loandistitle"]);
            self.overDueLabel.hidden = NO;
        }
    }else {
        //未逾期
        self.loanStatusLabel.hidden = YES;
        if (loanstatus == 2) {
            
            if ([loanDict[@"ub_turn"] integerValue] == 2) {
                //收到转让
                self.thelastImage.image = [UIImage imageNamed:@"into"];
                self.loanStatusLabel.text = loanDict[@"loanUser"];
                self.loanStatusLabel.textColor = CN_TEXT_BLACK;
                self.loanStatusLabel.hidden = NO;
            }else if ([loanDict[@"ub_turn"] integerValue] == 1) {
                //已转让
                self.thelastImage.image = [UIImage imageNamed:@"rolloff"];
            }else{
                //还有X天收回
                self.thelastImage.image = [UIImage imageNamed:@"thelast"];
            }
            
        }else if (loanstatus == 1 ) {
            //筹款中
            self.thelastImage.image = [UIImage imageNamed:@"fundraising"];
        }else if (loanstatus == 3) {
            
            if ([loanDict[@"ub_turn"] integerValue] == 2) {
                //收到转让
                self.thelastImage.image = [UIImage imageNamed:@"into"];
                self.loanStatusLabel.text = loanDict[@"loanUser"];
                self.loanStatusLabel.textColor = CN_TEXT_BLACK;
                self.loanStatusLabel.hidden = NO;
            }
            else if ([loanDict[@"ub_turn"] integerValue] == 1) {
                //已转让
                self.thelastImage.image = [UIImage imageNamed:@"rolloff"];
            }
            else{
                //完成还款
                self.thelastImage.image = [UIImage imageNamed:@"finish"];
            }
        }else if (loanstatus == 7) {
            //退款中
            self.thelastImage.image = [UIImage imageNamed:@"drawback"];
        }
    }
    
    //还有XX天还款
    //        self.daysLeftLabel.text = betDict[@"loanstatuslabel"];
    //        //还款中...
    //        self.loanStatusLabel.text = loanDict[@"loanstatuslabel"];
    //        if (loanstatus == 3) {
    //            self.daysLeftLabel.text = loanDict[@"loanstatuslabel"];
    //            self.loanStatusLabel.text = nil;
    //        }
    
    
    
    //利率
    self.valueRateLabel.text =[NSString stringWithFormat:@"%@",[Util formatFloat:@([loanDict[@"loanrate"] doubleValue])]];
    //    [Util percentInt:[loanDict[@"loanrate"] intValue]];
    
    //投资日期
    NSString *distributionTime = betDict[@"bettime"];
    if ([distributionTime isKindOfClass:[NSString class]] && distributionTime.length >= 10) {
        self.valueDistributionTimeLabel.text = [Util shortDateFromFullFormat:distributionTime];
        
        self.PromptDistributionTimeLable.hidden =
        self.valueDistributionTimeLabel.hidden = NO;
    }else{
        self.PromptDistributionTimeLable.hidden =
        self.valueDistributionTimeLabel.hidden = YES;
    }
    //收回日期 repay_end_time
    NSString *repayTime = EMPTYSTRING_HANDLE(betDict[@"urs_time"]);                //还款的真实日期
    //    if (self.isHistorical) {
    //    }
    
    if ([repayTime length] < 1) { //!repayTime || [repayTime length] < 1
        repayTime = loanDict[@"repay_end_time"];   //借款的最后还款日期
    }
    
    if ((isoverdue || 2 == loanstatus  || 3 == loanstatus) &&
        [repayTime isKindOfClass:[NSString class]] && repayTime.length >= 10
        ) {
        //显示收回日期
        self.valueRepayTimeLabel.text = [Util shortDateFromFullFormat:repayTime];
        
        self.promptRepayTimeLabel.hidden =
        self.valueRepayTimeLabel.hidden = NO;
    }else{
        self.promptRepayTimeLabel.hidden =
        self.valueRepayTimeLabel.hidden = YES;
    }
    
    
    
    //红包与加息券
    NSInteger packageVal = [betDict[@"coupon"] integerValue];
    double couponVal  = [betDict[@"interestcoupon"] doubleValue];
    
    if (packageVal > 0) {
        self.red.value = [NSString stringWithFormat:@"%zd", packageVal];
        self.red.hidden = NO;
    }else{
        self.red.hidden = YES;
    }
    //self.red.backgroundColor = [UIColor greenColor];
    
    if (couponVal > 0) {
        double precent = kcoupan_rate_precision * couponVal;
        self.coupon.value = [NSString stringWithFormat:@"+%@%%", [Util formatFloat:@(precent)]];
        self.coupon.hidden = NO;
    }else{
        self.coupon.hidden = YES;
    }
    //self.coupon.backgroundColor = [UIColor greenColor];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loanStatusLabel.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    self.loanTitleLabel.textColor =
    self.daysLeftLabel.textColor =
    self.promptInterestLabel.textColor =
    self.promptRateLabel.textColor =
    self.promptRepayTimeLabel.textColor =
    self.PromptDistributionTimeLable.textColor =
    self.valueInterestLable.textColor =
    self.valueRateLabel.textColor =
    self.valueRateLabel.textColor =
    self.valueRepayTimeLabel.textColor =
    self.valueDistributionTimeLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    
//    self.promptLabelWan.textColor =ZCOLOR(COLOR_TEXT_DARKBLACK);
    self.overDueLabel.textColor =  CN_UNI_RED;
    self.loanStatusLabel.font =
    self.overDueLabel.font = CNFont_22px;
    
    self.loanTitleLabel.font =
    self.daysLeftLabel.font =
    self.promptInterestLabel.font =
    self.promptRepayTimeLabel.font =
    self.promptRateLabel.font =
    self.PromptDistributionTimeLable.font =
    self.valueRepayTimeLabel.font =
    self.valueDistributionTimeLabel.font =
    self.yuanLabel.font =
    self.investmentyuanLabel.font =
    self.investmentPresentLabel.font =
    self.valueInterestLable.font =
    self.valueRateLabel.font =
    self.percentLabel.font =
    [UtilFont systemLargeNormal];
    
    self.promptLabelWan.font = [UtilFont systemLargeNormal];
    self.mainValueLabel.font = [UtilFont systemNormal:22];
    
//    self.loanTitleLabel.text =
//    self.mainValueLabel.text =
//    self.promptLabelWan.text =
//    self.daysLeftLabel.text =
//    self.loanStatusLabel.text =
//    self.promptInterestLabel.text =
//    self.promptRateLabel.text =
//    self.promptRepayTimeLabel.text =
//    self.PromptDistributionTimeLable.text =
//    self.valueInterestLable.text =
//    self.valueRateLabel.text =
//    self.valueRepayTimeLabel.text =
//    self.valueDistributionTimeLabel.text =
//    @"";
    
 

    
    
    
    ////我的投资-红包
    
    _red =  [self.packageContainView viewWithTag:20011];
    if (!_red){
        
        
        _red = [[RedPackageWrapper alloc]
                                  initWithPackageWidth:[ZAPP.zdevice scaledValue:34]
                                  packageFont:self.promptLabelWan.font
                                  wrapperFont:self.promptLabelWan.font
                                  value:@""];
        _red.tag = 20011;
        
        _red.textColor = CN_TEXT_GRAY;
        
        [self.packageContainView addSubview:_red];
        
        if (self.packageContainView) {
            [_red mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_red.superview);
                make.bottom.equalTo(_red.superview);
            }];
        }
        //red.hidden = YES;
    }
    
    
    //加息券
    
    _coupon =  [self.couponContainView viewWithTag:10011];
    if (! _coupon) {
        CGFloat width = [ZAPP.zdevice scaledValue:53.0];
        _coupon = [[RedPackageWidget alloc] initWithFrame:CGRectMake(0, [ZAPP.zdevice scaledValue:0], width, width/120*40) font:CNFont_24px];
        [self.couponContainView addSubview:_coupon];
        
    }
    //_coupon.value = @"+0.8%";
    _coupon.isCoupon = YES;
    _coupon.tag = 10011;
    
    
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /*
    _red.bottom = self.promptLabelWan.bottom;
    _red.left = self.promptLabelWan.right + 2;
    
    
    
    //red.hidden = NO;
    
    
    
    _coupon.left = self.investmentPresentLabel.right + 4;
    _coupon.bottom = self.investmentPresentLabel.bottom - 1;
     
     */
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
