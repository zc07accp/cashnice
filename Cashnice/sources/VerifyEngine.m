//
//  VerifyEngine.m
//  Cashnice
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "VerifyEngine.h"

#define HTTPPATH_GETVERIFYCODE @"system.validatecode.item.post"
#define HTTPPATH_VERIFYCODE @"system.validatecode.check.post"
@implementation VerifyEngine


-(void)getEmailVerifyCode:(NSString*)email
                 success:(void (^)(NSString *))success
                 failure:(void (^)(NSString *error))failure;
{
    
    if (!email) {
        failure(@"email null");
        return;
    }
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSDictionary *parms = @{@"validatetype":@(0),@"email":email};
    
    [self sendHttpRequest:parms pathName:HTTPPATH_GETVERIFYCODE
                  version:@"2.0"
       compeletionHandler:^{
        NSDictionary*resp = [self getDictWithIndex:0];
        if (resp) {
            NSString *validateuuid = EMPTYSTRING_HANDLE(resp[@"validateuuid"]);
            if(success){
                success(validateuuid);
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

-(void)verifyCode:(NSString *)email
     validateuuid:(NSString *)validateuuid
     validatecode:(NSString *)validatecode
                  success:(void (^)())success
                  failure:(void (^)(NSString *error))failure;
{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    if (!validateuuid) {
        return;
    }
    
    NSDictionary *parms = @{@"validateuuid":validateuuid,
                            @"device":email,
                            @"validatecode":validatecode};
    
    [self sendHttpRequest:parms pathName:HTTPPATH_VERIFYCODE
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
                if(success){
                    success();
               }
           }else{
               if(success){
                   success();
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
}

@end
