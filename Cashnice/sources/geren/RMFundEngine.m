//
//  RMFundEngine.m
//  Cashnice
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "RMFundEngine.h"

#define HTTP_RMFUND @"user.fund.search.get"

@implementation RMFundEngine

-(void)getDetailSuccess:(void (^)(NSDictionary *detail))success
         failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    
    [self sendHttpRequest:paras pathName:HTTP_RMFUND
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
