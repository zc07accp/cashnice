//
//  CouponNetEngine.m
//  Cashnice
//
//  Created by apple on 2017/2/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CouponNetEngine.h"

#define URL_COUPON_LIST @"coupon.order.list.get"
#define URL_INTEREST_LIST @"interestcoupon.order.list.get"

@implementation CouponNetEngine

-(id)init{
    self = [super init];
    return self;
}

-(void)getCouponList:(NSInteger)querytype
             redType:(REDMONEY_TYPE)red_type
       queryFromList:(BOOL)queryFromList
                page:(NSInteger)page
              coupontype:(NSString *)coupontype
          startmoney:(NSInteger)startmoney
             success:(void (^)(NSDictionary *, NSArray *))success
             failure:(void (^)(NSString *error))failure{
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(querytype) forKey:@"querytype"];
    if (startmoney>0) {
        [paras setObject:@(startmoney) forKey:@"startmoney"];
    }
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(queryFromList?DEFAULT_PAGE_SIZE:500) forKey:@"pagesize"];
    [paras setObject:@(page) forKey:@"pagenum"];
    
    if (coupontype && [coupontype length]) {
        [paras setObject:coupontype forKey:@"coupontype"];
    }
    

    [self sendHttpRequest:paras pathName:red_type==REDMONEY_TYPE_CASH?URL_COUPON_LIST:URL_INTEREST_LIST
                  version:@"3.0"
       compeletionHandler:^{
           
           NSDictionary*resp = [self getDictWithIndex:0];
           NSArray *couponlist = EMPTYOBJ_HANDLE(resp[@"couponlist"]);
           
           NSMutableDictionary *totalDic = nil;
//           if (red_type == REDMONEY_TYPE_CASH) {
           
               totalDic = @{}.mutableCopy;

               totalDic[@"totalcount"] = @([EMPTYOBJ_HANDLE(resp[@"totalcount"]) integerValue]);
           
                totalDic[@"total"] = @([EMPTYOBJ_HANDLE(resp[@"total"]) integerValue]);
           
               totalDic[@"available"] =  @([ EMPTYOBJ_HANDLE(resp[@"available"]) integerValue]);
               totalDic[@"used"] =  @( [EMPTYOBJ_HANDLE(resp[@"used"]) integerValue]);
               totalDic[@"pagecount"] = @( [EMPTYOBJ_HANDLE(resp[@"pagecount"]) integerValue]);
//           }
           
           if (couponlist) {
               
               NSMutableArray *result = [NSMutableArray array];

               for (NSDictionary*tempDic in couponlist) {
                   
                   //我的红包
                   if (red_type == REDMONEY_TYPE_CASH) {
                       RMViewModel *model = [[RMViewModel alloc]init];
                       model.queryFromList = queryFromList;
                       model.querytype = [EMPTYOBJ_HANDLE(resp[@"querytype"]) integerValue];
                       model.dic = tempDic;
                       [result addObject:model];
                   }else{
                       //加息券
                       RIViewModel *model =[[RIViewModel alloc]init];
                       model.queryFromList = queryFromList;
                       model.querytype = [EMPTYOBJ_HANDLE(resp[@"querytype"]) integerValue];
                       model.dic = tempDic;
                       [result addObject:model];
                   }
                   

               }
               
               success(totalDic, [result copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];

}

-(void)requestList:(REDMONEY_TYPE)red_type
     queryFromList:(BOOL)queryFromList
            params:(NSDictionary *)params
           success:(void (^)(NSDictionary *, NSArray *))success
           failure:(void (^)(NSString *error))failure{

    [self sendHttpRequest:params pathName:red_type==REDMONEY_TYPE_CASH?URL_COUPON_LIST:URL_INTEREST_LIST
                  version:@"3.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           NSArray *couponlist = EMPTYOBJ_HANDLE(resp[@"couponlist"]);
           
           NSMutableDictionary *totalDic = nil;
           //           if (red_type == REDMONEY_TYPE_CASH) {
           
           totalDic = @{}.mutableCopy;
           
           totalDic[@"total"] = @([EMPTYOBJ_HANDLE(resp[@"totalcount"]) integerValue]);
           totalDic[@"available"] =  @([ EMPTYOBJ_HANDLE(resp[@"available"]) integerValue]);
           totalDic[@"used"] =  @( [EMPTYOBJ_HANDLE(resp[@"used"]) integerValue]);
           totalDic[@"pagecount"] = @( [EMPTYOBJ_HANDLE(resp[@"pagecount"]) integerValue]);
           //           }
           
           if (couponlist) {
               
               NSMutableArray *result = [NSMutableArray array];
               
               for (NSDictionary*tempDic in couponlist) {
                   
                   //我的红包
                   if (red_type == REDMONEY_TYPE_CASH) {
                       RMViewModel *model = [[RMViewModel alloc]init];
                       model.queryFromList = queryFromList;
                       model.querytype = [EMPTYOBJ_HANDLE(resp[@"querytype"]) integerValue];
                       model.dic = tempDic;
                       [result addObject:model];
                   }else{
                       //加息券
                       RIViewModel *model =[[RIViewModel alloc]init];
                       model.queryFromList = queryFromList;
                       model.querytype = [EMPTYOBJ_HANDLE(resp[@"querytype"]) integerValue];
                       model.dic = tempDic;
                       [result addObject:model];
                   }
                   
                   
               }
               
               success(totalDic, [result copy]);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];


}

-(void)getSelectCouponList:(REDMONEY_TYPE)red_type
                    invest:(BOOL)invest
                startmoney:(NSInteger)startmoney
                   success:(void (^)(NSDictionary *, NSArray *))success
                   failure:(void (^)(NSString *error))failure{

    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(0) forKey:@"querytype"];
    if (startmoney>0) {
        [paras setObject:@(startmoney) forKey:@"startmoney"];
    }
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(500) forKey:@"pagesize"];
    [paras setObject:@(0) forKey:@"pagenum"];
    [paras setObject:@(invest?2:1) forKey:@"enviroment"];
    [self requestList:red_type queryFromList:NO
               params:paras success:^(NSDictionary *totalDic, NSArray *result) {
                   success(totalDic, [result copy]);

               } failure:^(NSString *error) {
                   if(failure){
                       failure(errMsg);
                   }
               }];
}

- (void)getPopCouponSuccess:(void (^)(NSString *))success
                    failure:(void (^)(NSString *error))failure{
    
/*
#ifdef TEST_TEST_SERVER
    NSDictionary *paras = @{NET_KEY_USERID : [ZAPP.myuser getUserID], @"test": @"true" };
#else
    NSDictionary *paras = @{NET_KEY_USERID : [ZAPP.myuser getUserID] };
#endif
*/
    NSDictionary *paras = @{NET_KEY_USERID : [ZAPP.myuser getUserID] };
    
    [self sendHttpRequest:paras pathName:@"user.popup.coupon.get"
                  version:@"1.0"
       compeletionHandler:^{
           
           NSDictionary*resp = [self getDictWithIndex:0];
           
           if ([resp isKindOfClass:[NSString class]]) {
               NSString *url = (NSString *)resp;
               success(url);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];

}

@end
