//
//  MightKnownTableViewCell.m
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.imgBgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:3];
    self.nameLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.nameLabel.font = [UtilFont systemLarge];
    
//    self.img.layer.cornerRadius = self.img.bounds.size.width/2;
//    self.img.layer.masksToBounds = YES;
    
    for (UILabel *lb in self.labelArray) {
        lb.textColor = ZCOLOR(COLOR_TEXT_BLACK);
        lb.font = [UtilFont systemLarge];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (UIEdgeInsets)layoutMargins {
//    return UIEdgeInsetsZero;
//}
@end
