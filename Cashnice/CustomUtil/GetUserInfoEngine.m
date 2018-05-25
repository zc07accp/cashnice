//
//  GetUserInfoEngine.m
//  Cashnice
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GetUserInfoEngine.h"

@implementation GetUserInfoEngine

-(void)getUserInfoSuccess:(void (^)())success
            failure:(void (^)(NSString *error))failure{
    

    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(0) forKey:NET_KEY_ACTIONTYPE];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    
    [self sendHttpRequest:paras pathName:NET_FUNC_USER_PROFILE_INFO_GET compeletionHandler:^{
        NSDictionary*resp = [self getDictWithIndex:0];
        if (resp) {
            ZAPP.myuser.gerenInfoDict = resp;
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
