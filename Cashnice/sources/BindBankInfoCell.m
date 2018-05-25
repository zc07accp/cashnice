//
//  BindBankInfoCell.m
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BindBankInfoCell.h"

@implementation BindBankInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = self.contentLabel.font = CNFontNormal;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title content:(NSString *)content {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

- (void)showArrow:(BOOL)show{
    if(! show){
        self.rowImgView.hidden = YES;
        //self.traliingToEdge.priority = MASLayoutPriorityRequired;
        self.traliingToEdge.constant = 0;
    }else{
        self.rowImgView.hidden = NO;
        self.traliingToEdge.constant = 15;
    }
}
@end
