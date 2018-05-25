//
//  InvestmentListCell.m
//  YQS
//
//  Created by a on 16/5/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentListCell.h"

@implementation InvestmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rateLabel.font = [UtilFont systemNormal:38.0f];
    
    
    self.loanTitleLabel.font =
    self.promptGuaranteeLabel.font =
    self.guaranteeCountLable.font =
    self.guaranteeRenLabel.font =
    self.precentMarkLabel.font =
    self.timeLabel.font =
    self.tianLabel.font =
    self.mainValLabel.font =
    self.wanLabel.font =
    [UtilFont systemLargeNormal];
    
}

- (IBAction)guaranteeAction:(id)sender {
    [self.delegate guaranteeButtonDidSelected:self];
}

- (IBAction)investAction:(id)sender {
    [self.delegate investButtonDidSelected:self];
}

- (void)prepareForReuse {
    
//    UIView *pview = [self.progressLabel viewWithTag:10011];
//    [pview removeFromSuperview];
    
    [super prepareForReuse];
}

@end
