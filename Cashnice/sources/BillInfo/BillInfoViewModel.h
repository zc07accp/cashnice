//
//  BillInfoViewModel.h
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BillInfoViewController.h"

typedef NS_ENUM(NSInteger, TRANSFER_OPERATION_PROGRESS) {
    TRANSFER_OPERATION_PROGRESS_NON,
    TRANSFER_OPERATION_PROGRESS_OUT,
    TRANSFER_OPERATION_PROGRESS_IN,
};

@interface BillInfoViewModel : NSObject

@property (nonatomic, assign) NSUInteger loanId;
@property (nonatomic, assign) LoanBillType loanBillType;
@property (nonatomic, weak) BillInfoViewController *vc;

- (instancetype)initWithLoanId:(NSUInteger)loanid billType:(LoanBillType)billType;
- (instancetype)initWithLoanId:(NSUInteger)loanid betid:(NSUInteger)betid billType:(LoanBillType)billType;
- (NSDictionary *)model;

- (void)connectToServer;

//标题
- (NSString *)viewTitle;
//头像
- (UIImage *)headImage;
- (NSString *)headImageName;
//提示语
- (NSAttributedString *)accountPromptString;
//
- (NSString *)title4PromptString;
//金额
- (NSNumber *)accountNumber;
- (NSString *)accountString;
//感谢提示语
- (NSString *)appreciationPromptString;
//本金
- (NSNumber *)mainvalNumber;
//利率
- (NSNumber *)rateNumber;
//发布日
- (NSString *)startDate;
//收回日
- (NSString *)endDate;
//显示逾期保护中
- (BOOL)showProtection;
//按钮
- (NSArray *)actions;

//借款人头像
- (NSString *)loanuserheadimg;
//判断逾期
- (BOOL)isOverdue;
//判断宽限期
- (BOOL)isGrace;
//借款人真实姓名
- (NSString *)loanusername;
//逾期天数
- (NSUInteger)latedays;
//借款状态
- (LoanState)loanState;
//betid
- (NSUInteger)betid;
//今日到期
- (BOOL)islastday;
//是否有转让功能     默认：NO
- (BOOL)isTransferEnabled;
//是否可转让     默认：NO
- (BOOL)isTransferable;
//转让操作过程
- (TRANSFER_OPERATION_PROGRESS)transferOperationProgress;

//担保人还款数组
-(NSArray *)warrantyRepayment;

-(NSInteger)loantype;

//使用红包金额
- (NSUInteger)packageValue;
//使用加息券金额
- (double)couponValue;

//开始时间标签字符串
- (NSString *)startPromptText;
//打开详情页面
- (void)pushDetailView;
//我的账单
- (void)showBillView;
//
- (BOOL)alreadyToUse;

@end
