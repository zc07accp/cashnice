//
//  NSArray+Custom.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NSArray+Custom.h"

@implementation NSArray (Custom)

- (NSMutableArray*)deepCopy
{
    NSData* xdata = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:nil];
    return (NSMutableArray*)[NSPropertyListSerialization propertyListWithData:xdata options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
}

@end
