//
//  ProtocolCell.m
//  Cashnice
//
//  Created by a on 16/5/14.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ProtocolCell.h"

@implementation ProtocolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.protocolCheckButton.titleLabel.font =
    self.protocolDetailButton.titleLabel.font =
    self.loginActionButton.titleLabel.font =
    self.agreeLabel.font = [UtilFont systemLarge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
