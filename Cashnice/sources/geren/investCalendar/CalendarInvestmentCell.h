//
//  CalendarInvestmentCell.h
//  Cashnice
//
//  Created by a on 2017/3/13.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarInvestmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabelWan;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *promptInterestLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptRepayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *PromptDistributionTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *valueInterestLable;
@property (weak, nonatomic) IBOutlet UILabel *valueRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueRepayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueDistributionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentyuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *investmentPresentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thelastImage;

@property (weak, nonatomic) IBOutlet UIView *couponContainView;
@property (weak, nonatomic) IBOutlet UIView *packageContainView;

@end
