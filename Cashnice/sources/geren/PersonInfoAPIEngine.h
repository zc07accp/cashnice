//
//  PersonInfoAPIEngine.h
//  Cashnice
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

#define KUSER_INFO_FRESH @"KUSER_INFO_FRESH"

@interface PersonInfoAPIEngine : CNNetworkEngine
{
}
@property (strong, nonatomic) void (^userInfoFreshBlock)();
@property (strong, nonatomic) void (^visaFreshBlock)();

+(id)sharedInstance;



///**
// 上传身份证照片
//
// @param image 身份证照片，需要提前验证真伪
// */
//-(void)uploadCardID:(UIImage *)image type:(NSInteger)type success:(void (^)())success
//            failure:(void (^)())failure;


-(void)uploadCardID:(UIImage *)zimage fimage:(UIImage *)fimage success:(void (^)())success
            failure:(void (^)())failure;

//上传营业执照
-(void)uploadLicense:(UIImage *)image
             success:(void (^)())success
             failure:(void (^)())failure;
/**
 上传头像

 @param image 头像
 @param success 成功失败，返回url
 */
-(void)uploadHeaderImage:(UIImage *)image success:(void (^)(NSString *))success;


//-(void)getUserIdentifyResult:(NSString *)userId
//                     success:(void (^)(NSDictionary *))success
//                     failure:(void (^)(NSString *error))failure;
///**
// 工作在
// 
// @param company
// @param success 成功失败
// */
//-(void)setUserIdentityCompany:(NSString *)company
//                      success:(void (^)())success
//                      failure:(void (^)(NSString *error))failure;


/**
 获取个人认证结果

 @param userId 用户id
 @param success 结果
 @param failure 失败
 */
-(void)getUserIdentifyResult:(NSString *)userId
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSString *error))failure;

/**
 职务
 
 @param job
 @param success 成功失败
 */
-(void)setUserIdentityJob:(NSString *)job
                  success:(void (^)())success
                  failure:(void (^)(NSString *error))failure;

/**
 通讯地址
 
 @param address
 @param success 成功失败
 */
-(void)setUserIdentityAddress:(NSString *)address
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure;

/**
 社会职务
 
 @param positions
 @param success 成功失败
 */
-(void)setUserIdentityPositions:(NSArray *)positions
                        explain:(NSString *)explain
                        success:(void (^)())success
                        failure:(void (^)(NSString *error))failure;


-(void)setUserIdentityCompany:(NSString *)company
                          job:(NSString *)job
                      address:(NSString *)address
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure;
/**
 社会职务系统配置
 
 @param positions
 @param success 成功失败
 */
-(void)getSystemSocietyPositionSuccess:(void (^)(NSDictionary *))success
                               failure:(void (^)(NSString *error))failure;

/**
 营业执照系统配置
 
 @param positions
 @param success 成功失败
 */
-(void)getLicenseDetailSuccess:(void (^)(NSDictionary *))success
                               failure:(void (^)(NSString *error))failure;

/**
    绑卡验证
 */
- (void)checkBankValidateCode:(NSString *)code
                      orderNo:(NSString *)orderNo
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure;
/**
 绑卡提交
 */
- (void)bindBankCommitName:(NSString *)name
                  idnumber:(NSString *)idnumber
                   success:(void (^)())success
                   failure:(void (^)(NSString *error))failure;
@end
