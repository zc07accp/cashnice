

//
//  TransferEngine.m
//  Cashnice
//
//  Created by a on 16/10/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferEngine.h"

@implementation TransferEngine


-(void)getTransferHistoryListWithUserId:(NSString *)userId
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                                success:(void (^)(NSArray *historyItems, BOOL isLastPage, NSInteger))success
                                failure:(void (^)(NSString *error))failure{
    
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    
    [parms setObject:userId forKey:NET_KEY_USERID];
    [parms setObject:@(page) forKey:NET_KEY_PAGENUM];
    [parms setObject:@(pageSize) forKey:NET_KEY_PAGESIZE];
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    [self sendHttpRequest:parms
                 pathName:NET_FUNC_user_transfer_history_get
                  version:@"3.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   NSArray *historyItems = EMPTYOBJ_HANDLE(resp[@"data"]);
                   NSInteger totalcount = [EMPTYOBJ_HANDLE(resp[@"totalcount"]) integerValue];

                   //int aa = [Util pageCount:resp] ;
                   
                   BOOL isLastPage = page >= [Util pageCount:resp];
                   
                   success(historyItems, isLastPage, totalcount);
               }
           }else{
               if(success){
                   success(nil, YES, 0);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
}

-(void)getTransferDataWithpage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(void (^)(NSArray *dataItems, BOOL isLastPage))success
                       failure:(void (^)(NSString *error))failure{
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    
    [parms setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [parms setObject:@(page) forKey:NET_KEY_PAGENUM];
    [parms setObject:@(pageSize) forKey:NET_KEY_PAGESIZE];
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    [self sendHttpRequest:parms
                 pathName:NET_FUNC_USERE_TRANSFER_DATA_GET
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   NSArray *dataItems = EMPTYOBJ_HANDLE(resp[@"data"]);
                   
                   //int aa = [Util pageCount:resp] ;
                   BOOL isLastPage = page >= [Util pageCount:resp];
                   
                   success(dataItems, isLastPage);
               }
           }else{
               if(success){
                   success(nil, YES);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
}


@end
