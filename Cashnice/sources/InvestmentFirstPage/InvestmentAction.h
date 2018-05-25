//
//  InvestmentFirst.h
//  YQS
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface InvestmentAction : CustomViewController
@property (strong, nonatomic)NSDictionary * loadDict;

@property (nonatomic, assign) NSInteger loanid;

- (void)setTheDataDict:(NSDictionary *)dict;
- (void)refreshCouponAndCalcInterest;
- (void)orderCalcValues;

@end
