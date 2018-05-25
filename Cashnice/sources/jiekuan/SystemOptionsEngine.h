//
//  SystemOptionsEngine.h
//  Cashnice
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"
#import "ShowUnit.h"

@interface SystemOptionsEngine : CNNetworkEngine

-(void)getSystemConfigSuccess:(void (^)())success
                      failure:(void (^)(NSString *error))failure;

-(void)getSystemConfigItem:(NSArray *)item
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSString *error))failure;

-(void)getVISASuccess:(void (^)())success
              failure:(void (^)(NSString *error))failure;

-(void)getUserIdentifyProgressSuccess:(void (^)())success
                              failure:(void (^)(NSString *error))failure;


-(void)getSystemOptionsListSuccess:(void (^)())success
                           failure:(void (^)(NSString *error))failure;

-(void)getInternationListSuccess:(void (^)())success
                         failure:(void (^)(NSString *error))failure;


/**
 获取用户转账功能是否开启

 @param complete 完成
 */
-(void)getUserTransferSwitchComplete:(void (^)(BOOL opened))complete;


/**
 获取banner列表

 @param complete 完成
 */
-(void)getBannersSuccess:(void (^)(NSArray*))complete
                 failure:(void (^)(NSString *error))failure;
-(NSArray *)readLocalBannerData;

-(void)getADComplete:(void (^)(NSDictionary *))complete;

@end
