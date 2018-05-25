//
//  TradeHistoryTableViewCell.m
//  Cashnice
//
//  Created by a on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "TradeHistoryTableViewCell.h"

@implementation TradeHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = [ZAPP.zdevice scaledValue:4];
    self.headImageView.layer.masksToBounds = YES;
    
    
    self.nameLabel.font = CNFont_24px;
    self.timeLabel.font = CNFont_22px;
    self.moneyLabel.font = CNFont_22px;
    
    self.timeLabel.textColor = HexRGB(0x888888);
    self.moneyLabel.textColor = HexRGB(0x1c3681);
}



-(void)updateWithData:(NSDictionary *)data{
    NSString *imgUrl = EMPTYSTRING_HANDLE(data[@"head_img"]);
    //[self.headImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[Util imagePlaceholderPortrait]];
    
    [self.headImageView setHeadImgeUrlStr:imgUrl];
    
    self.nameLabel.text = EMPTYSTRING_HANDLE(data[@"dis_name"]);
    
    self.timeLabel.text = EMPTYSTRING_HANDLE(data[@"ub_time"]);
    
    self.moneyLabel.text = EMPTYSTRING_HANDLE(data[@"ub_val"]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
