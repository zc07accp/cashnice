//
//  MightKnownTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "MightKnownTableViewCell.h"

@implementation MightKnownTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgBgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    self.nameLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.nameLabel.font = [UtilFont systemLarge];
    
    self.titleLabel.font = [UtilFont systemSmall];
    self.orgLabel.font = [UtilFont systemSmall];
    self.commPromptLabel.font = [UtilFont systemSmall];
    
    self.friNumLabel.font = [UtilFont system:20];
    
    self.friNumLabel.text = @" ";
    
    [super awakeFromNib];
}

- (IBAction)mutualFriendAction:(UIButton *)sender {
    NSInteger indexRow = self.tag;
    [_delegate mutualFriendListAction:indexRow];
}

@end
