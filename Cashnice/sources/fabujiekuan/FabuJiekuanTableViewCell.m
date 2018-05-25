//
//  FabuJiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "FabuJiekuanTableViewCell.h"

@implementation FabuJiekuanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.detail.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.detail.font = [UtilFont systemLarge];
    
    self.tf.font = [UtilFont systemLarge];
    self.tf.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.con_content_width.constant = [ZAPP.zdevice getDesignScale:390];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_roundoutDetailImage) {
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
