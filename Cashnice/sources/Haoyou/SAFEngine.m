//
//  SAFEngine.m
//  Cashnice
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SAFEngine.h"

@implementation SAFEngine

-(void)getSearchPhonePersons:(NSString *)key
                     pageNum:(NSInteger)pageNum
                   success:(void (^)(NSInteger total,NSInteger pageCount, NSArray *users))success
                   failure:(void (^)(NSString *error))failure
{
    
    if (!key) {
        failure(@"parms null");
        return;
    }
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:key forKey:NET_KEY_SEARCHKEY];
    [para setObject:@(pageNum) forKey:NET_KEY_PAGENUM];
    [para setObject:@(DEFAULT_PAGE_SIZE) forKey:NET_KEY_PAGESIZE];
    
    [self sendHttpRequest:para pathName:NET_FUNC_USER_LIST_SEARCH_GET
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               if(success){
                   NSInteger totalcount = [resp[@"totalcount"] integerValue];
                   NSInteger pagecount = [resp[@"pagecount"] integerValue];

                   NSArray *_users = resp[@"users"];
                   success(totalcount,pagecount, _users);
                   
               }
           }else{
               if(success){
                   success(0,0, nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
}

@end
