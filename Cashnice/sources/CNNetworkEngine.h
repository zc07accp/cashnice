//
//  CNNetworkEngine.h
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NetworkEngine.h"

//每个业务类继承该类，不要直接使用。逐渐过渡，替代NetworkEngine

@interface CNNetworkEngine : NSObject
{
    NSString *errMsg;
    NSDictionary *respondDict;
    NSInteger errCode;

}


//默认关闭缓存
@property (nonatomic) BOOL closeAutoCache;

//是否关闭网络层的toast提示，默认为NO
@property (nonatomic) BOOL closeErrToast;

- (NSDictionary *)getDictWithIndex:(int)index;

//
///**
// *  验证接口是否成功
// *
// *  @param count
// *
// *  @return 成功失败
// */
//- (BOOL)responseSucWithCount:(int)count;

/**
 *  发起请求，post和get内部处理 (默认1.0版本)
 *
 *  @param params          参数dic
 *  @param pathName        接口名称
 *  @param completionBlock completionBlock description
 *  @param errorBlock      errorBlock description
    @return value 操作
 */
-(NSURLSessionDataTask *)sendHttpRequest:(NSDictionary *)params
                       pathName:(NSString*)pathName
             compeletionHandler:(NetResponseBlock)completionBlock
                   errorHandler:(NetErrorBlock)errorBlock;

/**
 *  发起请求（自定义版本号）
 *
 *  @param params          参数dic
 *  @param pathName        接口名称
 *  @param version         版本号
 *  @param completionBlock completionBlock description
 *  @param errorBlock      errorBlock description
 *
    @return  操作
 */
-(NSURLSessionDataTask *)sendHttpRequest:(NSDictionary *)params
                       pathName:(NSString*)pathName
                        version:(NSString*)version
             compeletionHandler:(NetResponseBlock)completionBlock
                   errorHandler:(NetErrorBlock)errorBlock;


/**
 *  取消当次实例全部请求
 */
-(void)cancleAllHttpRequest;

@end
