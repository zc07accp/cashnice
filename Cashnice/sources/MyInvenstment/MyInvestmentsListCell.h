//
//  MyInvestmentsListCell.h
//  YQS
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilEnum.h"


@interface MyInvestmentsListCell : UITableViewCell{
    LoanState _state; 
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *repaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *invenstmentCoutLabel;

@property (weak, nonatomic) IBOutlet UILabel *interestCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *interestRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestCountRateLabel;

@property (weak, nonatomic) IBOutlet UILabel *repaymentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repaymentTimeLabel;





@end
