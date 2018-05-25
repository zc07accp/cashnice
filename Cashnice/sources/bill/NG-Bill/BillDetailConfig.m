//
//  BillDetailConfig.m
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillDetailConfig.h"
#import "BillInfoViewController.h"

@implementation BillDetailConfig

+(NSArray *)array1{
    return @[@"付款账户",@"创建时间",@"标号"];
}

+(NSArray *)array2{
    return @[@"到账账户",@"创建时间"];
}


+(NSArray *)array3{
    return @[@"到账账户",@"创建时间",@"标号"];;
}

+(NSArray *)configHeadArr:(NSString *)type{
    
    if ([type isEqualToString:@"TP"] ) {
        return @[@"money",@"head"];
    }else if ([type isEqualToString:@"TS"] ) {
        return @[@"money",@"head"];
    }
    return @[@"money"];
}

+(NSArray *)configTitleArr:(NSString *)type{
    
    if(![type isKindOfClass:[NSString class]])
    {
        return nil;
    }
    
    if ([type isEqualToString:@"W"] ||[type isEqualToString:@"提现"]) {
        return @[@"progress", @"转出账户", @"创建时间"];
    }
   
    else if ([type isEqualToString:@"C"] || [type isEqualToString:@"CA"] ) {
        //充值,激活充值
        return [self array2];
    }
    
    else if ([type isEqualToString:@"WF"]) {
        
//        [type isEqualToString:@"UB"] || 
        //UB是奖励代收，支出
        //WF是提现手续费
        return @[@"付款账户",@"创建时间"];
    }
    
    else if ([type isEqualToString:@"R"] || [type isEqualToString:@"还款"]||[type isEqualToString:@"RL"] || [type isEqualToString:@"RW"]) {
        //'RL'=>'还款', //借款人逾期还款
        //'RW'=>'还款', //担保人逾期还款-支付担保金

        return @[@"付款账户",@"年化利率",@"创建时间",@"标号"];
    }

    else if ([type isEqualToString:@"HO"]){
        //担保金垫付
        return [self array1];
    }
             
    else if ([type isEqualToString:@"PR"]  ) {
        //担保金收回
        return [self array3];
    }
    
    else if ([type isEqualToString:@"O"] ||[type isEqualToString:@"Y"] ){
        //退款
        return @[@"投资时间",@"标号"];
    }    else if ([type isEqualToString:@"LO"] ||[type isEqualToString:@"WO"] ){
        //退款
        return @[@"退款时间",@"标号"];
    }
    else if ([type isEqualToString:@"E"]){
        //收回
        return @[@"到账账户",@"年化利率",@"投资时间",@"收回时间",@"标号"];
    }else if ([type isEqualToString:@"G"]|| [type isEqualToString:@"HI"] || [type isEqualToString:@"RA"]|| [type isEqualToString:@"RB"]||[type isEqualToString:@"收回本金"] || [type isEqualToString:@"利息收入"] ) {
        //'RA'=>'收回', //投资人收到 借款人逾期还款
        //'RB'=>'收回', //投资人收到 担保人逾期还款-支付担保金

        return @[@"到账账户",@"年化利率",@"投资时间",@"还款时间",@"标号"];
    }
    
    else if ([type isEqualToString:@"L"]){
        //借款账户
        return @[@"到账账户",@"年化利率",@"预期利息",@"创建时间",@"标号"];
    }
    
    else if ([type isEqualToString:@"F"] || [type isEqualToString:@"违约罚金"]) {
        return [self array1];
    }
    
    
    else if ([type isEqualToString:@"UR"] ||[type isEqualToString:@"BONUS"] ||[type isEqualToString:@"现金红包"]) {
        return [self array2];
    }
    
    else if ([type isEqualToString:@"DL"] ||[type isEqualToString:@"DB"] ) {
        //收益分成 收益分成明细
        return [self array2];
     }
    
    else if ([type isEqualToString:@"B"] || [type isEqualToString:@"投资"]) {
        return @[@"付款账户",@"年化利率",@"预期收益",@"创建时间",@"标号"];
    }else if ( [type isEqualToString:@"HM"]) {
        //借条手续费退回
        return @[@"到账账户",@"创建时间",@"标号"];;
    }else if ([type isEqualToString:@"HF"] ) {
        //借条手续费支出
        return [self array1];
    }else if ([type isEqualToString:@"TP"] ) {
        //转出单号
        return @[@"转出账户",@"备注",@"创建时间"];;
    }else if ([type isEqualToString:@"TS"] ) {
        //转入单号：TS
        return @[@"到账账户",@"备注",@"创建时间"];
        
    }else if ([type isEqualToString:@"CS"] ) {
       // 投资 转出：--> 收回：CS  （代付）
        return @[@"到账账户",@"年化利率",@"投资时间",@"收回时间",@"标号"];
    }else if ([type isEqualToString:@"CP"] ) {
        //刘韧：投资 转入：--> 投资：CP （代收）
        return @[@"付款账户",@"年化利率",@"预期收益",@"创建时间",@"标号"];
    }
    
    
    return nil;
}

+(NSAttributedString *)reformMoney:(NSString *)money{

    NSString *moneyStr = [NSString stringWithFormat:@"%@元", money];

    NSMutableAttributedString *muStr = [Util getAttributedString:moneyStr font:[UIFont systemFontOfSize:[ZAPP.zdevice getDesignScale:43]] color:[UIColor blackColor]];
    [muStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[ZAPP.zdevice getDesignScale:24]]} range:NSMakeRange(moneyStr.length-1, 1)];
    
    return muStr;
}

+(NSString *)value:(NSString *)type keyName:(NSString*)key detailDic:(NSDictionary *)dic{
    
    if(![type isKindOfClass:[NSString class]])
    {
        return @"";
    }
    
    if (!dic) {
        return @"";
    }
    
    NSLog(@"key=%@", key);

    
    if ([key isEqualToString:@"标号"]) {
        if ([EMPTYSTRING_HANDLE(dic[@"ul_title"]) length] > 0) {
            return [NSString stringWithFormat:@"%@", EMPTYOBJ_HANDLE(dic[@"ul_title"])];
        }else{
            if (EMPTYOBJ_HANDLE(dic[@"ui_title"])) {
                return [NSString stringWithFormat:@"%@", EMPTYOBJ_HANDLE(dic[@"ui_title"])];
            }
        }
     }
    
    else if ([key isEqualToString:@"本金"]) {
        
        if ([EMPTYSTRING_HANDLE(dic[@"val"]) length] > 0) {
            return EMPTYSTRING_HANDLE(dic[@"val"]);
        }else{
            return EMPTYSTRING_HANDLE(dic[@"urs_main_val"]);
        }
        
    }
    
    else if ([key isEqualToString:@"投资时间"] || [key isEqualToString:@"退款时间"] ) {
        return EMPTYSTRING_HANDLE(dic[@"create_time"]);
    }
    else if ([key isEqualToString:@"还款时间"] || [key isEqualToString:@"收回时间"]) {
        if ([type isEqualToString:@"O"]){
            return EMPTYSTRING_HANDLE(dic[@"ub_rollback_time"]);
        }else if ([EMPTYSTRING_HANDLE(dic[@"urs_time"]) length] > 0) {
                return EMPTYSTRING_HANDLE(dic[@"urs_time"]);
         }else if ([EMPTYSTRING_HANDLE(dic[@"uos_time"]) length] > 0) {
            return EMPTYSTRING_HANDLE(dic[@"uos_time"]);
         }
        
    }
    
    else if ([key isEqualToString:@"创建时间"]) {
        if ([EMPTYSTRING_HANDLE(dic[@"create_time"]) length] > 0) {
                return EMPTYSTRING_HANDLE(dic[@"create_time"]);
        }else if ([EMPTYSTRING_HANDLE(dic[@"create_date"]) length] > 0) {
                return EMPTYSTRING_HANDLE(dic[@"create_date"]);
        }
        return EMPTYSTRING_HANDLE(dic[@"time"]);

    }
    
    
    else if ([key isEqualToString:@"预期收益"]) {
    
        if (EMPTYOBJ_HANDLE(dic[@"uds_interest_val"])) {
            return [Util formatRMB:@([dic[@"uds_interest_val"] doubleValue])];
        }
    }
    
    else if ([key isEqualToString:@"预期利息"]) {
        if (EMPTYOBJ_HANDLE(dic[@"ul_repayable_interest_val"])) {
            return [Util formatRMB:@([dic[@"ul_repayable_interest_val"] doubleValue])];
        }
     }
    
    
    else if ([key isEqualToString:@"年化利率"]) {
  
        if([EMPTYSTRING_HANDLE(dic[@"ur_rate"]) length] > 0){

            return [NSString stringWithFormat:@"%@%%", [self formatNumFromString:EMPTYSTRING_HANDLE(dic[@"ur_rate"])]
                    ];
            ;
        }else if([EMPTYSTRING_HANDLE(dic[@"ub_rate"]) length] > 0){
            return [NSString stringWithFormat:@"%@%%",  [self formatNumFromString:EMPTYSTRING_HANDLE(dic[@"ub_rate"])]
                    ];
            ;
        }else if([EMPTYSTRING_HANDLE(dic[@"ul_loan_rate"]) length] > 0){
            return [NSString stringWithFormat:@"%@%%", [self formatNumFromString: EMPTYSTRING_HANDLE(dic[@"ul_loan_rate"])]];
        }else if([EMPTYSTRING_HANDLE(dic[@"rate"]) length] > 0){
            return [NSString stringWithFormat:@"%@%%", [self formatNumFromString: EMPTYSTRING_HANDLE(dic[@"rate"])]];
        }
    }
    
    else if ([key isEqualToString:@"到账账户"] || [key isEqualToString:@"付款账户"]|| [key isEqualToString:@"转出账户"]) {
        if([EMPTYSTRING_HANDLE(dic[@"pay_account"]) length] > 0){
            return EMPTYSTRING_HANDLE(dic[@"pay_account"]);
        }
        
        else if([EMPTYSTRING_HANDLE(dic[@"recieve_account"]) length] > 0){
            return EMPTYSTRING_HANDLE(dic[@"recieve_account"]);
        }
        return @"余额";
    }
 
    else if ([type isEqualToString:@"W"] || [type isEqualToString:@"C"] || [type isEqualToString:@"HO"]) {
        if ([key isEqualToString:@"转入账户"] || [key isEqualToString:@"付款账户"]) {
            return EMPTYSTRING_HANDLE(dic[@"bank_name"]) ;
        }
        
    }  else if ([key isEqualToString:@"备注"]) {
            return EMPTYSTRING_HANDLE(dic[@"comment"]) ;        
    }
    
    
    
    return @"";
}

+(NSString *)formatNumFromString:(NSString *)str{
    
    return [Util formatRMBWithoutUnit:@([str doubleValue])];

}

+(NSString *)value:(NSString *)key listDic:(NSDictionary *)dic{
    
    if(![key isKindOfClass:[NSString class]])
    {
        return @"";
    }
    
    if ([key isEqualToString:@"到账账户"] || [key isEqualToString:@"转出账户"])  {
        return @"余额";
    }
    
    else if ([key isEqualToString:@"创建时间"]) {
        return EMPTYSTRING_HANDLE(dic[@"time"]);
    }
    
    return @"";
}


+(NSArray *)actionArr{
    
//    'RA'=>'收回', //投资人收到 借款人逾期还款
//    'RB'=>'收回', //投资人收到 担保人逾期还款-支付担保金

    return @[@"B",@"R",@"L",@"HO",@"PR",@"G",@"F",@"HI",@"E",@"RA",@"RB",@"RL",@"RW",@"CS",@"CP"];
    
}

+(UIColor *)contentColor:(NSString *)type title:(NSString *)title{
    
    NSArray *arr = [self actionArr];
 
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF IN %@",type];
    NSArray *result = [arr filteredArrayUsingPredicate:pred];
    
    if([result count] && [title isEqualToString:@"标号"]){
        return HexRGB(0x3399ff);
    }
 
    return [UIColor blackColor];
}

+(BOOL)shouldTapToOpen:(NSString *)type title:(NSString *)title{

    NSArray *arr = [self actionArr];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF IN %@",type];
    NSArray *result = [arr filteredArrayUsingPredicate:pred];
    
    if([result count] && [title isEqualToString:@"标号"]){
        return YES;
    }
    
    return NO;
}

+(UIViewController *)dispathTapOpenViewController:(NSString *)flag loadid:(NSInteger)loanid betid:(NSInteger)bet_id{
    
    if ([flag isEqualToString:@"HO"] || [flag isEqualToString:@"PR"] || [flag isEqualToString:@"RW"] ) {
        BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyGuarantee loanId:loanid betId:0];
        return vc;
        
    }  else if ([flag isEqualToString:@"G"] || [flag isEqualToString:@"B"] || [flag isEqualToString:@"HI"] || [flag isEqualToString:@"E"] || [flag isEqualToString:@"RA"] || [flag isEqualToString:@"RB"]
                ) {
        
        BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyInvestment loanId:loanid betId:bet_id];
        return vc;

        
    }else if ([flag isEqualToString:@"F"] || [flag isEqualToString:@"R"] || [flag isEqualToString:@"L"]  || [flag isEqualToString:@"RL"] ) {
        
        BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyLoan loanId:loanid betId:0];
        return vc;

        
    }else if ([flag isEqualToString:@"CS"] || [flag isEqualToString:@"CP"] ) {
//        
//        BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyLoan loanId:loanid betId:0];
//        return vc;
        
        BillInfoViewController *vc = [BillInfoViewController instanceWithLoanType:LoanBillTypeMyInvestment loanId:loanid betId:bet_id];
        return vc;
        
        
    }

    
    
    
    return nil;
    
}

@end
