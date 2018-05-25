//
//  NSString+NotEmpty.h
//  YQS
//
//  Created by l on 3/6/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

- (BOOL)notEmpty;
- (NSString *)trimmed;
- (NSString *)md5;
- (NSData *)hexStringToData;
- (NSString *)encodeStringByNegativeAndPlusTheKey:(NSInteger)key;
- (NSString *)utf8String;
- (BOOL)mycontainsString:(NSString *)str;

- (NSString *)removeSpaceAndNewline;

@end
