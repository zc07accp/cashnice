//
//  BillNetEngine.m
//  Cashnice
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillNetEngine.h"
#import <MJExtension.h>

#define HTTPPATH_BILLDETAIL @"user.bill.detail.get"

#define HTTPPATH_BILLLIST @"user.bill.list.get"

#define HTTPPATH_BILLDETAIL_FROMNOTI @"notice.transfer.detail.get"

#define HTTPPATH_BILLDETAIL_FROMSERVICEMSG_CHONGZHITIXIAN @"notice.bill.info.get"

@implementation BillNetEngine

-(BOOL)closeAutoCache{
    return NO;
}

-(void)getBillDetailFromServeMsgChongzhiTixian:(NSDictionary *)parms
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_BILLDETAIL_FROMSERVICEMSG_CHONGZHITIXIAN
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

-(void)getBillDetailFromNoti:(NSDictionary *)parms
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_BILLDETAIL_FROMNOTI
                  version:@"2.0"
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


-(void)getBillDetail:(NSDictionary *)parms
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_BILLDETAIL
                  version:@"2.0"
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


-(void)getBillList:(NSDictionary *)parms
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_BILLLIST
                  version:@"2.0"
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
