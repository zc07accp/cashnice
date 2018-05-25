//
//  UtilString.h
//  YQS
//
//  Created by l on 3/18/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilString : NSObject

+ (NSString *) getUserType:(UserLevelType)ty;
+ (NSString *)getJiekuanState:(LoanState)state;
+ (NSString *)getBetStateString:(BetType)state;
+ (LoanState)cvtIntToJiekuanState:(int)intv;
+ (BetType)cvtIntToBetState:(int)intv;
+ (UIColor *)bgColorJiekuanState:(LoanState)state ;
+ (NSString *)getFirstLetter:(NSString *)str;


@end
