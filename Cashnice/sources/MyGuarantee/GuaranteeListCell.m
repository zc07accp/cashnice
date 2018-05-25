//
//  GuaranteeListCell.m
//  YQS
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaranteeListCell.h"

@implementation GuaranteeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.loanTitleLabel.font =
    self.daysLeftLabel.font =
    self.loanStatusLabel.font =
    self.promptInterestLabel.font =
    self.promptRateLabel.font =
    self.promptRepayTimeLabel.font =
    self.PromptDistributionTimeLable.font =
    self.valueInterestLable.font =
    self.valueRateLabel.font =
    self.valueRepayTimeLabel.font =
    self.valueDistributionTimeLabel.font =
    self.yuanLabel.font =
    self.percentLabel.font =
    self.valueInterestLable.font =
    self.valueRateLabel.font =
    [UtilFont systemLargeNormal];
    
    self.promptLabelWan.font = [UtilFont systemLargeNormal];
    self.mainValueLabel.font = [UtilFont systemNormal:22];

    //self.valueInterestLable.textColor =
    //self.valueRateLabel.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
