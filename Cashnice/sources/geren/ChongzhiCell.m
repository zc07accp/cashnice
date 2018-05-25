//
//  FabuJiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ChongzhiCell.h"

@implementation ChongzhiCell

- (void)awakeFromNib {
    // Initialization code
    
    self.detail.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.detail.font = [UtilFont systemLarge];
    
    self.tf.font = [UtilFont systemLarge];
    self.tf.textColor = ZCOLOR(COLOR_TEXT_BLACK);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
