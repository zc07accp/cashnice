//
//  InvestmentDetailController.h
//  YQS
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "InvestDetailItemView.h"

@interface InvestmentDetailController : CustomViewController

@property (nonatomic,copy)NSString  * tString;

@property (nonatomic, assign) NSInteger loanId;

@property (nonatomic, strong) NSDictionary *investDetailDict;




@end
