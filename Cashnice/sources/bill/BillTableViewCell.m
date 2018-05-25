//
//  BillTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BillTableViewCell.h"

@implementation BillTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.imgBgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    
    self.nameLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.nameLabel.font = [UtilFont systemLarge];
    
    self.dateLabel.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.dateLabel.font = [UtilFont systemLarge];
    
    self.moneyLabel.textColor = ZCOLOR(COLOR_BUTTON_RED);
    self.moneyLabel.font = [UtilFont systemLarge];
    
    self.tradeState.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.tradeState.font = [UtilFont systemLarge];
 
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
