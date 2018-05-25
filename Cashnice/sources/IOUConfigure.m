//
//  DetailType.m
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUConfigure.h"
#import "IOU.h"

@implementation IOUConfigure

+(NSString *)strValueFromDetail:(IOUDetailUnit *)detailUnit Key:(NSString *)key{
    
    if ([key isEqualToString:@"借款金额"]     ||   [key rangeOfString:@"本金"].location != NSNotFound) {
        return [Util formatRMB:@(detailUnit.ui_loan_val)];
    } else if ([key rangeOfString:@"借款日"].location != NSNotFound || [key rangeOfString:@"出借日"].location != NSNotFound ) {
        return detailUnit.ui_loan_start_date;
    } else if ([key rangeOfString:@"还款日"].location != NSNotFound) {
        return detailUnit.ui_loan_end_date;
    } else if ( [key rangeOfString:@"年利率"].location != NSNotFound  ||  [key rangeOfString:@"年化利率"].location != NSNotFound) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@%%", @(detailUnit.ui_loan_rate)]);
        return [NSString stringWithFormat:@"%@%%", @(detailUnit.ui_loan_rate)];
        
    } else if ([key isEqualToString:@"利息"]                          ||
               [key rangeOfString:@"应收利息"].location != NSNotFound  ||
               [key rangeOfString:@"应付利息"].location != NSNotFound) {
        return [Util formatRMB:@(detailUnit.ui_interest_val)];
        
    } else if ([key isEqualToString:@"平台管理费"] || [key isEqualToString:@"平台服务费"]) {
        return [Util formatRMB:@(detailUnit.ui_commission)];
    } else if ([key rangeOfString:@"驳回原因"].location != NSNotFound) {
        return detailUnit.backReason;
    }else if ([key rangeOfString:@"出借人"].location != NSNotFound) {
        return [IOUDetailUnit getUserRealNameOrNickName:detailUnit.srcUser];
    }else if ([key rangeOfString:@"借款人"].location != NSNotFound) {
        return [IOUDetailUnit getUserRealNameOrNickName:detailUnit.destUser];
    }else if ([key rangeOfString:@"出借日"].location != NSNotFound || [key rangeOfString:@"借入日"].location != NSNotFound) {
        return detailUnit.ui_loan_start_date;
    }else if ([key rangeOfString:@"还款日"].location != NSNotFound || [key rangeOfString:@"收回日"].location != NSNotFound) {
        if (detailUnit.ui_status == IOU_STATUS_REPAY_CONFIRM) {
            return detailUnit.format_repay_confirm_time;
        }else{
            return detailUnit.ui_loan_end_date;
        }
    }else if ([key rangeOfString:@"逾期利息"].location != NSNotFound  || [key rangeOfString:@"应收罚息"].location != NSNotFound || [key rangeOfString:@"应收逾期利息"].location != NSNotFound ){
        return [Util formatRMB:@(detailUnit.ui_overdue_interest_val)];
        
    }else if ([key rangeOfString:@"应还款"].location != NSNotFound  || [key rangeOfString:@"应收回"].location != NSNotFound) {
        return [Util formatRMB:@(detailUnit.total_amount)];
    }else if ([key rangeOfString:@"已还款"].location != NSNotFound  || [key rangeOfString:@"实际收回"].location != NSNotFound) {
        return [Util formatRMB:@(detailUnit.ui_repay_amount)];
    }else if ([key rangeOfString:@"交易编号"].location != NSNotFound ) {
        return detailUnit.ui_orderno;
    }else if ([key rangeOfString:@"借款用途"].location != NSNotFound ) {
        return detailUnit.iouUsage;
    }else if ([key rangeOfString:@"还款方式"].location != NSNotFound ) {
        return detailUnit.label_repay_type;
    }
    return @"";

}

+(NSString *)averageRate{
 
    return [NSString stringWithFormat:@"年化利率(平台平均利率为%@%%)",[Util formatRMBWithoutUnit:@(ZAPP.myuser.averageRate)]
            ];
}

+(NSMutableAttributedString *)averageRate_attr{
    
    NSString *str = [NSString stringWithFormat:@"年化利率(平台平均利率为%@%%)",[Util formatRMBWithoutUnit:@(ZAPP.myuser.averageRate)]];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:str];
    NSInteger len      =[str length];
    
    [attString addAttribute:NSForegroundColorAttributeName value:CN_TEXT_GRAY_9 range:NSMakeRange(0, len)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, len)];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13]  range:NSMakeRange(4,  str.length - 4)];
    
    return attString;
}



+(NSArray *)detail1:(NSInteger)type{
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"借款金额",@"借款日期", @"还款日期", [[self class] averageRate],@"利息", @"借款用途及凭证", @"平台服务费", @"借条协议", nil];
    
    if(type == 0 || type == 2){
        [arr addObject:@"状态"];
    }else if(type == 1 || type == 3){
        [arr addObject:@"驳回原因"];
    }
    
    return arr;
}

+(NSInteger)detail1Type:(NSDictionary*)dic{
    
    NSInteger ui_status=[dic[@"ui_status"] integerValue];
    
    NSInteger type=0;
 
        //我是出借人
        NSInteger ui_src_user_id = [dic[@"ui_src_user_id"] integerValue];
        if(ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]){
            
            //被驳回
            if(ui_status == 3){
                type = 1;
            }else{
                type = 0;
            }
            
        }else{
            //我是借款人
            
            //被驳回
            if(ui_status == 3){
                type = 3;
            }else{
                type = 2;
            }

    }
 
    
    
    return type;
}

+(NSInteger)detail2Type:(NSDictionary*)dic{
    
//    NSInteger ui_status=[dic[@"ui_status"] integerValue];
    
    NSInteger type;
    
    //我是出借人
    NSInteger ui_src_user_id = [dic[@"ui_src_user_id"] integerValue];
    if(ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]){
        
        type=0;
//        
//        //被驳回
//        if(ui_status == 3)
//        {
//            type = 1;
//        }else{
//            type = 0;
//        }
        
    }else{
        //我是借款人
        type = 1;

//        //被驳回
//        if(ui_status == 3)
//        {
//            type = 3;
//        }else{
//            type = 2;
//        }
        
    }
    
    
    return type;
}



+(NSArray *)detail2:(NSInteger)type{
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"借款金额",@"借款日期", @"还款日期", [[self class] averageRate],@"利息", @"借款用途及凭证", @"平台服务费", @"借条协议", nil];
    
    if(type != 4){
        [arr addObject:@"上次驳回原因"];
    }

//    if(type == 0 || type == 2){
//        [arr addObject:@"状态"];
//    }else if(type == 1 || type == 3){
//        [arr addObject:@"驳回原因"];
//    }
    
    return arr;
}

+(NSArray *)writeIOUItemArray{
    return  [NSArray arrayWithObjects:@"我是",@"借款金额",@"借款日期",@"还款日期",[[self class] averageRate],@"对方姓名",@"借款用途及凭证",@"平台服务费",@"", nil];
}


+(NSString *)makeEditProtol:(IOUDetailUnit *)detailUnit{
    
    NSInteger iou_type = 0;
    NSInteger ui_src_user_id = detailUnit.ui_src_user_id;
    if (ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]) {
        //我是出借人
        iou_type = 1;
    }
    

    
    NSString *_protocol = [[NSString alloc]initWithFormat:IOU_PROTOCAL_EDIT, [NSString stringWithFormat:@"%@", @(detailUnit.ui_loan_val)],@(detailUnit.ui_loan_rate),detailUnit.ui_loan_start_date, detailUnit.ui_loan_end_date,@(iou_type),[ZAPP.myuser getUserID],@(detailUnit.ui_loan_usage)];

    return _protocol;
}



+(NSString *)makeNOEditProtol:(NSInteger )iouId{

    NSString *_protocol = [NSString stringWithFormat:IOU_PROTOCAL_NOEDIT, @(iouId)];
    return _protocol;
}

+(NSString *)makeAgreeProtol:(NSInteger )iouId rate:(CGFloat)rate{
    NSString *_protocol = [NSString stringWithFormat:IOU_PROTOCAL_AGREE, @(iouId), @(rate)];
    return _protocol;
}


+(NSString *)makeWriteProtocol:(CGFloat)ui_loan_val rate:(NSNumber *)ui_loan_rate startDate:(NSString *)ui_loan_start_date endDate:(NSString *)ui_loan_end_date type:(NSInteger)iou_type user_id:(NSString *)user_id usage:(NSInteger)ui_loan_usage{
    
    NSString *_protocol = [[NSString alloc]initWithFormat:IOU_PROTOCAL_EDIT,[NSString stringWithFormat:@"%@", @(ui_loan_val)],ui_loan_rate,ui_loan_start_date, ui_loan_end_date,@(iou_type),[ZAPP.myuser getUserID],@(ui_loan_usage)];
    
    return _protocol;
}

+(BOOL)inBlackIOULimited{
    
    BOOL inBlackList = ([[ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_BLOCKTYPE] intValue] == 3);
    if (inBlackList) {
        TOAST_LOCAL_STRING(@"tip.iou.account.limit");
        return YES;
    }
    
    return NO;
}


@end
