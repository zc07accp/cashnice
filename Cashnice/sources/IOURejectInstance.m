//
//  IOURejectInstance.m
//  Cashnice
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOURejectInstance.h"

@implementation IOURejectInstance

static IOURejectInstance *shareInstance = nil;

+(IOURejectInstance*)shareInstance
{
    @synchronized(self)
    {
        if(shareInstance == nil)
        {
            shareInstance = [[IOURejectInstance alloc] init];
        }
    }
    return shareInstance;
}

-(void)getRejectReasonList:(NSInteger)oid
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSString *error))failure{
    
    if(dic && [dic objectForKey:@(oid)])
    {
        success([dic objectForKey:@(oid)]);
        return;
    }
    
    
    if(!engine){
        engine = [[IOUDetailEngine alloc]init];
    }
    
    [engine getRejectReasonList:oid success:^(NSArray *arr) {
        
        if (!dic) {
           dic = [NSMutableDictionary dictionary];
        }
        
        [dic setObject:arr forKey:@(oid)];
        success(arr);
        
    } failure:^(NSString *error) {
        failure(error);
    }];
}

@end
