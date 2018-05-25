//
//  UtilTimeStamp.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UtilTimeStamp.h"

@implementation UtilTimeStamp


+ (NSDateFormatter *)getFormatter:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

+ (NSString *)fullString:(NSDate *)date {
    return [[self getFormatter:@"yyyyMMddhhmmss"] stringFromDate:date];
}

+ (NSString *)yqsTimestampString:(NSDate *)date {
    return [[self getFormatter:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:date];
}


+ (NSString *)yearMonthDay:(NSDate *)date {
    return [[self getFormatter:@"yyyy-MM-dd"] stringFromDate:date];
}

+ (NSString *)hourMinuteSecond:(NSDate *)date {
    return [[self getFormatter:@"hhmmss"] stringFromDate:date];
}

+ (NSString *)hourMinute:(NSDate *)date {
    return [[self getFormatter:@"hhmm"] stringFromDate:date];
}

#pragma mark - time calculate, unused


+ (NSDate *)aWeekBeforeToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *daycomponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                      fromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-6];
    return [calendar dateByAddingComponents:components toDate:[calendar dateFromComponents:daycomponents] options:0];
}

+ (NSDate *)firstDayOfThisWeek { //week means monday - sunday
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *daycomponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                      fromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    int offset = 0;
    if ([weekdayComponents weekday] == [calendar firstWeekday]) {
        offset = -6;
    }
    else {
        offset = -(int)([weekdayComponents weekday] - [calendar firstWeekday]) + 1;
    }
    [components setDay:offset];
    return [calendar dateByAddingComponents:components toDate:[calendar dateFromComponents:daycomponents] options:0];
}

+ (NSDate *)lastDayOfThisWeek { //week means monday - sunday
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *daycomponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                      fromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    int offset = 0;
    if ([weekdayComponents weekday] == [calendar firstWeekday]) {
        offset = 0;
    }
    else {
        offset = -(int)([weekdayComponents weekday] - [calendar firstWeekday]) + 7;
    }
    [components setDay:offset];
    return [calendar dateByAddingComponents:components toDate:[calendar dateFromComponents:daycomponents] options:0];
}

+ (NSDate *)firstDayOfThisMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)firstDayOfThisYear {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    components.day = 1;
    components.month = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSString *)timestampAfterDays:(int)day {
NSDate *t = [NSDate dateWithTimeInterval:day * 3600 * 24 sinceDate:[NSDate date]];
    return [self yqsTimestampString:t];
}
@end
