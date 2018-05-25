//
//  ShouXinRenCell.m
//  Cashnice
//
//  Created by a on 16/2/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ShouXinRenCell.h"

@implementation ShouXinRenCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.nameLabel.font = [UtilFont system:20];
    
    self.promptLabel.font =
    self.guarValLabel.font =
    self.titleLabel.font = [UtilFont systemLarge];
    
    self.orgLabel.font = [UtilFont systemSmall];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
