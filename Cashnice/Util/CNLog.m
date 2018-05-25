//
//  CNLog.m
//  Cashnice
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNLog.h"

@implementation CNLog

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
    NSString *logLevel = nil;
    switch (logMessage->_flag)
    {
        case DDLogFlagError:
            logLevel = @"[ERROR] >";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]  >";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]  >";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG] >";
            break;
        default:
            logLevel = @"[VBOSE] >";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@%@[line %lu] %@",
                           logLevel, logMessage->_function,
                           (unsigned long)logMessage->_line, logMessage->_message];
    return formatStr;
}


@end

