//
//  MeNextGetMoneyView.m
//  Cashnice
//
//  Created by apple on 2017/3/9.
//  Copyright © 2017年 l. All rights reserved.
//

#import "MeNextGetMoneyView.h"

@implementation MeNextGetMoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setFullDateStr:(NSString *)fullDateStr{
    
    NSArray *tempArr = [fullDateStr componentsSeparatedByString:@"-"];
    if (tempArr.count == 3) {
        NSString *tempmonth = tempArr[1];
        NSString *tempday = tempArr[2];
        
        self.monthLabel.text = tempmonth;
        self.dayLabel.text = tempday;
    }

}

@end
