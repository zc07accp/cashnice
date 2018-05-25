//
//  RMFundEngine.h
//  Cashnice
//
//  Created by apple on 2016/11/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface RMFundEngine : CNNetworkEngine

-(void)getDetailSuccess:(void (^)(NSDictionary *detail))success
                failure:(void (^)(NSString *error))failure;

@end
