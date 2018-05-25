//
//  UtilDate.h
//  Cashnice
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilDate : NSObject

+(BOOL)endDateAvailable:(NSDate *)endDate;


+(NSDate *)getLaterEndDate:(NSDate *)startDate orgiEndDate:(NSDate *)_endDate;


@end
