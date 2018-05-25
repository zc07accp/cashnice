//
//  updateManager.m
//  Cashnice
//
//  Created by a on 16/10/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "UpdateManager.h"
#import "CustomUpdateAlertView.h"

@implementation UpdateManager

+ (void)check{
    [ZAPP.netEngine checkUpdateInfo:^{
        if (isIgnored) {
            return ;
        }
        NSDictionary *updateInfo = ZAPP.myuser.versionUpdateInfoDict;
        BOOL isupdate = [updateInfo[@"isupdate"] boolValue];
        if (isupdate) {
            CustomUpdateAlertView *updateAlert = [[CustomUpdateAlertView alloc]initWithUpdateInfo:updateInfo];
            [updateAlert show];
        }
    } error:^{
        ;
    }];
}

+ (void)checkUpdateAndShare{
    if (isIgnored) {
        SharedTrigger
        return ;
    }
    [ZAPP.netEngine checkUpdateInfo:^{
        NSDictionary *updateInfo = ZAPP.myuser.versionUpdateInfoDict;
        BOOL isupdate = [updateInfo[@"isupdate"] boolValue];
        if (isupdate) {
            CustomUpdateAlertView *updateAlert = [[CustomUpdateAlertView alloc]initWithUpdateInfo:updateInfo];
            [updateAlert show];
        }else{
            SharedTrigger;
        }
    } error:^{
        SharedTrigger;
    }];
}

+ (void)ignoreOnce {
    isIgnored = YES;
}

@end
