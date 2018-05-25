//
//  Base64EncoderDecoder.h
//  Base64EncoderDecoder
//
//  Created by Liu Tao on 12-11-6.
//  Copyright (c) 2012年 D-Haus Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64EncoderDecoder : NSObject

+ (NSString *)base64Encode:(NSData *)inData;
+ (NSData *)base64Decode:(NSString *)inString;

+ (NSString *)customEncodeToString:(NSData *)inData keyNegativeAndPlus:(NSInteger)key;
+ (NSData*)customEncodeToData:(NSData *)inData keyNegativeAndPlus:(NSInteger)key;
+ (NSData *)customDecode:(NSData *)inData keyMinusAndNegative:(NSInteger)key;

@end
