//
//  UtilTimeStamp.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilTimeStamp : NSObject

+ (NSString *)fullString:(NSDate *)date;
+ (NSString *)yearMonthDay:(NSDate *)date;
+ (NSString *)hourMinuteSecond:(NSDate *)date ;
+ (NSString *)hourMinute:(NSDate *)date;
+ (NSString *)timestampAfterDays:(int)day;
+ (NSString *)yqsTimestampString:(NSDate *)date;

@end
