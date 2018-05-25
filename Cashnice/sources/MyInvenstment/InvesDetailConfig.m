//
//  InvesDetailConfig.m
//  Cashnice
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvesDetailConfig.h"
#import "JieKuanUtil.h"

@implementation InvesDetailConfig

+(NSArray *)baseArr:(NSDictionary *)itemDict{
    
    if(!EMPTYOBJ_HANDLE(itemDict)){
        return nil;
    }
    
    NSInteger isoverdue = [itemDict[@"isoverdue"] integerValue];
    NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
    
    NSInteger ub_turn = [itemDict[@"ub_turn"] integerValue];

    
    BOOL pledge = [JieKuanUtil isPrivilegedWithLoan:itemDict];

    
    NSMutableArray *array = @[].mutableCopy;
    
    NSDictionary *tempDic0_0 =  @{@"交易信息":
                                      @[@"投资日",@"收回日",@"本金",@"年利率",@"到期利息",@"本息合计"]
                                  };
    //筹款中
    NSDictionary *tempDic0_1 =  @{@"交易信息":
                                      @[@"投资日",@"本金",@"年利率",@"预计利息",@"本息合计"]
                                  };

    
    NSDictionary *tempDic0_2 =  @{@"交易信息":
                                      @[@"投资日",@"收回日",@"本金",@"年利率",@"应收利息",@"应收罚息",@"本息合计",@"已收",@"待收"]
                                  };
    //完成
    NSDictionary *tempDic0_3 =  @{@"交易信息":
                                      @[@"投资日",@"收回日",@"本金",@"年利率",@"应收利息",@"已收",@"待收"]
                                  };
    
    
    NSDictionary *tempDic1 =  @{@"基本信息":
                                    @[@"标号",@"借款协议",pledge?@"抵押用户":@"担保人",@"投资人"]
                                };
    
    
    
    //我的投资-投资历史-投资信息__转入_-详情
    NSDictionary *tempDicXX =  @{@"交易信息":
                                      @[@"原投资日",@"转入日",@"收回日",@"本金",@"年利率",@"支付转入利息",@"应收利息",@"已收",@"待收"]
                                  };
    
    ///还款中 转入
    NSDictionary *tempDicX2 =  @{@"交易信息":
                                     @[@"原投资日",@"转入日",@"收回日",@"本金",@"年利率",@"支付转入利息",@"到期利息",@"本息合计"]
                                 };
    
    
    //逾期转入
    NSDictionary *tempDicX3 =  @{@"交易信息":
                                     @[@"原投资日",@"转入日",@"收回日",@"本金",@"年利率",@"支付转入利息",@"应收利息",@"应收罚息",@"本息合计",@"已收",@"待收"]
                                 };
    
    if (isoverdue == 1) {
        //逾期
        
        if(ub_turn == 2){
            //2 已转入 还完 没还完
            [array addObject:tempDicX3];
            [array addObject:tempDic1];
            
        }else if(ub_turn == 1){
            //转出
            [array addObject:tempDic0_3];
            [array addObject:tempDic1];
            
        } else{
            [array addObject:tempDic0_2];
            [array addObject:tempDic1];
        }
        

    }
    else{
        if (loanstatus == 2) {
            //还款中
            
            
            if(ub_turn == 0){
                //0 正常未转
                
                [array addObject:tempDic0_0];
                [array addObject:tempDic1];
                
            }else if(ub_turn == 1){
                //1 已转出
                [array addObject:tempDic0_3];
                [array addObject:tempDic1];
                
            }else if(ub_turn == 2){
                //2 已转入
                [array addObject:tempDicX2];
                [array addObject:tempDic1];

            }
            
        }
        else if (loanstatus == 1 ) {
            //筹款中
            [array addObject:tempDic0_1];
            [array addObject:tempDic1];
            
        }
        else if (loanstatus == 3) {
            //完成还款
            if(ub_turn == 2){
                //转入

                [array addObject:tempDicXX];

            }else if(ub_turn == 1){
                //1 已转出
                [array addObject:tempDic0_3];
                
            }else{
                [array addObject:tempDic0_3];
            }
            
            [array addObject:tempDic1];
            
            
            
        }
        else if (loanstatus == 7) {
            //退款中
        }
        
    }
    
    return array;

}


@end
