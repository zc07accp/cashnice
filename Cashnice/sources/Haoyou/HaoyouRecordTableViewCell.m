//
//  HaoyouRecordTableViewCell.m
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "HaoyouRecordTableViewCell.h"

@implementation HaoyouRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [Util setUILabelLargeGray:self.largeGray];
    
    self.suoyaoButton.layer.cornerRadius = [Util getCornerRadiusSmall];
    [self.suoyaoButton setBackgroundColor:ZCOLOR(COLOR_BUTTON_BLUE)];
    self.suoyaoButton.titleLabel.font = [UtilFont systemLarge];
    
    self.shouxinLabel.font = [UtilFont systemLarge];
    
    [self.suoyaoButton setTitle:@" 索要 " forState:UIControlStateNormal];
    [self.suoyaoButton setTitle:@" 已索要 " forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)suoyaoPressed:(UIButton *)sender {
    [self.delegate souyaopressed:(int)sender.tag];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
//        [Util toast:@"suoyao"];
    }
}
@end
