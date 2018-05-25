//
//  MyInvestmentsListViewController.h
//  YQS
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "InvestmentDetailController.h"

@interface MyInvestmentsListViewController : CustomViewController




@property (nonatomic) BOOL isHistorical;
@property (weak, nonatomic) IBOutlet UILabel *investmentTotalCount;

@property (weak, nonatomic) IBOutlet UILabel *expectIncome;
@end
