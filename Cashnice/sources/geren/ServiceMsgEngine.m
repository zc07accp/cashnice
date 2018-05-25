//
//  ServiceMsgEngine.m
//  Cashnice
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ServiceMsgEngine.h"

#define HTTPPATH_NTOICEREAD @"notice.common.read.post"

@implementation ServiceMsgEngine

-(id)init{
    self = [super init];
    self.closeErrToast = YES;
    
    return self;
}

-(void)setNoticeRead:(NSInteger )nid
          success:(void (^)())success
          failure:(void (^)(NSString *error))failure
{
    if(![UtilDevice isNetworkConnected]){
        return;
    }
 
    NSDictionary *parms = @{@"userid":[ZAPP.myuser getUserID],
                            @"noticeid":@(nid)};
    
    [self sendHttpRequest:parms pathName:HTTPPATH_NTOICEREAD
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



-(void)getNoticeWithSuccess:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSString *error))failure{
    
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:[ZAPP.myuser getUserID] forKey:@"userid"];
    
    [self sendHttpRequest:paras pathName:@"notice.update.unread.get"
                  version:@"1.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
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
