//
//  RMViewModel.m
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RMViewModel.h"

@implementation RMViewModel

-(void)availableState:(BOOL)available{
    
    _available = available;
    
    if (available==NO) {
        
        //不可用
        _leftColor = [UIColor whiteColor];
        
        _rightTopColor = CN_TEXT_GRAY_9;
        _rightBottomColor = HexRGBAlpha(0x999999,0.75);;
        _borderColor =  CN_SEPLINE_GRAY;
        
        _bkImage = [UIImage imageNamed:@"packetbj_grey"];
        
        
    }else{
        //可用
        _leftColor = HexRGB(0xf1d911);
        
        _rightTopColor = HexRGB(0xee4721);
        _rightBottomColor = HexRGBAlpha(0xee4721,0.75);
        _borderColor =  CN_UNI_RED;
        
        _bkImage = [UIImage imageNamed:@"packetbj_red"];
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
    
 

    _money = [NSString stringWithFormat:@"%@",EMPTYOBJ_HANDLE(dic[@"usemoney"])];

    _title = EMPTYSTRING_HANDLE(dic[@"desc"]);
    _range = EMPTYSTRING_HANDLE(dic[@"validity"]);
    _limit = EMPTYSTRING_HANDLE(dic[@"condition"]);
    

    
}

@end
