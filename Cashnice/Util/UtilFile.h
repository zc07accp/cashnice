//
//  UtilFile.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilFile : NSObject

+ (NSString *)libRoot;
+ (NSString *)libFile:(NSString *)file;
+ (NSString *)libSubFolder:(NSString *)subfolder file:(NSString *)file;

+ (NSString *)docRoot;
+ (NSString *)docFile:(NSString *)file;
+ (NSString *)docSubFolder:(NSString *)subfolder file:(NSString *)file;

+ (NSString *)resFile:(NSString *)name type:(NSString *)type;
+ (NSString *)resFile:(NSString *)fullname;

+ (BOOL)fileExists:(NSString *)file;
+ (void)fileDelete:(NSString *)file;

+ (UIImage *)imageLoadRes:(NSString *)path;

@end