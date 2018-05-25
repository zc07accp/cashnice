//
//  MyInvestmentsListCell.m
//  YQS
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyInvestmentsListCell.h"

@interface MyInvestmentsListCell ()



@end


@implementation MyInvestmentsListCell

- (void)updateJiekuanState {
//    self.statebgView.backgroundColor = [UtilString bgColorJiekuanState:_state];
    self.repaymentLabel.text             = [UtilString getJiekuanState:_state];
    
    BOOL hideInfo = _state != JieKuan_GoingNow;
    
//    self.deadline.hidden   = hideInfo;
//    self.remainDays.hidden = hideInfo;
}

- (void)setJiekuanState:(LoanState)state {
    _state = state;
    [self updateJiekuanState];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.repaymentTimeLabel.textColor =
//    self.repaymentDateLabel.textColor =
//    self.interestCountRateLabel.textColor =
//    self.interestRateLabel.textColor =
//    self.dateTimeLabel.textColor=
//    self.dateLabel.textColor =
//    self.interestLabel.textColor =
//    self.interestCountLabel.textColor =
//    self.repaymentLabel.textColor =
//    self.timeLable.textColor =
//    self.titleLabel.textColor = [UIColor blackColor];
    
    
    self.repaymentTimeLabel.font = [UtilFont systemLarge];
    self.repaymentDateLabel.font = [UtilFont systemLarge];
    self.interestCountRateLabel.font = [UtilFont systemLarge];
    self.interestRateLabel.font = [UtilFont systemLarge];
    self.dateTimeLabel.font= [UtilFont systemLarge];
    self.dateLabel.font = [UtilFont systemLarge];
    self.interestLabel.font = [UtilFont systemLarge];
    self.interestCountLabel.font = [UtilFont systemLarge];
    self.repaymentLabel.font = [UtilFont systemLarge];
    self.timeLable.font = [UtilFont systemLarge];
    self.titleLabel.font = [UtilFont systemLarge];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
