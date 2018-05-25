//
//  NSDate+Custom.m
//  YQS
//
//  Created by l on 3/15/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

- (NSString *)fullFormatString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
	return [dateFormatter stringFromDate:self];
}
@end
