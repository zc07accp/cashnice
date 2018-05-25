//
//  NSDictionary+Custom.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Custom)

- (NSMutableDictionary *)deepCopy;
- (NSData *)dataSerialized;
@end
