//
//  HaoyouRecordTableViewCell.m
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "HuanxiCell2.h"

@implementation HuanxiCell2

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    [Util setUILabelLargeGray:self.largeGray];
    
    self.nameLabel.textColor = ZCOLOR(COLOR_BUTTON_RED);
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)suoyaoPressed:(UIButton *)sender {
    [Util toast:@"还息"];
}

@end
