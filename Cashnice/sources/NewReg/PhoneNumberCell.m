//
//  PhoneNumberCell.m
//  Cashnice
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 l. All rights reserved.
//

#import "PhoneNumberCell.h"

@implementation PhoneNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.regionCodeLabel. font =
    self.phoneNumberCell.font =
    [UtilFont systemLarge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
