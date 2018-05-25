//
//  SendLoanEngine.m
//  Cashnice
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SendLoanEngine.h"

#define HTTPPATH_LOANORDER_POST @"loan.order.item.post"
#define HTTPPATH_LOANCONFIG_GET @"mortgage.constraint.check.get"
#define HTTPPATH_INVEST_TRANSFER_GET @"bet.turn.action.post"
#define HTTPPATH_BETTURN_GET @"bet.turn.detail.get"


@implementation SendLoanEngine

-(void)sendLoan:(NSDictionary *)dic
                     success:(void (^)(NSDictionary *loanFabuSucDetailDict))success
                     failure:(void (^)(NSString *error))failure
{

    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
 
    
    [self sendHttpRequest:dic pathName:HTTPPATH_LOANORDER_POST
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               if(success){
                 
                   success(resp);
                   
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
}

-(void)getLoanConfigWithSuccess:(void (^)(NSDictionary *loanConfigDict))success
                        failure:(void (^)(NSString *error))failure{
 
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSDictionary *param  =  @{@"userid": [ZAPP.myuser getUserID]};
    
    [self sendHttpRequest:param pathName:HTTPPATH_LOANCONFIG_GET
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               if(success){
                   
                   success(resp);
                   
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
}


-(void)investTransfer:(NSInteger)betid
              success:(void (^)())success
              failure:(void (^)(NSString *error))failure{
    
    if (betid<=0) {
        return;
    }
    
    NSDictionary *param  =  @{@"betid":@(betid)};
    
    [self sendHttpRequest:param pathName:HTTPPATH_INVEST_TRANSFER_GET
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               if(success){
                   success(resp);
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
}

-(void)getBetTurnDetail:(NSInteger)betid
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSString *error))failure{
    
    if (betid<=0) {
        return;
    }
    
    NSDictionary *param  =  @{@"betid":@(betid)};
    
    [self sendHttpRequest:param pathName:HTTPPATH_BETTURN_GET
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               if(success){
                   success(resp);
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
}


@end
