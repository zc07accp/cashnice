//
//  OptionTableViewCell.m
//  YQS
//
//  Created by a on 16/5/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "OptionTableViewCell.h"

@implementation OptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.optionTitleLabel.font = [UtilFont systemLargeNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
