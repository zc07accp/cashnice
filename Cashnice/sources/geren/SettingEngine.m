//
//  LoanEngine.m
//  Cashnice
//
//  Created by apple on 2016/11/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SettingEngine.h"
//#define HTTPPATH_BILLLIST @"user.bill.list.get"
#import <PINCache.h>

@implementation SettingEngine


-(void)getInvestTestWithSuccess:(void (^)(NSDictionary *))success
                        failure:(void (^)(NSString *error))failure{
    
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:ZAPP.myuser.getUserID forKey:@"userid"];
    
    [self sendHttpRequest:paras pathName:@"user.investor.test.get"
                  version:@"1.0"
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


-(void)getPopTestWithSuccess:(void (^)(NSDictionary *))success
                        failure:(void (^)(NSString *error))failure{
    
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:ZAPP.myuser.getUserID forKey:@"userid"];
    
    [self sendHttpRequest:paras pathName:@"user.popup.testing.get"
                  version:@"1.0"
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

@end
