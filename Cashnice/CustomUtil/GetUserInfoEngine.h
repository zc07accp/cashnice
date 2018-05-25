//
//  GetUserInfoEngine.h
//  Cashnice
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface GetUserInfoEngine : CNNetworkEngine

-(void)getUserInfoSuccess:(void (^)())success
                  failure:(void (^)(NSString *error))failure;




@end
