//
//  ListDetailDataReformer.m
//  Cashnice
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ListDetailDataReformer.h"

@implementation ListDetailDataReformer


+(NSString *)valueForList:(NSDictionary *)detail title:(NSString *)title type:(NSString *)type{
    
    //投资
    if ([type isEqualToString:@"B"]) {
        if([title isEqualToString:@"到期利息"]){
                     return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"receivable_interest_val"])];
        }
    }
    
    
    if([title isEqualToString:@"发布日"]){
        return EMPTYSTRING_HANDLE(detail[@"audit_time"]) ;
        
    }else if([title isEqualToString:@"到期日"] || [title isEqualToString:@"还款日"] || [title isEqualToString:@"收回日"]){
        return EMPTYSTRING_HANDLE(detail[@"repayendtime"]);
        
    }else if([title isEqualToString:@"投资日" ] || [title isEqualToString:@"转入日" ]){
        return EMPTYSTRING_HANDLE(detail[@"ub_time"]);
    }
    else if([title isEqualToString:@"提交日"]){
        return EMPTYSTRING_HANDLE(detail[@"submittime"]);
    }else if([title isEqualToString:@"本金"]){
        
        if ([type isEqualToString:@"B"]) {
            return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"receivable_main_val"])];
        }else{
            return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"loanmainval"])];
        }
        
        
    }
    else if([title isEqualToString:@"已借"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"loaned_val"])];
        
    }else if([title isEqualToString:@"待借"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"loanremindval"])];
        
    }else if([title isEqualToString:@"本息合计"]){
        
        if ([type isEqualToString:@"B"]) {
            //投资人
            return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"receivable"])];
            
        }else if ([type isEqualToString:@"W"]) {
            //担保人
            return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"repayableval"])];
        }
        
        
    }
    else if([title isEqualToString:@"担保人"]){
        
        return [NSString stringWithFormat:@"%@", detail[@"warrantycount"]];
        
    }else if([title isEqualToString:@"投资人"]){
        
        return [NSString stringWithFormat:@"%@", detail[@"betscount"]];
        
    }else if([title isEqualToString:@"标号"]){
        
        return [NSString stringWithFormat:@"%@", detail[@"loantitle"]];
        
    }else if([title isEqualToString:@"担保金"]||[title isEqualToString:@"应付担保金"]){
        
        return  [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"ulw_val"])];
        
    }else if([title isEqualToString:@"已付担保金"] || [title isEqualToString:@"已支付担保金"]){
        
        return  [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"bededucted"])];
        
    }else if([title isEqualToString:@"年利率"]){

         return [NSString stringWithFormat:@"%@%%", [Util formatFloat:EMPTYOBJ_HANDLE(detail[@"loanrate"])]];

    }else if([title isEqualToString:@"应还利息"] || [title isEqualToString:@"应付利息"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"repayableinterestval"])];
    }else if([title isEqualToString:@"应还款"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"repayableval"])];
    }else if([title isEqualToString:@"已还款"] ){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"repayedval"])];
    }else if([title isEqualToString:@"还须还款"] || [title isEqualToString:@"还需还款"] ){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"reneedval"])];
        
    }else if([title isEqualToString:@"违约罚金"] ){
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"fine"])];
        
    }else if([title isEqualToString:@"预计利息"] || [title isEqualToString:@"应收利息"] ){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"receivable_interest_val"])];
    }else if([title isEqualToString:@"已收"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"bereceived"])];
    }else if([title isEqualToString:@"待收"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"waitingreceive"])];
    }else if([title isEqualToString:@"应付罚息"]){
//        if ([type isEqualToString:@"L"] || [type isEqualToString:@"W"]) {
            //借款，担保
            return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"overdue_interest"])];
//        }
    }else if([title isEqualToString:@"应收罚息"]){
        
        //投资人应收罚息
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"receivable_overdue_interest"])];
    }else if([title isEqualToString:@"还须支付担保金"]){

        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"waiting_deduct"])];
    }else if([title isEqualToString:@"收回担保金"]){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"received_deduct"])];
    }else if([title rangeOfString:@"支付转入利息"].location != NSNotFound){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"turn_interestval"])];
    }else if([title isEqualToString:@"原投资日"]){
        
        return EMPTYSTRING_HANDLE(detail[@"last_ub_time"]);
    }else if([title rangeOfString:@"支付转入利息"].location != NSNotFound){
        
        return [Util formatRMB:EMPTYOBJ_HANDLE(detail[@"turn_interestval"])];
    }
    
    
    
    return @"";
}

+(BOOL)showWaterFlowTip:(NSDictionary *)itemDict type:(NSString *)type list:(NSArray *)waterList{
    
    if ([waterList count]) {
        return YES;
    }
    
    if ([type isEqualToString:@"L"]) {
        NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
        if (loanstatus == 0) {
            //审核中
            return NO;
        }
    }   else  if ([type isEqualToString:@"W"]) {
        NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
        NSInteger isoverdue = [itemDict[@"isoverdue"] integerValue];

        //逾期的全部都要显示
        if (isoverdue != 1) {
            if (loanstatus == 1) {
                //筹款中
                return NO;
            } else if (loanstatus == 2) {
                //已满
                return NO;
                
            }else if (loanstatus == 3) {
                return NO;
    
            }
        }
        

    }
    
    
    return YES;
}

+(NSString *)couponPacket:(NSDictionary *)detail{

    return [NSString stringWithFormat:@"%@", EMPTYOBJ_HANDLE(detail[@"coupon"])];
}


+(NSString *)couponInterest:(NSDictionary *)detail{
    
    NSString *rate = [NSString stringWithFormat:@"+%@%%",[Util formatFloat:@([EMPTYOBJ_HANDLE(detail[@"interestcoupon"]) doubleValue]*kcoupan_rate_precision)]];


    return rate;

}


@end
