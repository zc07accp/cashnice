//
//  CalendarInvestmentCell.m
//  Cashnice
//
//  Created by a on 2017/3/13.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CalendarInvestmentCell.h"

@implementation CalendarInvestmentCell

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
    self.loanStatusLabel.font =
    [UtilFont systemLargeNormal];
    
    self.promptLabelWan.font = [UtilFont systemLargeNormal];
    self.mainValueLabel.font = [UtilFont systemNormal:22];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
