//
//  IOU.h
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#ifndef IOU_h
#define IOU_h

#define HTTPPATH_IOU_DETAIL @"iou.order.detail.get"
#define HTTPPATH_IOU_ACTION @"iou.item.action.post"
#define HTTPPATH_OPTIONLIST @"system.options.list.get"

#define HTTPPATH_SEARCHCONTANCT @"user.list.search.get"
#define HTTPPATH_CHARGE_SERVEMONEY @"iou.fee.charge.post"
#define HTTPPATH_POST_IOU @"iou.order.item.post"
#define HTTPPATH_IOU_COUNTERFEE @"iou.order.counterfee.get"
#define HTTPPATH_IOU_TOTALFEE @"iou.interest.fee.get"

#define HTTPPATH_IOU_GETLOANRATE @"iou.loan.rate.get"
#define HTTPPATH_IOU_PUSH @"system.push.item.post"
#define HTTPPATH_IOU_GETAVERAGE_RATE @"iou.average.rate.get"

static CGFloat const ROW_HEIGHT_HEADER = 45.f;

static CGFloat const ROW_HEIGHT_0 = 120.f;
static CGFloat const ROW_HEIGHT_1 = 52.f;
static CGFloat const ROW_HEIGHT_BTN = 70.f;

//static CGFloat const ROW_LINE_LEFTSPACE = 13.f;

#define BLUESURE_WIDTH  [ZAPP.zdevice getDesignScale:110]


static CGFloat const SF_ROW_HEIGHT = 80;
//static CGFloat const IOU_TABLE_HEIGHT = 52.f;

static NSString* const PLAT_YEAR_AVER_RATE = @"%@%%";


//******************写借条
//平台服务费
static CGFloat const PLAT_SERVER_MONEY = 99.f;

static NSString *const IOUWARN_NOMONEY = @"请输入借款金额";
static NSString *const IOUWARN_NOSELCONTACT = @"请选择联系人";
static NSString *const IOUWARN_DATE = @"还款日期不得小于今天和借款日期";

static NSString *const IOUWARN_MONEYZERO = @"借款金额应大于%.f元且为整数数字";
static NSString *const IOUWARN_AGREEPROTOCAL = @"请同意借条协议";
static NSString *const IOUWARN_NOPAY_SERVEFEE = @"平台服务费未支付";
static NSString *const IOUWARN_INPUTMONEY_EMPTY = @"请输入借款金额";

static NSString *const IOU_DEL_ALERT = @"确定删除？删除后平台服务费将退回到您账户中";

static NSString *const IOU_MONEYLESS_ALERT = @"您当前余额不足，请先充值";

static NSString *const IOU_SMS = @"您好，我在Cashnice给您写了一个借条，登录/注册Cashnice后，在借条中就可以看到。请您及时的查收并确人。点击链接下载APP: http://app.cashnice.com。";//（没用，不用关心）

static NSString *const IOU_WRITE_WX = @"借款金额%@元，年化利率%@%%";

#define  IOU_PLATSERVE_ABOUT [NSString stringWithFormat:@"%@%@",WEB_DOC_URL_ROOT , @"/iou/ServiceFee"]

//借款协议(0待发，未发送      3驳回未正式生效)
#define IOU_PROTOCAL_EDIT [NSString stringWithFormat:@"%@%@",WEB_DOC_URL_ROOT ,@"/protocol/view?type=0&main_val=%@&rate=%@&start_date=%@&end_date=%@&iou_type=%@&user_id=%@&usage=%@"]

//非编辑
#define  IOU_PROTOCAL_NOEDIT [NSString stringWithFormat:@"%@%@",WEB_DOC_URL_ROOT ,@"/protocol/view?type=1&id=%@"]

#define  IOU_PROTOCAL_AGREE  [NSString stringWithFormat:@"%@%@",WEB_DOC_URL_ROOT ,@"/protocol/view?type=1&id=%@&rate=%@"]


static NSString *const KIOUHOME_FRESH_NOTIFY = @"KIOUHOME_FRESH_NOTIFY";

#define POST_IOULISTFRESH_NOTI  [[NSNotificationCenter defaultCenter] postNotificationName:KIOUHOME_FRESH_NOTIFY object:nil]




//typedef NS_ENUM(NSInteger, IOU_STATUS) {
//      IOU_STATUS_NO_SEND = 0,   //待发
//      IOU_STATUS_SENDING = 1,   //已发借条，待确认
//      IOU_STATUS_CONFIRM = 2,   //借条已确认(双方确认，已生效)
//      IOU_STATUS_RETURN = 3,    //驳回(未正式生效)
//      IOU_STATUS_REPAYMENT = 4,     //还款
//      IOU_STATUS_REPAY_CONFIRM = 5, //还款确认（已收到款）
//      IOU_STATUS_REPAY_RETURN = 6, //还款驳回（收款有别）
//      IOU_STATUS_CLOSE = 9,         //借条关闭（退款中）
//      IOU_STATUS_CLOSE_REFUND = 10 //借条关闭（已退款）
//     
//};



#endif /* IOU_h */
