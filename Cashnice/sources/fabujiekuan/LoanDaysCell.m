//
//  LoanDaysCell.m
//  Cashnice
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanDaysCell.h"

@implementation LoanDaysCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.optionTitleLabel.font = [UtilFont systemLarge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
