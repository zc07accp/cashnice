//
//  ListDetailDataReformer.h
//  Cashnice
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDetailDataReformer : NSObject
+(NSString *)valueForList:(NSDictionary *)detail title:(NSString *)title type:(NSString *)type;

+(BOOL)showWaterFlowTip:(NSDictionary *)itemDict type:(NSString *)type list:(NSArray *)waterList;

//红包
+(NSString *)couponPacket:(NSDictionary *)detail;

//加息券
+(NSString *)couponInterest:(NSDictionary *)detail;

@end
