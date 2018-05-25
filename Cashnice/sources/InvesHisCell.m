//
//  InvesHisCell.m
//  Cashnice
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvesHisCell.h"
#import "MoneyFormatViewModel.h"

@implementation InvesHisCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setDic:(NSDictionary *)dic{
    
    self.phoneLabel.text = EMPTYSTRING_HANDLE(dic[@"phone"]) ;
    
    NSString *datetime = EMPTYSTRING_HANDLE(dic[@"betTime"]);
    NSString *strUrl = [datetime stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    self.timeLabel.text = strUrl;

    if (dic[@"reformed"]) {
        MoneyFormatViewModel *vm = dic[@"reformed"];
        self.moneyLabel.attributedText = vm.reformedMoneyStr;
    }
    
//    self.moneyLabel.text = [Util formatRMB:@([EMPTYOBJ_HANDLE(dic[@"betVal"]) doubleValue])];
}

@end
