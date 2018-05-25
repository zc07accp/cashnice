//
//  MightKnownTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "GongtongHaoyouTableViewCell.h"

@implementation GongtongHaoyouTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgBgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    self.nameLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.nameLabel.font = [UtilFont systemLarge];
    
    for (UILabel *lb in self.labelArray) {
        lb.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
        lb.font = [UtilFont systemSmall];
    }
    
    ((UILabel *)[self.labelArray objectAtIndex:3]).textColor = ZCOLOR(COLOR_BUTTON_RED);
    
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (UIEdgeInsets)layoutMargins {
//    return UIEdgeInsetsZero;
//}
@end
