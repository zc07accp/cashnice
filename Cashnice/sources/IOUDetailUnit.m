//
//  IOUDetailUnit.m
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailUnit.h"

@implementation IOUDetailUnit

+ (NSString *)getUserRealNameOrNickName:(NSDictionary *)dict {
    if (dict != nil) {
        NSString *real = [dict objectForKey:@"user_real_name"];
        NSString *nick = [dict objectForKey:@"nick_name"];
        if (!ISNSNULL(real) && [real notEmpty]) {
            return real;
        }
        else if (!ISNSNULL(nick) && [nick notEmpty]) {
            return nick;
        }
    }
    return @"";
}


@end
