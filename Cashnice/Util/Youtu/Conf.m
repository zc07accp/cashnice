//
//  Conf.m
//  YoutuYunDemo
//
//  Created by Patrick Yang on 15/9/15.
//  Copyright (c) 2015年 Tencent. All rights reserved.
//

#import "Conf.h"

@implementation Conf

+ (Conf *)instance
{
    static Conf *singleton = nil;
    static dispatch_once_t once;
    
     dispatch_once(&once, ^{
        singleton = [[Conf alloc] init];;
    });
    return singleton;

}

-(instancetype)init{
    self = [super init];
    _appId = @"10009488";                                   // 替换APP_ID
    _secretId = @"AKIDqcDdu0PfEcqzIW5ppiU9f3JQPH1chPbe";    // 替换SECRET_ID
    _secretKey = @"3zmOp5ALl4EG95tY4TlvxvoZBdx9D8va";       // 替换SECRET_KEY
    _userId = @"2452992309";       //

    return self;
}

@end
