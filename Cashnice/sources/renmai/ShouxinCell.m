//
//  MightKnownTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ShouxinCell.h"

@implementation ShouxinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.con_w.constant = [ZAPP.zdevice getDesignScale:390];
    self.imgBgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    self.nameLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.nameLabel.font = [UtilFont systemLarge];
    
    for (UILabel *lb in self.labelArray) {
        lb.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
        lb.font = [UtilFont systemSmall];
    }
    
    [self.editButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UtilFont systemSmall];
    
    self.button1.titleLabel.font = [UtilFont systemSmall];
    self.button2.titleLabel.font = [UtilFont systemSmall];
    self.button1.layer.cornerRadius = [Util getCornerRadiusSmall];
    self.button2.layer.cornerRadius = [Util getCornerRadiusSmall];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (UIEdgeInsets)layoutMargins {
//    return UIEdgeInsetsZero;
//}

- (IBAction)buEdit:(UIButton *)sender {
    NSInteger rowIndex = sender.tag;
    [self.delegate buttonClicked:0 row:rowIndex targetNum:self.targetNum];
}
- (IBAction)bu1:(UIButton *)sender {
    NSInteger rowIndex = sender.tag;
    [self.delegate buttonClicked:1 row:rowIndex targetNum:self.targetNum];
}
- (IBAction)bu2:(UIButton *)sender {
    NSInteger rowIndex = sender.tag;
    [self.delegate buttonClicked:2 row:rowIndex targetNum:self.targetNum];
}
@end
