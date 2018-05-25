//
//  LoanEngine.h
//  Cashnice
//
//  Created by apple on 2016/11/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface SettingEngine : CNNetworkEngine


-(void)getInvestTestWithSuccess:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSString *error))failure;

-(void)getPopTestWithSuccess:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSString *error))failure;
@end
