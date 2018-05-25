//
//  BDMoneyViewModel.m
//  Cashnice
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BDMoneyViewModel.h"
#import "BillDetailConfig.h"

@implementation BDMoneyViewModel

+(instancetype)viewModelFrom:(NSString *)accrual{
    
    BDMoneyViewModel *model = [[self alloc] init];
    model.title = @"交易成功";
    model.detail = [BillDetailConfig reformMoney:accrual];
    model.isComing = [accrual rangeOfString:@"+"].location != NSNotFound;
    return model;
}

@end
