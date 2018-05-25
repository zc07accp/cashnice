//
//  IOUListNetEngine.h
//  Cashnice
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface IOUListNetEngine : CNNetworkEngine

/**
 *  首页列表
 *
 *  @param parms   参数
 *  @param success 成功
 *  @param failure 失败
 */
-(void)getPendingList:(NSDictionary *)parms
              success:(void (^)(NSDictionary *))success
              failure:(void (^)(NSString *error))failure;

@end
