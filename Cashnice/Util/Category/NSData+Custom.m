//
//  NSData+NotEmpty.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NSData+Custom.h"

@implementation NSData (Custom)

- (BOOL)notEmpty {
    return (self.length > 0);
}

- (NSString *)toHexString {
    if ([self notEmpty]) {
        NSMutableString *res = [NSMutableString string];
        Byte *bytes = (Byte *)[self bytes];
        int cnt = (int)[self length];
        for (int i = 0; i < cnt; i++) {
            [res appendFormat:@"%02X ", *(bytes + i) & 0xFF];
        }
        return res;
    } else {
        return @"";
    }
}

- (NSMutableDictionary *)dictionarySerialized {
    return (NSMutableDictionary *)[NSPropertyListSerialization propertyListWithData:self options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
}

- (NSString *)toUTF8String {
    if ([self length] > 0) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
}

@end
