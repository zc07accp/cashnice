//
//  GeRenTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "GeRenTableViewCell.h"

@implementation GeRenTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.biaoti.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.detail.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.biaoti.font = [UtilFont systemLarge];
    self.detail.font = [UtilFont systemLarge];
    
    self.detail.text = @"";
    self.detail.hidden = YES;
    
    self.con_w.constant = [ZAPP.zdevice getDesignScale:390];
    self.con_h.constant = [ZAPP.zdevice getDesignScale:44];
    
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
