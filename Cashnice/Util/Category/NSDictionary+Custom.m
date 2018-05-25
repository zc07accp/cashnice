//
//  NSDictionary+Custom.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NSDictionary+Custom.h"

@implementation NSDictionary (Custom)

- (NSMutableDictionary *)deepCopy {
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[self dataSerialized] options:NSJSONReadingMutableContainers error:nil];
    
    return [dictionary mutableCopy];
    //return [ dictionarySerialized];
}

- (NSData *)dataSerialized {
    
    //NSError *  error ;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    
    //NSData *data = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:&error];
    
    return data;
}

@end
