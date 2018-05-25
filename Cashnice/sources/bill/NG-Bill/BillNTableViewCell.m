//
//  BillTableViewCell.m
//  YQS
//
//  Created by a on 16/1/31.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillNTableViewCell.h"

@interface BillNTableViewCell ()

@end

@implementation  BillNTableViewCell
- (void)awakeFromNib {
    self.promptLabel.font =
    self.balanceLabel.font =
    self.accrualLabe.font = 
    self.timeLabel.font =
    self.typeLabel.font=
    [UtilFont systemLargeNormal];
    
    self.unitLabel.font =
    [UtilFont systemLarge];
    
    self.timeLabel.font =
    self.promptLabel.font =
    self.balanceLabel.font =
    [UtilFont systemSmall];
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
