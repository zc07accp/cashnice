//
//  RepaymentBillListCell.m
//  YQS
//
//  Created by a on 15/9/14.
//  Copyright (c) 2015年 l. All rights reserved.
//

#import "RepaymentBillListCell.h"

@implementation RepaymentBillListCell

- (void)awakeFromNib {
    // Initialization code
    self.title.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.detail.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.title.font = [UtilFont systemLarge];
    self.detail.font = [UtilFont systemLarge];
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
