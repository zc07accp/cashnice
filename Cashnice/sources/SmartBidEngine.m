//
//  SmartBidEngine.m
//  Cashnice
//
//  Created by apple on 2017/3/20.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SmartBidEngine.h"
#import "WebViewController.h"

#define URL_AUTOBID_SETTING @"autobidding.hold.authority.get"
#define URL_AUTOBID_POST @"autobidding.order.item.post"
#define URL_AUTOBID_STATUS_CHANGE @"autobidding.status.change.post"

@implementation SmartBidEngine


-(void)getAutobiddingSetting:(NSString *)userid
            success:(void (^)(NSDictionary *))success
            failure:(void (^)(NSString *error))failure{
    
    if (!userid) {
        failure(@"userid null");
        return;
    }
    
    [self sendHttpRequest:@{@"userid":userid} pathName:URL_AUTOBID_SETTING compeletionHandler:^{
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

-(void)autobiddingPost:(NSDictionary *)params
                     success:(void (^)(NSDictionary *result))success
                     failure:(void (^)(NSString *error))failure{
    
    if (!params) {
        failure(@"params null");
        return;
    }
    
    [self sendHttpRequest:params pathName:URL_AUTOBID_POST compeletionHandler:^{
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



-(BOOL)canset:(NSDictionary *)dic originvc:(UIViewController *)vc{
    
    NSInteger canset = [dic[@"canset"] integerValue];
    if (canset == 0) {
        return NO;
    }
    
    return YES;
}

-(void)autobiddingStatusChange:(NSInteger)status
                        userid:(NSString *)userid
               success:(void (^)())success
               failure:(void (^)(NSString *error))failure{
    
 
    
    [self sendHttpRequest:@{@"userid":userid,@"status":@(status)}
                 pathName:URL_AUTOBID_STATUS_CHANGE compeletionHandler:^{
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
