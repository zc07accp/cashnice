//
//  BillInfoViewController.h
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@class BillInfoViewModel;

typedef NS_ENUM(NSInteger, LoanBillType) {
    LoanBillTypeMyLoan              = 'L',   //我的借款
    LoanBillTypeMyInvestment        = 'B',   //我的投资
    LoanBillTypeMyGuarantee         = 'W'    //我的担保
} ;
@interface BillInfoViewController : CustomViewController

@property (nonatomic, strong) BillInfoViewModel *vm;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

+ (instancetype)instanceWithLoanType:(LoanBillType)loanBillType loanId:(NSUInteger)loanId betId:(NSUInteger)betId;

- (instancetype)initWithViewModel:(BillInfoViewModel *)vm;
- (void)setupUI;
- (void)refreshView;
// 延迟刷新
- (void)refreshViewAndDelay;
// 设置详情内容高度
- (void)setDetailTableViewHeight:(CGFloat)height;

@end
