//
//  SinaCashierNetEngine.m
//  Cashnice
//
//  Created by a on 16/8/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SinaCashierNetEngine.h"

@implementation SinaCashierNetEngine

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
        apiVersion = @"3.0";
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
        apiVersion = @"3.0";
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
