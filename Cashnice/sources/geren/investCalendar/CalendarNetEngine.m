//
//  SinaCashierNetEngine.m
//  Cashnice
//
//  Created by a on 16/8/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CalendarNetEngine.h"

@implementation CalendarNetEngine


- (void)betDateList:(NSString *)value
            success:(void (^)(NSArray *contentArray))success
            failure:(void (^)(NSString *))failure {
    
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                            @"date": value
                            };
    
    [self doAction:param path:NET_FUNC_BET_DATE_LIST_GET success:^(NSDictionary *response) {
        
        NSArray *contentData = (NSArray *)response;
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSString *error) {
        failure(error);
    }];
}

- (void)calendarBetListWithBegin:(NSString *)begin
                             end:(NSString *)end
                            page:(NSInteger)page
                         success:(void (^)(NSDictionary *content))success
                         failure:(void (^)(NSString *))failure{
    NSDictionary *param = @{
                            @"beginday": begin,
                            @"endday": end,
                            @"pagenum" : @(page),
                            @"pagesize" : @(DEFAULT_PAGE_SIZE)
                            };
    
    [self doAction:param path:NET_FUNC_CALENDAR_LIST_GET success:^(NSDictionary *response) {
        
        if (response && success) {
            success(response);
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


-(void)doActionWithResponse:(NSDictionary *)parms
                       path:(NSString *)path
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSDictionary *))failure;
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
            failure(respondDict);
        }
    }];
}

@end
