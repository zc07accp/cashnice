//
//  MoneyFormatViewModel.m
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MoneyFormatViewModel.h"
#import "UtilFont.h"


@interface MoneyFormatViewModel()

@property(nonatomic, strong)    UIFont *moneyFont;
@property(nonatomic, strong)    UIFont *unitFont;

@property(nonatomic,strong) UIColor *moneyColor;
@property(nonatomic,strong) UIColor *unitColor;

@end

@implementation MoneyFormatViewModel


+(instancetype)viewModelFrom:(NSInteger)type{

    MoneyFormatViewModel *viewmodel = [[MoneyFormatViewModel alloc]init];
    viewmodel.formatType = type;
    //正常的
    if (type == 0) {
        //都大写,都黑

        viewmodel.moneyFont =
        viewmodel.unitFont = [UtilFont systemLarge];
        
        viewmodel.moneyColor =
        viewmodel.unitColor = RGB(0, 0, 0);
    }else    if (type == 1){
        //数大写，元小写,都黑
        viewmodel.moneyFont =  [UtilFont system:26];
        viewmodel.unitFont = [UtilFont systemSmall];

        viewmodel.moneyColor =
        viewmodel.unitColor = RGB(0, 0, 0);
    }else   if (type == 2){
        //数钱都18号字体，数黑，字灰
        viewmodel.moneyFont =
        viewmodel.unitFont = [UtilFont systemNormal:18];
        
        viewmodel.moneyColor =  RGB(0, 0, 0);
        viewmodel.unitColor = CN_TEXT_GRAY;
    }else   if (type == 3){
        //数钱都18号字体，数黑，字灰
        viewmodel.moneyFont = [UtilFont systemNormal:20];

        viewmodel.unitFont = [UtilFont systemNormal:18];
        
        viewmodel.moneyColor =
        viewmodel.unitColor = [UIColor whiteColor];
    }else   if (type == 4){
        //数钱都15号字体，数黑，字灰
        viewmodel.moneyFont =
        viewmodel.unitFont = [UtilFont systemLarge];
        
        viewmodel.moneyColor = CN_TEXT_BLACK;
        viewmodel.unitColor = CN_TEXT_GRAY;
    }
    
    return viewmodel;
}

-(void)setOriginalMoneyNum:(NSNumber *)originalMoneyNum{
    
    if (!originalMoneyNum) {
        return;
    }
    
    _originalMoneyNum = originalMoneyNum;
    
    NSString *money =  [Util formatRMBWithoutUnit:originalMoneyNum];
    
    NSString *str = [NSString stringWithFormat:@"%@元", money];
    
    NSMutableAttributedString *muStr = nil;
    
    muStr = [Util getAttributedString:str font:self.moneyFont color:self.moneyColor];
    [muStr setAttributes:@{NSFontAttributeName:self.unitFont,NSForegroundColorAttributeName:self.unitColor} range:NSMakeRange(str.length-1, 1)];
  
    
    _reformedMoneyStr = [muStr copy];
    
}


@end
