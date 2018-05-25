//
//  IOUListNetEngine.m
//  Cashnice
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUListNetEngine.h"

#define HTTPPATH_IOU_PENDINGLIST @"iou.pending.list.get"

@implementation IOUListNetEngine

-(id)init{
    self = [super init];
    self.closeAutoCache = NO;
    return self;
}

-(void)getPendingList:(NSDictionary *)parms
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSString *error))failure;
{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_IOU_PENDINGLIST compeletionHandler:^{
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
-(void)getPendingListAF:(NSDictionary *)parms
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSString *error))failure;
{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_IOU_PENDINGLIST compeletionHandler:^{
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
