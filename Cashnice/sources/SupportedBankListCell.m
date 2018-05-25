//
//  SupportedBankListCell.m
//  YQS
//
//  Created by a on 16/4/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SupportedBankListCell.h"

@implementation SupportedBankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = [UtilFont systemLarge];
    self.descriptionLabel.font = [UtilFont systemSmall];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
