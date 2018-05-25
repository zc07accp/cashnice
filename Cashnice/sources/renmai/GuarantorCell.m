//
//  GuarantorCell.m
//  Cashnice
//
//  Created by a on 2016/12/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuarantorCell.h"

@implementation GuarantorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.titleLabel.font = CNLightFont(24);
    self.nameLabel.font = CNFont_32px;
    self.orgLabel.font = CNLightFont(20);
    
    self.guarantPrompt.font =
    self.amountLabel.font = CNLightFont(28);
}


- (void)updateCellData:(NSDictionary *)data{
    self.nameLabel.text = [Util getUserRealNameOrNickName:data];
    self.titleLabel.text = [data objectForKey:NET_KEY_ORGANIZATIONDUTY];
    self.orgLabel.text = [data objectForKey:NET_KEY_ORGANIZATIONNAME];
    
    //[self.headView setHeadImgeUrlStr:[[ZAPP.myuser gerenInfoDict] objectForKey:NET_KEY_HEADIMG]];
    
    //NSString *url = [NSString stringWithFormat:@"https://img.cashnice.com%@",data[NET_KEY_HEADIMG]];
    
    NSString *url = data[NET_KEY_HEADIMG];
    
    [self.img setHeadImgeUrlStr:url];
    
    double  num   = [[data objectForKey:NET_KEY_WARRANTYVAL] doubleValue];
    self.amountLabel.text = [Util formatRMB:@(num)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
