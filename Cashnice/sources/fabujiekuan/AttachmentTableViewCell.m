//
//  GeRenTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "AttachmentTableViewCell.h"

@implementation AttachmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.biaoti.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.size.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.detail.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.biaoti.font = [UtilFont systemLarge];
    self.size.font = [UtilFont systemLarge];
    self.detail.font = [UtilFont systemLarge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    [self.delegate delePressed:(int)sender.tag];
}
@end
