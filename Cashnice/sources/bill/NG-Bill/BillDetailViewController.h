//
//  BillDetailViewController.h
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"


typedef NS_ENUM(NSInteger, BILLDETAIL_SOURCETYPE) {
    BILLDETAIL_SOURCETYPE_PUSH = 0,
    BILLDETAIL_SOURCETYPE_NOTIFICATION, //从推送跳转过来的
    BILLDETAIL_SOURCETYPE_FROMSERVICEMSG_CHONGZHITIXIAN //小铃铛充值提现来的

 } ;

@interface BillDetailViewController : CustomViewController

@property (nonatomic) NSDictionary *dic;

@property (nonatomic,assign) NSInteger noticeid;
@property (nonatomic,assign) BILLDETAIL_SOURCETYPE source_type;

@end
