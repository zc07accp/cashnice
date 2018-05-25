//
//  CouponNetEngine.h
//  Cashnice
//
//  Created by apple on 2017/2/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNNetworkEngine.h"
#import "RMViewModel.h"
#import "RIViewModel.h"

@interface CouponNetEngine : CNNetworkEngine

/*
coupontype
 不传是全部的
0：默认分类，加息券
1：3.8节活动的转赠加息券
2：免息券
 
 */

-(void)getCouponList:(NSInteger)querytype
             redType:(REDMONEY_TYPE)red_type
       queryFromList:(BOOL)queryFromList
                page:(NSInteger)page
          coupontype:(NSString *)coupontype
          startmoney:(NSInteger)startmoney
             success:(void (^)(NSDictionary *, NSArray *))success
             failure:(void (^)(NSString *error))failure;


-(void)getSelectCouponList:(REDMONEY_TYPE)red_type
                    invest:(BOOL)invest
                startmoney:(NSInteger)startmoney
                   success:(void (^)(NSDictionary *, NSArray *))success
                   failure:(void (^)(NSString *error))failure;


- (void)getPopCouponSuccess:(void (^)(NSString *))success
                    failure:(void (^)(NSString *error))failure;


@end
