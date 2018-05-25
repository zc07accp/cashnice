//
//  SettingTableViewCell.m
//  YQS
//
//  Created by a on 16/1/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    self.signoutLabel.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    self.sepLine.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.titleLabel.font = [UtilFont systemLarge];
    self.signoutLabel.font = [UtilFont systemLarge];
    
}


@end
