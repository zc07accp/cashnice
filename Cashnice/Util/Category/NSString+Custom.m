//
//  NSString+NotEmpty.m
//  YQS
//
//  Created by l on 3/6/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NSString+Custom.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Custom)

- (BOOL)notEmpty {
    return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0);
}

- (NSString*)trimmed {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)md5 {
    if ([self notEmpty]) {
        const char* original_str = [self UTF8String];
        unsigned char result[16];
        CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
        NSMutableString* hash = [NSMutableString string];
        for (int i = 0; i < 16; i++) [hash appendFormat:@"%02x", result[i]];
        return hash;
    } else {
        return @"";
    }
}

- (NSData*)hexStringToData {
    if ([self notEmpty]) {
        NSMutableData* data = [NSMutableData data];
        uint32_t uint32;
        sscanf([[self trimmed] cStringUsingEncoding:NSASCIIStringEncoding], "%x", &uint32);
        uint8_t uint8 = (uint8_t)(uint32 & 0x000000FF);
        [data appendBytes:(void*)(&uint8)length:1];
        return data;
    } else {
        return nil;
    }
}

- (NSString*)encodeStringByNegativeAndPlusTheKey:(NSInteger)key {
    NSMutableString* rs = [[NSMutableString alloc] init];
    if ([self notEmpty] && self.length % 2 == 0) {
        NSMutableData* theData = [NSMutableData data];
        for (NSInteger i = 0; i < [self length]; i += 2) {
            NSString* xbyte = [self substringWithRange:NSMakeRange(i, 2)];
            [theData appendData:[xbyte hexStringToData]];
        }
        for (int i = 0; i < [theData length]; i++) {
            uint8_t xt;
            [theData getBytes:(void*)(&xt)range:NSMakeRange(i, 1)];
            xt = ~xt + key;
            [rs appendString:[NSString stringWithFormat:@"%02x", xt]];
        }
    }
    return rs;
}

- (NSString*)utf8String {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)mycontainsString:(NSString *)str {
    if ([str notEmpty]) {
        return [self rangeOfString:str].location != NSNotFound;
//        if ([UtilDevice systemVersionNotLessThan:@"8.0"]) {
//            return [self containsString:str];
//        }
//        else {
//            return [self rangeOfString:str].location != NSNotFound;
//        }
    }
    return NO;
}

- (NSString *)removeSpaceAndNewline
{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


@end
