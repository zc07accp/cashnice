//
//  CNNetworkSuccHandle.h
//  Cashnice
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNNetworkSuccHandle : NSObject

@property(nonatomic,readonly) NSString *errMsg;
@property(nonatomic,readonly) BOOL succ;


/**
 检测1020系统错误

 @param respondDict
 @return 是否是
 */
-(BOOL)needHandleSystemError:(NSDictionary *)respondDict;


/**
 *  是否处理登录的异常问题
 *
 *  @param respondDict 
 *
 *  @return YES 表示有问题 NO 没有问题
 */
-(BOOL)needHandleLoginExp:(NSDictionary *)respondDict;


/**
 解析数据是否正确

 @param count
 @param respondDict
 */
- (void)responseSucWithCount:(int)count responseDict:(NSDictionary *)respondDict;


@end
