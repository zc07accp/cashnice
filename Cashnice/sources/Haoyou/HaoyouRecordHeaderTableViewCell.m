//
//  HaoyouRecordHeaderTableViewCell.m
//  YQS
//
//  Created by l on 3/30/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "HaoyouRecordHeaderTableViewCell.h"

@implementation HaoyouRecordHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bgview.backgroundColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    [Util setUILabelLargeGray:self.largeGray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
