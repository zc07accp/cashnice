//
//  UtilDate.m
//  Cashnice
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "UtilDate.h"

@implementation UtilDate


+(BOOL)endDateAvailable:(NSDate *)endDate{
    
    if ([endDate compare:[NSDate date]] != NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

+(NSDate *)getLaterEndDate:(NSDate *)startDate orgiEndDate:(NSDate *)_endDate{
        
    NSDate*targetEndDate = [NSDate dateWithTimeInterval:0 sinceDate:_endDate];

    //enddate要大于startDate
    if(!targetEndDate || [targetEndDate compare:startDate] != NSOrderedDescending ||
       [UtilDate isSameDay:targetEndDate date2:startDate]){
        targetEndDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate: startDate];
    }
    
    //enddate要大于今天
//    NSDate *date = [NSDate date];
//    NSComparisonResult re = [targetEndDate compare:date];
    if ([targetEndDate compare:[NSDate date]] != NSOrderedDescending || [UtilDate isSameDay:targetEndDate date2: [NSDate date]]) {
        targetEndDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate: [NSDate date]];
    }
    
    return  targetEndDate;
}

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
