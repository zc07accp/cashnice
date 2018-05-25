//
//  LoanDetailEngine.m
//  Cashnice
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanDetailEngine.h"
#import "MJExtension.h"

#define LOAN_INFO_GET  @"loan.info.basic.get"
#define LOAN_INFO_MORE_GET  @"loan.info.more.get"
#define LOAN_WATERFLOW_DETAIL_GET  @"loan.bill.detail.get"

@implementation  WaterFlowDetail

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"format_t_money"]) {
        return [Util formatRMB:oldValue];
    }
    
    return oldValue;
}

@end

@implementation LoanDetailEngine

-(void)getDetail:(NSInteger)loadId
          typeid:(NSString *)typeid
           betid:(NSInteger)betid
         success:(void (^)(NSDictionary *detail))success
         failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:typeid forKey:@"typeid"];
    
    if(betid>0){
        [paras setObject:@(betid) forKey:@"betid"];
    }
    
    [self sendHttpRequest:paras pathName:LOAN_INFO_GET
                  version:@"3.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}

-(void)getListDetail:(NSInteger)loadId
          typeid:(NSString *)typeid
           betid:(NSInteger)betid
         success:(void (^)(NSDictionary *detail))success
         failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:typeid forKey:@"typeid"];
    
    if(betid>0){
        [paras setObject:@(betid) forKey:@"betid"];
    }
    
    [self sendHttpRequest:paras pathName:LOAN_INFO_MORE_GET
                  version:@"3.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}

-(void)getWaterFlowDetail:(NSInteger)loadId
              typeid:(NSString *)typeid
                    betid:(NSInteger)betid
              success:(void (^)(NSArray *list))success
             failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:typeid forKey:@"typeid"];
    
    if(betid>0){
        [paras setObject:@(betid) forKey:@"betid"];
    }
    
    [self sendHttpRequest:paras pathName:LOAN_WATERFLOW_DETAIL_GET
                  version:@"3.0"
       compeletionHandler:^{
           NSArray*array = (NSArray*)[self getDictWithIndex:0];
           if (array) {
               
               [WaterFlowDetail mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                   return @{
                            @"format_t_money" : @"t_money",
                            @"t_time" : @"t_time",
                            @"t_type" : @"t_type"
                            };
               }];
               
               success([WaterFlowDetail mj_objectArrayWithKeyValuesArray:array]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
    
    
}

/**
 *  确认借款
 */
-(void)postConfirmLoan:(NSInteger)loadId
                 value:(double) value
               success:(void (^)(NSDictionary *detail))success
               failure:(void (^)(NSString *error))failure{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(value) forKey:@"val"];
    
    
    [self sendHttpRequest:paras pathName:@"loan.order.confirm.post"
                  version:@"1.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}


/**
 *  同意/不同意 担保
 */
-(void)postConfirmWarranty:(NSInteger)loadId
                 confirm:(NSString*) confirm
               success:(void (^)(NSDictionary *detail))success
               failure:(void (^)(NSString *error))failure{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:confirm forKey:@"confirm"];
    
    [self sendHttpRequest:paras pathName:@"loan.warranty.confirm.post"
                  version:@"1.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}

/**
 *  担保列表
 */
-(void)getWarrantyList:(NSInteger)loadId
                   pageNum:(NSInteger) pageNum
                   success:(void (^)(NSDictionary *detail))success
                   failure:(void (^)(NSString *error))failure{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(pageNum) forKey:@"pagenum"];
    [paras setObject:@(DEFAULT_PAGE_SIZE) forKey:@"pagesize"];
    //[paras setObject:@(2) forKey:@"pagesize"];
    
    [self sendHttpRequest:paras pathName:@"loan.warranty.list.get"
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}

/**
 *  更换担保列表
 */
-(void)getWithoutWarrantyList:(NSInteger)loadId
                     fromUser:(NSString *)fromUser
                      pageNum:(NSInteger) pageNum
                      success:(void (^)(NSDictionary *detail))success
                      failure:(void (^)(NSString *error))failure{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:fromUser forKey:@"from_user"];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(pageNum) forKey:@"pagenum"];
    [paras setObject:@(DEFAULT_PAGE_SIZE) forKey:@"pagesize"];
    //[paras setObject:@(2) forKey:@"pagesize"];
    
    [self sendHttpRequest:paras pathName:@"credit.withoutwarranty.list.get"
                  version:@"1.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}


/**
 *  更换担保人
 */
-(void)changeWarranty:(NSInteger)loadId
                     fromUser:(NSString *)fromUser
                     toUser:(NSString *)toUser
                      success:(void (^)(NSDictionary *detail))success
                      failure:(void (^)(NSString *error))failure{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loadId) forKey:NET_KEY_LOANID];
    [paras setObject:fromUser forKey:@"from_user"];
    [paras setObject:toUser forKey:@"to_user"];
    //[paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    
    [self sendHttpRequest:paras pathName:@"change.warranty.user.get"
                  version:@"1.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success([resp copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
}
@end
