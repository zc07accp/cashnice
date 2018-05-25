//
//  MightKnownTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BankCell.h"

@implementation BankCell 
- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    
    for (UILabel *lb in self.labelArray) {
        lb.textColor = ZCOLOR(COLOR_TEXT_BLACK);
        lb.font = [UtilFont systemLarge];
    }
    
    
    self.button2.titleLabel.font = [UtilFont systemLarge];
    self.button2.layer.cornerRadius = [Util getCornerRadiusSmall];
//    [self.button2 setBackgroundColor:ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
    [self.button2 setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    [self.button2 setTitle:@"  继续激活  " forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bu2:(UIButton *)sender {
    NSInteger rowIndex = sender.tag;
    [self.delegate buttonClickedrow:rowIndex];
}
@end
