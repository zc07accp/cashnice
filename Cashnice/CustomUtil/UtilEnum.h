//
//  UtilEnum.h
//  YQS
//
//  Created by l on 3/14/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#ifndef YQS_UtilEnum_h
#define YQS_UtilEnum_h

typedef enum DeviceType { Device_6plus_414, Device_6_375, Device_5_320 /*, Device_4_320*/ } DeviceType;
typedef enum LanguageType { Language_Cn, Language_En } LanguageType;

typedef enum LoanState { JieKuan_WaitingNow, JieKuan_GoingNow, JieKuan_FinishedNow, JieKuan_FinishedAndPayed, JieKuan_SelfClosed, JieKuan_UnfinishedClosed, JieKuan_AdminClosed, JieKuan_Refund, JieKuan_FailNow} LoanState;

typedef enum BetType { Bet_Processing, Bet_BetFinished, Bet_BetFailed, Bet_LoanClosedAndRefunded, Bet_RefundFail, Bet_Refunding } BetType;

typedef enum ShouXinType { ShouXin_MeiYou, ShouXin_YiJing, ShouXin_XiangHu, ShouXin_SuoYao, ShouXin_None, ShouXin_NoneHint} ShouXinType;

typedef enum WebDetailType { WebDetail_borrow_xuzhi, WebDetail_service_agreement, WebDetail_contact_us, WebDetail_2, WebDetail_3, WebDetail_RegProtocol } WebDetailType;

typedef enum UserLevelType { UserLevel_Unauthed, UserLevel_Normal, UserLevel_VIP} UserLevelType;

typedef NS_ENUM(NSInteger, IouSatusType) {
        IOU_STATUS_NO_SEND      = 0,   //待发
        IOU_STATUS_SENDING      = 1,   //已发借条，待确认
        IOU_STATUS_CONFIRM      = 2,   //借条已确认(双方确认，已生效)
        IOU_STATUS_RETURN       = 3,   //驳回
        IOU_STATUS_REPAYMENT    = 4,   //还款
        IOU_STATUS_REPAY_CONFIRM = 5,   //还款确认（已收到款）
        IOU_STATUS_REPAY_REJECT = 6,   //还款被驳回
        IOU_STATUS_CLOSE        = 9,   //借条关闭（退款中）
        IOU_STATUS_CLOSE_REFUND = 10   //借条关闭（已退款）
} ;


#endif
