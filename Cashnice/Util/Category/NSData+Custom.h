//
//  NSData+NotEmpty.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Custom)

- (BOOL)notEmpty;
- (NSString *)toHexString;

- (NSMutableDictionary *)dictionarySerialized;
- (NSString *)toUTF8String;
@end
