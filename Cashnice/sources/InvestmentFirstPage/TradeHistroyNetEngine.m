//
//  TradeHistroyNetEngine.m
//  Cashnice
//
//  Created by a on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "TradeHistroyNetEngine.h"

@implementation TradeHistroyNetEngine



- (void)historyList:(NSInteger)queryType
            pageNum:(NSInteger)pageNum
           pageSize:(NSInteger)pagSize
            success:(void (^)(NSDictionary *contentArray))success
            failure:(void (^)(NSString *))failure{
    
    NSDictionary *param = @{
                            @"querytype": @(queryType),
                            @"userid"   : ZAPP.myuser.getUserID,
                            @"pagenum"  : @(pageNum),
                            @"pagesize" : @(pagSize)
                            };
    
    [self doAction:param path:NET_FUNC_LOAN_FRIENDS_LIST_GET success:^(NSDictionary *response) {
        
        NSDictionary *contentData = (NSDictionary *)response;
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSString *error) {
        failure(error);
    }];
}




-(void)doAction:(NSDictionary *)parms
           path:(NSString *)path
        success:(void (^)(NSDictionary *))success
        failure:(void (^)(NSString *error))failure;
{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    NSString *apiVersion = parms[NET_KEY_API_VERSION];
    if ([apiVersion isKindOfClass:[NSNull class]] || apiVersion.length < 1) {
        apiVersion = @"1.0";
    }
    
    [self sendHttpRequest:parms pathName:path version:apiVersion compeletionHandler:^{
        NSDictionary*resp = [self getDictWithIndex:0];
        if (resp && ![resp isKindOfClass:[NSNull class]]) {
            if(success){
                success(resp);
            }
        }else{
            if(failure){
                failure(nil);
            }
        }
        
    } errorHandler:^{
        if(failure){
            [Util toast:errMsg];
            failure(errMsg);
        }
    }];
}



@end
