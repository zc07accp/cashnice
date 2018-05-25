//
//  IOUDetailUnit.h
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOUDetailUnit : NSObject

@property (nonatomic) NSInteger ui_id;
@property (nonatomic) NSInteger ui_src_user_id;
@property (nonatomic) NSInteger ui_dest_user_id;

@property (nonatomic) CGFloat ui_loan_val; //借款本金
@property (nonatomic) CGFloat ui_loan_rate;
@property (nonatomic) NSInteger ui_loan_usage;
@property (nonatomic) NSString* iouUsage;//	String	借款用途标签

@property (nonatomic) NSInteger  ui_status;
@property (nonatomic) BOOL isOverDue;       //是否逾期

@property (nonatomic) NSString* ui_loan_start_date;
@property (nonatomic) NSString* ui_loan_end_date;
@property (nonatomic) NSString* format_repay_confirm_time;  //真实还款日期
@property (nonatomic) NSInteger create_user; //	    Integer	借条发布人
@property (nonatomic) CGFloat ui_interest_val;//	float	借款利息
@property (nonatomic) CGFloat ui_overdue_interest_val;  //逾期利息
@property (nonatomic) CGFloat total_amount;     //应收款
@property (nonatomic) CGFloat ui_repay_amount;  //还款金额
@property (nonatomic) NSString* ui_orderno;     //交易编号
@property (nonatomic) NSString* label_repay_type;   //还款方式标签

@property (nonatomic) NSArray *voucherLoanSrc	;       //	出借人的借款凭证
@property (nonatomic) NSArray *voucherRepaymentSrc	;   //	出借人的还款凭证
@property (nonatomic) NSArray *voucherLoanDest;         //  借款人的借款凭证
@property (nonatomic) NSArray *voucherRepaymentDest;	//	借款人的还款凭证

@property (nonatomic) NSDictionary *srcUser;
@property (nonatomic) NSDictionary *destUser;

@property (nonatomic) NSInteger ui_back_reason;     //	Integer	驳回理由ID
@property (nonatomic) NSString* backReason;         //	String	驳回理由标签
@property (nonatomic) NSInteger ui_ispay;           //	Integer	是否完成支付 0:未支付 1:已支付
@property (nonatomic) CGFloat ui_commission;        //	float	手续费金额

@property (nonatomic) NSString* ui_dest_user_phone; //	String	对方手机号
@property (nonatomic) NSString* ui_dest_user_name;  //	String	对方姓名

@property (nonatomic) NSString* preset_error_message;  //	String 错误消息


+ (NSString *)getUserRealNameOrNickName:(NSDictionary *)dict;

@end
