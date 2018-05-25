//
//  GuaDetailConfig.m
//  Cashnice
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuaDetailConfig.h"

@implementation GuaDetailConfig

+(NSArray *)listTypes:(NSDictionary *)itemDict {
    
    if(!EMPTYOBJ_HANDLE(itemDict)){
        return nil;
    }
    
    NSInteger isoverdue = [itemDict[@"isoverdue"] integerValue];
    NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];

    NSMutableArray *array = @[].mutableCopy;

    NSDictionary *tempDic0_0 =@{@"交易信息":
                                    @[@"发布日",@"到期日",@"已借",@"年利率",@"应付利息",@"应还款",@"已还款",@"还须还款",@"担保金"]
                                };
    NSDictionary *tempDic0_1 =  @{@"交易信息":
                                      @[@"发布日" ,@"已借",@"待借",@"年利率",@"应付利息",@"本息合计",@"担保金"]
                                  };
    
    //逾期中（没有支付担保金）
    NSDictionary *tempDic0_2 =  @{@"交易信息":
                                      @[@"发布日",@"到期日",@"本金",@"年利率",@"应付利息",@"应付罚息",@"违约罚金",@"应还款",@"已还款",@"还须还款",@"担保金",@"已支付担保金",@"还须支付担保金"]

                                  };
    
    //正常
    NSDictionary *tempDic0_3 =  @{@"交易信息":
                                      @[@"发布日",@"到期日",@"本金",@"年利率",@"应付利息",@"应还款",@"已还款",@"还须还款",@"担保金",@"应付担保金"]
                                  };
    
    
    //（逾期）
    NSDictionary *tempDic0_4 =  @{@"交易信息":
                                      @[@"发布日",@"到期日",@"本金",@"年利率",@"应付利息",@"应付罚息",@"违约罚金",@"应还款",@"已还款",@"还须还款",@"应付担保金",@"已付担保金",@"收回担保金"]
                                  };
    
    
    NSDictionary *tempDic1 =  @{@"基本信息":
                                    
                                             @[@"标号",@"借款协议",@"担保人",@"投资人"]
                                         };
    
//    //（逾期）已成功支付担保金
//    NSDictionary *tempDic0_5 =  @{@"交易信息":
//                                      @[@"发布日",@"到期日",@"本金",@"年利率",@"应付利息",@"应付罚息",@"违约罚金",@"应还款",@"已还款",@"还须还款",@"应付担保金",@"已支付担保金"]
//                                  };
    
    

    NSDictionary *tempDic0_6 =  @{@"交易信息":
                                      @[@"发布日",@"到期日",@"本金",@"年利率",@"应付利息",@"应付罚息",@"违约罚金",@"应还款",@"已还款",@"还须还款",@"担保金",@"已支付担保金",@"还须支付担保金"]};
    
    NSDictionary *tempDic0_7 =  @{@"交易信息":
                                      @[@"发布日",@"到期日",@"本金",@"年利率",@"应付利息",@"应付罚息",@"违约罚金",@"应还款",@"已还款",@"还须还款",@"应付担保金",@"已付担保金"]};
    
    
    NSInteger isdeducted = [itemDict[@"isdeducted"] integerValue];

    //新代码
    if (loanstatus == 2) {
        //已满,还款中
        
        if (isoverdue == 1) {
            //逾期
            
            if (isdeducted == 0) {
                //未支付担保金
                [array addObject:tempDic0_2];
                [array addObject:tempDic1];
                return array;


            }else{
                //已支付担保金
                [array addObject:tempDic0_7];
                [array addObject:tempDic1];
                return array;

            }
        }
        

    }else if (loanstatus == 3) {
        //完成还款
        
        if (isoverdue == 1) {
            //逾期
            
            [array addObject:tempDic0_4];
            [array addObject:tempDic1];
            
            return array;

        }else{
            [array addObject:tempDic0_3];
            [array addObject:tempDic1];
            return array;

         }
        
    }
    
    
    //旧代码
    if (isoverdue == 1) {
        
        if (isdeducted == 0) {
            //未支付担保金(逾期中）
            [array addObject:tempDic0_2];
            
        }else{
            //：已成功支付担保金
            [array addObject:tempDic0_4];
        }

        [array addObject:tempDic1];

    }
    else{
        if (loanstatus == 2) {
            //已满,还款中
            [array addObject:tempDic0_0];
            [array addObject:tempDic1];
         }
        else if (loanstatus == 1 ) {
            //筹款中
            [array addObject:tempDic0_1];
            [array addObject:tempDic1];
             
         }
        else if (loanstatus == 3) {
            //完成还款
            [array addObject:tempDic0_3];
            [array addObject:tempDic1];
            
         }
        else if (loanstatus == 7) {
            //退款中
         }

    }
    
    return array;
}

@end
