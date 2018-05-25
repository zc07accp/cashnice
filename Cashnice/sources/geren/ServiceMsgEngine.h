//
//  ServiceMsgEngine.h
//  Cashnice
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNNetworkEngine.h"

@interface ServiceMsgEngine : CNNetworkEngine

-(void)setNoticeRead:(NSInteger )nid
             success:(void (^)())success
             failure:(void (^)(NSString *error))failure;


-(void)getNoticeWithSuccess:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSString *error))failure;

@end
