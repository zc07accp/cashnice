//
//  UtilFile.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UtilFile.h"

@implementation UtilFile

+ (NSString*)libRoot
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString*)libFile:(NSString*)file
{
    NSString* res = @"";
    if ([file notEmpty]) {
        res = [[self libRoot] stringByAppendingPathComponent:[file trimmed]];
    }
    return res;
}

+ (NSString*)libSubFolder:(NSString*)subfolder file:(NSString*)file
{
    NSString* res = @"";
    if ([subfolder notEmpty] && [file notEmpty]) {
        res = [[[self libRoot] stringByAppendingPathComponent:[subfolder trimmed]] stringByAppendingPathComponent:[file trimmed]];
    }
    return res;
}

+ (NSString*)docRoot
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString*)docFile:(NSString*)file
{
    NSString* res = @"";
    if ([file notEmpty]) {
        res = [[self docRoot] stringByAppendingPathComponent:[file trimmed]];
    }
    return res;
}

+ (NSString*)docSubFolder:(NSString*)subfolder file:(NSString*)file
{
    NSString* res = @"";
    if ([subfolder notEmpty] && [file notEmpty]) {
        res = [[[self docRoot] stringByAppendingPathComponent:[subfolder trimmed]] stringByAppendingPathComponent:[file trimmed]];
    }
    return res;
}

+ (NSString*)resFile:(NSString*)name type:(NSString *)type
{
    NSString* res = @"";
    if ([name notEmpty] && [type notEmpty]) {
        res = [[NSBundle mainBundle] pathForResource:[name trimmed] ofType:[type trimmed]];
    }
    return res;
}

+ (NSString*)resFile:(NSString*)fullname
{
    NSString* rs = @"";
    if ([fullname notEmpty]) {
        NSString *file = [[fullname trimmed] lastPathComponent];
        NSString *type = [file pathExtension];
        NSString *name = [file stringByDeletingPathExtension];
        return [self resFile:name type:type];
    }
    return rs;
}

+ (BOOL)fileExists:(NSString*)file
{
    BOOL res = NO;
    if ([file notEmpty]) {
        res = [[NSFileManager defaultManager] fileExistsAtPath:[file trimmed]];
    }
    return res;
}

+ (void)fileDelete:(NSString *)file
{
    if ([file notEmpty] && [self fileExists:file]) {
        [[NSFileManager defaultManager] removeItemAtPath:[file trimmed] error:nil];
    }
}

+ (UIImage *)imageLoadRes:(NSString *)path {
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
    if ([img notEmpty]) {
        return img;
    }
    else {
        return nil;
    }
}

@end
