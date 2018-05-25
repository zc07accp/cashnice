//
//  SAFEngine.h
//  Cashnice
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface SAFEngine : CNNetworkEngine

/**
 根据手机号搜索好友

 @param key 手机号
 @param success 成功
 @param failure 失败
 */
-(void)getSearchPhonePersons:(NSString *)key
                     pageNum:(NSInteger)pageNum
                     success:(void (^)(NSInteger total,NSInteger pageCount, NSArray *users))success
                     failure:(void (^)(NSString *error))failure;
@end
