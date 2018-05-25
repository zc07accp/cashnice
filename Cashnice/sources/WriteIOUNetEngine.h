//
//  WriteIOUNetEngine.h
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

/**
 *  单业务网络请求和数据处理临时先放在一层
 */

@interface WriteIOUNetEngine : CNNetworkEngine
{
    NSOperation *totalFeeEngine;
}
/**
 *  搜索好友
 *
 *  @param parms   参数
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)getSearchContacts:(NSDictionary *)parms
                 success:(void (^)(NSArray *users,  NSInteger totalCount))success
                 failure:(void (^)(NSString *error))failure;

/**
 *  支付平台费用
 *
 *  @param parms   参数
 *  @param success
 *  @param failure 
 */
-(void)payServe:(NSDictionary *)parms
        success:(void (^)())success
        failure:(void (^)(NSString *error))failure;

///**
// *  生成借条
// *
// *  @param parms   参数
// *  @param success 新生成的id
// *  @param failure <#failure description#>
// */
//-(void)addNewIOU:(NSDictionary *)parms
//         success:(void (^)(NSInteger))success
//         failure:(void (^)(NSString *error))failure;

/**
 *  新建借条、更新借条
 *
 *  @param parms   参数
 *  @param images  要上传的images数组
 *  @param success iouid 借条id uploadedImagesArr已经上传的图片url数组
 *  @param failure <#failure description#>
 */
-(void)updateIOU:(NSDictionary *)parms
          images:(NSArray *)images
         success:(void (^)(NSInteger iouid, NSArray*uploadedImagesArr))success
         failure:(void (^)(NSString *error))failure;

/**
 *  新建借条、更新借条 用于支付
 *
 *  @param parms   参数
 *  @param images  要上传的images数组
 *  @param success iouid 借条id
 *  @param failure <#failure description#>
 */
-(void)payforIOU:(NSDictionary *)parms
          images:(NSArray *)images
         success:(void (^)(NSInteger iouid, NSData* contentData))success
         failure:(void (^)(NSString *error))failure;

/**
 *  获取平台服务费
 *
 *  @param parms   <#parms description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)getIOUCounterfee:(NSDictionary *)parms
                success:(void (^)(CGFloat))success
                failure:(void (^)(NSString *error))failure;

/**
 *  计算出所有的费用
 *
 *  @param parms   <#parms description#>
 *  @param success t 总价，i利息，v原价，
 *  @param failure <#failure description#>
 */
-(void)getIOUTotalFee:(NSDictionary *)parms
              success:(void (^)(CGFloat t,CGFloat i,CGFloat v))success
              failure:(void (^)(NSString *error))failure;



//获取借款用途
-(void)getUseageList;

/**
 *  获取借款利率
 *
 *  @param success 成功
 *  @param failure 失败
 */
-(void)getLoanRateSuccess:(void (^)(NSArray *))success
                  failure:(void (^)(NSString *error))failure;

/**
 *  再次发送的时候消息提醒
 *
 *  @param parms   <#parms description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)sendIOUAgain:(NSDictionary *)parms
            Success:(void (^)())success
            failure:(void (^)(NSString *error))failure;

/**
 *  获取平均利率
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)getAverageSuccess:(void (^)(CGFloat rate))success
                 failure:(void (^)(NSString *error))failure;

@end
