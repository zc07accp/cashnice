//
//  JieKuanUtil.m
//  Cashnice
//
//  Created by a on 16/10/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "JieKuanUtil.h"

@implementation JieKuanUtil

+ (BOOL)isPrivilegedWithLoan : (NSDictionary *) loanDict{
    
    NSInteger loantype = [loanDict[@"loantype"] integerValue];
    return loantype == 2;
}
@end
