//
//  LoanDetailConfig.m
//  Cashnice
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanDetailConfig.h"
#import "JieKuanUtil.h"

@implementation LoanDetailConfig

+(NSArray *)listTypes:(NSDictionary *)itemDict{
    
    if(!EMPTYOBJ_HANDLE(itemDict)){
        return nil;
    }
    
    NSInteger isoverdue = [itemDict[@"isoverdue"] integerValue];
    NSInteger loanstatus = [itemDict[@"loanstatus"] integerValue];
    
    BOOL pledge = [JieKuanUtil isPrivilegedWithLoan:itemDict];
    
    NSMutableArray *array = @[].mutableCopy;
    
    NSDictionary *tempDic0_0 =  @{@"交易信息":
                                      @[@"发布日",@"还款日",@"已借",@"年利率",@"应付利息",@"应还款",@"已还款",@"还须还款"]
                                  };
    
    NSDictionary *tempDic0_1 =  @{@"交易信息":
                                      @[@"发布日",@"已借",@"待借",@"年利率",@"应付利息",@"应还款"]
                                  };
    
    
    NSDictionary *tempDic0_2 =  @{@"交易信息":
                                      @[@"发布日",@"还款日",@"本金",@"年利率",@"应付利息",@"应付罚息",@"违约罚金",@"应还款",@"已还款",@"还须还款"]
                                  };
    
    
    NSDictionary *tempDic0_3 =  @{@"交易信息":
                                      @[@"提交日",@"已借",@"待借",@"年利率",@"应付利息",@"应还款"]
                                  };
    //完成
    NSDictionary *tempDic0_4 =  @{@"交易信息":
                                      @[@"发布日",@"还款日",@"本金",@"年利率",@"应付利息",@"应还款",@"已还款",@"还须还款"]
                                  };
    
    NSDictionary *tempDic1 =  @{@"基本信息":
                                    @[@"标号",@"借款协议",pledge?@"抵押用户":@"担保人",@"投资人"]
                                };
    
    
    if (isoverdue == 1) {
        //逾期
        [array addObject:tempDic0_2];
        [array addObject:tempDic1];
    }
    else{
        if (loanstatus == 2) {
            //已满（还款、还款中）
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
            [array addObject:tempDic0_4];
            [array addObject:tempDic1];
        }
        else if (loanstatus == 7) {
            //关闭中
        }else if (loanstatus == 0) {
            //审核中
            [array addObject:tempDic0_3];
            [array addObject:tempDic1];
        }
        
    }
    
    return array;
}


@end
