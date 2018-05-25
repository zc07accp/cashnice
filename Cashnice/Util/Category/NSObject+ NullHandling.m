//
//  NSObject+ NullHandling.m
//  Cashnice
//
//  Created by a on 16/7/4.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NSObject+ NullHandling.h"

@implementation NSObject (NullHandling)

-(id)nullToEmpty {
    return (self == [NSNull null]) ? @"" : self;
}


@end
