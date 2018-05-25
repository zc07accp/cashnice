//
//  RIViewModel.m
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RIViewModel.h"

@implementation RIViewModel

-(void)availableState:(BOOL)available{
    
    _available = available;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(16, 200, 60, 150);
    
    
    if (!available) {
        
        //不可以使用
        _interestColor = [UIColor whiteColor];
//        _interest = [self reformedInterestStr:@"+0.8%"];
        
        _titleColor = CN_TEXT_GRAY_9;
        _detailColor = HexRGBAlpha(0x999999,0.75);;
        
        
        UIImage *streImage = [[UIImage imageNamed:@"ticketbj_grey"] resizableImageWithCapInsets:insets];
        _bkImage = streImage;
    }else{
        
        //可以使用
        _interestColor = HexRGB(0xf1d911);
//        _interest = [self reformedInterestStr:@"+0.8%"];
        
        _titleColor = HexRGB(0xee4721);
        _detailColor = HexRGBAlpha(0xee4721,0.75);
        
        UIImage *streImage = [[UIImage imageNamed:@"ticketbj_red"] resizableImageWithCapInsets:insets];
        _bkImage = streImage;
        
        
    }
}


-(void)setDic:(NSDictionary *)dic{

    _dic = dic;

    _give =  [EMPTYOBJ_HANDLE(dic[@"give"]) integerValue];
    
    [self availableState: self.queryFromList?(self.querytype==0?YES:NO):
     [EMPTYOBJ_HANDLE(dic[@"canuse"]) boolValue]];
    
    if (self.querytype == 0) {
        
        _use = self.queryFromList?@"未使用":(_available?@"立即使用":@"未使用");
        _giveImage = (self.queryFromList && _give == 1) ? @"give":nil;
        _url = _give == 1?EMPTYSTRING_HANDLE(dic[@"url"]):nil;
        
    }else if (self.querytype == 1){
        _use = @"已使用";
        _giveImage = (_give == 1) ? @"give_grey":nil;
        _url = _give == 1?EMPTYSTRING_HANDLE(dic[@"url"]):nil;

    }else if (self.querytype == 2){
        _use = @"已过期";
        _giveImage = _give == 1?@"give_grey":nil;
        _url=nil;

    }
    
    NSString *rate = nil;
    if([EMPTYOBJ_HANDLE(dic[@"rate"]) doubleValue] == 0){
        
        rate = @"+0.0%";
        
    }else{
//       rate = [NSString stringWithFormat:@"+%@%%",[Util formatFloat:@([EMPTYOBJ_HANDLE(dic[@"rate"]) doubleValue]*kcoupan_rate_precision)]];
        
        rate = [NSString stringWithFormat:@"+%.1f%%",([EMPTYOBJ_HANDLE(dic[@"rate"]) doubleValue]*kcoupan_rate_precision)];
        
    }
    
    
//    NSString *rate = [NSString stringWithFormat:@"+%@%%",[Util formatFloat:@([EMPTYOBJ_HANDLE(dic[@"rate"]) doubleValue]*kcoupan_rate_precision)]];

    
 
    _interest = [self reformedInterestStr:rate];
    
    _title = EMPTYSTRING_HANDLE(dic[@"desc"]);
    _range = EMPTYSTRING_HANDLE(dic[@"validity"]);
    _limit = EMPTYSTRING_HANDLE(dic[@"condition"]);
    

}

-(NSAttributedString *)reformedInterestStr:(NSString *)orginalStr{
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:orginalStr];
    NSInteger len =[orginalStr length];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ScreenWidth320? 22:23]  range:NSMakeRange(0, len)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13]  range:NSMakeRange(0, 1)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13]  range:NSMakeRange(len-1, 1)];

    [attString addAttribute:NSForegroundColorAttributeName value:_interestColor range:NSMakeRange(0, len)];
 
    
    return attString;
}


@end
