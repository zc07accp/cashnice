//
//  CNNetworkSuccHandle.m
//  Cashnice
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkSuccHandle.h"
#import "CustomReloginAlertView.h"


@implementation CNNetworkSuccHandle


-(BOOL)needHandleSystemError:(NSDictionary *)respondDict{
    
    int result_code = [[respondDict objectForKey:NET_KEY_RESULT] intValue];
    if (result_code == 1020) {
        return YES;
    }
    
    return NO;
}



-(BOOL)needHandleLoginExp:(NSDictionary *)respondDict{
    
    int result_code = [[respondDict objectForKey:NET_KEY_RESULT] intValue];
    if (result_code == 1006) {
        NSString *logedId = [ZAPP.myuser getUserID];
        if (logedId.length < 1) {
            return NO;
        }
        [ZAPP loginout];
        
        NSString *errorMsg = respondDict[@"msg"];
        NSLog(@"%@", errorMsg);
        
        if ([errorMsg isKindOfClass:[NSString class]] && errorMsg.length > 0) {
            CustomReloginAlertView *alertView = [[CustomReloginAlertView alloc] initWithMessage:errorMsg closeDelegate:nil buttonTitles:@[@"确定"]];
            alertView.tag = 0;
            [alertView show];
            [alertView formatAlertButton];
        }
        
        return YES;
    }

    return NO;
}

- (void)responseSucWithCount:(int)count responseDict:(NSDictionary *)respondDict{
 
    
    NSInteger respCount = [[respondDict objectForKey:NET_KEY_SUCCESSCOUNT] integerValue];
    if (respCount == count && [[respondDict objectForKey:NET_KEY_RESPS] count] == count && [[respondDict objectForKey:NET_KEY_FAILCOUNT] integerValue] == 0) {
        for (int i = 0; i < count; i++) {
            NSDictionary *resp = [[respondDict objectForKey:NET_KEY_RESPS] objectAtIndex:i];
            if ([[resp objectForKey:NET_KEY_RESULT] integerValue] != NET_RESULT_CODE_SUC) {
                _succ = NO;
                return;
            }
        }
        _succ = YES;
    }
    else {
        _succ = NO;
        
        _errMsg = [[respondDict objectForKey:NET_KEY_MSG] copy];
 
        NSArray *resps = [respondDict objectForKey:NET_KEY_RESPS];
        if ([resps isKindOfClass:[NSArray class]] && resps.count > 0) {
            NSInteger respsCount = resps.count;
            for (int i = 0; i < respsCount; i++) {
                NSDictionary *resp = [[respondDict objectForKey:NET_KEY_RESPS] objectAtIndex:i];
                if ([[resp objectForKey:NET_KEY_RESULT] integerValue] != NET_RESULT_CODE_SUC) {
                    NSString *ths = [resp objectForKey:NET_KEY_MSG];
                    _errMsg = [ths copy];
//                    if ([ths notEmpty]) {
//                        [Util toast:ths];
//                    }
                }
            }
        }
    }
//    return suc;
}



@end
