//
//  VerifyEngine.h
//  Cashnice
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface VerifyEngine : CNNetworkEngine

-(void)getEmailVerifyCode:(NSString*)email
                  success:(void (^)(NSString *validateuuid))success
                  failure:(void (^)(NSString *error))failure;

-(void)verifyCode:(NSString *)email
     validateuuid:(NSString *)validateuuid
     validatecode:(NSString *)validatecode
          success:(void (^)())success
          failure:(void (^)(NSString *error))failure;

@end
