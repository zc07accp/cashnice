//
//  TransferHistoryCell.m
//  Cashnice
//
//  Created by a on 16/10/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferHistoryCell.h"

@interface TransferHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation TransferHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = CNFontNormal;
    self.descLabel.font = CNFont_32px;
    self.timeLabel.font = CNFontSmall;
    self.timeLabel.textColor = CN_TEXT_GRAY_9;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configurateWithHistoryItem:(NSDictionary *)historyItem{
    
//    inout = in;
//    label = "\U8f6c\U5165\U8d26\U6237";
//    money = "0.10";
//    orderno = TS4938461016042561;
//    "t_time" = "2016-10-25 16:49:52";
    
    NSString *type = historyItem[@"inout"];
    NSString *money = historyItem[@"accrual"];
    NSString *time = historyItem[@"t_time"];
    UIColor *desColor = [@"in" isEqualToString:type]? HexRGB(0X3399ff) : CN_UNI_RED;
//    NSString *typeSign ;
//    if ([@"in" isEqualToString:type]) {
//        typeSign = @"+";
//        desColor = HexRGB(0X3399ff);
//    }else{
//        typeSign = @"-";
//        desColor = CN_UNI_RED;
//    }
    
    self.descLabel.text = money;
    self.timeLabel.text = [Util shortDateUntilMin:time];
    self.titleLabel.text = historyItem[@"label"];
    self.descLabel.textColor = desColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
