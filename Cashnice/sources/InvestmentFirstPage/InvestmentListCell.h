//
//  InvestmentListCell.h
//  YQS
//
//  Created by a on 16/5/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvestmentListCellDelegate <NSObject>

- (void)investButtonDidSelected:(UITableViewCell *)investmentListCell;
- (void)guaranteeButtonDidSelected:(UITableViewCell *)investmentListCell;

@end

@interface InvestmentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptGuaranteeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeCountLable;
@property (weak, nonatomic) IBOutlet UILabel *guaranteeRenLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tianLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainValLabel;
@property (weak, nonatomic) IBOutlet UILabel *wanLabel;
@property (weak, nonatomic) IBOutlet UIView *progressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@property (weak, nonatomic) id<InvestmentListCellDelegate> delegate;

@end
