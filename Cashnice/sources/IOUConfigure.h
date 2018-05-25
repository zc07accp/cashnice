//
//  DetailType.h
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOUDetailUnit.h"

@interface IOUConfigure : NSObject

+(NSString *)strValueFromDetail:(IOUDetailUnit *)detailUnit Key:(NSString *)key;

//根据type得到detail1具体列表的选项
//0 发出 出借人   1发出 被驳回  2发出 借款人
+(NSArray *)detail1:(NSInteger)type;

//写借条和编辑借条专用
+(NSArray *)writeIOUItemArray;


//根据iou列表返回的dic获取detail1对应的type
+(NSInteger)detail1Type:(NSDictionary*)dic;

+(NSInteger)detail2Type:(NSDictionary*)dic;

+(NSArray *)detail2:(NSInteger)type;


+(NSString *)makeEditProtol:(IOUDetailUnit *)detailUnit;

+(NSString *)makeNOEditProtol:(NSInteger )iouId;
+(NSString *)makeAgreeProtol:(NSInteger )iouId rate:(CGFloat)rate;


//写借条专用协议格式
+(NSString *)makeWriteProtocol:(CGFloat)ui_loan_val rate:(NSNumber *)ui_loan_rate startDate:(NSString *)ui_loan_start_date endDate:(NSString *)ui_loan_end_date type:(NSInteger)iou_type user_id:(NSString *)user_id usage:(NSInteger)ui_loan_usage;

//黑名单受限
+(BOOL)inBlackIOULimited;

+(NSString *)averageRate;

+(NSMutableAttributedString *)averageRate_attr;


@end
