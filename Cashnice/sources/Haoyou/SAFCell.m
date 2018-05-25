//
//  SAFCell.m
//  Cashnice
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SAFCell.h"

@implementation SAFCell


-(void)setDic:(NSDictionary *)dict{
    
    [self.headerImgView setHeadImgeUrlStr:EMPTYSTRING_HANDLE([dict objectForKey:NET_KEY_HEADIMG])];
    self.nameLabel.text = [Util getUserRealNameOrNickName:dict];//@"张楠";
    self.companyLabel.text = EMPTYSTRING_HANDLE([dict objectForKey:NET_KEY_ORGANIZATIONNAME]) ;//@"山东恒生有限公司";
    self.occupityLabel.text = EMPTYSTRING_HANDLE([dict objectForKey:NET_KEY_ORGANIZATIONDUTY]);
    self.leftSpace = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
