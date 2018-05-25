//
//  LoanEngine.m
//  Cashnice
//
//  Created by apple on 2016/11/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LoanEngine.h"
//#define HTTPPATH_BILLLIST @"user.bill.list.get"
#import <PINCache.h>

@implementation LoanEngine


-(void)getLoanInvesHistoryList:(NSInteger)loanId
          pageSize:(NSInteger)pageSize
                       pagenum:(NSInteger)num
           success:(void (^)(NSDictionary *))success
           failure:(void (^)(NSString *error))failure{
    
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(loanId) forKey:@"loanId"];
    [paras setObject:@(num) forKey:NET_KEY_PAGENUM];
    [paras setObject:@(pageSize) forKey:NET_KEY_PAGESIZE];
    
    [self sendHttpRequest:paras pathName:@"bet.user.list.get"
                  version:@"3.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
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

-(void)getLoanList:(NSInteger)page
          pageSize:(NSInteger)pageSize
           success:(void (^)(NSDictionary *))success
           failure:(void (^)(NSString *error))failure{

    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@[@(0),@(2),@(5)] forKey:NET_KEY_QUERYTYPES];
    [paras setObject:@[@(1), @(2)] forKey:NET_KEY_LOANSTATUS];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(page) forKey:NET_KEY_PAGENUM];
    [paras setObject:@(pageSize) forKey:NET_KEY_PAGESIZE];
    
    WS(weakSelf)
    
    [self sendHttpRequest:paras pathName:NET_FUNC_LOAN_ORDER_LIST_GET
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   
                   if(page == 0){
                       [weakSelf storeData:resp];
                   }
                   
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

-(NSString *)cacheKey:(NSString *)userID {
    NSString *key = [NSString stringWithFormat:@"LoanEngine_%@", userID] ;
    return key;
}

-(NSDictionary *)readlocalData{
    return (NSDictionary *)[[PINDiskCache sharedCache] objectForKey:[self cacheKey:[ZAPP.myuser getUserID]]];
}


-(void)clearLocalData{
    [[PINDiskCache sharedCache] removeObjectForKey:[self cacheKey:[ZAPP.myuser getUserID]]];
}

-(void)storeData:(NSDictionary *)dic{
    
    //存储本地
    
    if(dic){
        [[PINDiskCache sharedCache]setObject:dic forKey:[self cacheKey:[ZAPP.myuser getUserID]]];
    }else{
        [[PINDiskCache sharedCache] removeObjectForKey:[self cacheKey:[ZAPP.myuser getUserID]]];
    }

    
}

@end
