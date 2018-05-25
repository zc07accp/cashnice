//
//  CheckingGuaranteeTableViewCell.m
//  Cashnice
//
//  Created by a on 2018/4/12.
//  Copyright © 2018年 l. All rights reserved.
//

#import "InvitingGuaranteeTableViewCell.h"

@implementation InvitingGuaranteeTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.actionButton.layer.cornerRadius = 4;
    self.actionButton.layer.masksToBounds = YES;
    //self.actionButton.tintColor
    //self.positionLable.font = self.orgLable.font = self.amountLable.font = CNFont_24px;
    self.nameLabel.font = CNFont_30px;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)invitingAction:(UIButton *)sender {
    if ([self.actionDelegate respondsToSelector:@selector(invitingAction:)]) {
        [self.actionDelegate invitingAction:self.indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
