//
//  InvestmentDetailViewController.h
//  YQS
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface InvestmentDetailViewController : CustomViewController


@property (strong, nonatomic)NSString *betid;

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *loanorderLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
