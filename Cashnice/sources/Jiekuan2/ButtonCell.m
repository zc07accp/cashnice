//
//  JiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [self.button setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    self.button.titleLabel.font = [UtilFont systemLarge];
    self.button.layer.cornerRadius = [Util getCornerRadiusSmall];

}

- (IBAction)buttonPressed:(UIButton *)sender {
    [self.delegate buttonPressedFromCell];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
