//
//  updateManager.h
//  Cashnice
//
//  Created by a on 16/10/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UpdateTrigger           [UpdateManager check];
#define UpdateAndSharedTrigger  [UpdateManager checkUpdateAndShare];

static bool isIgnored = NO;

@interface UpdateManager : NSObject

+ (void)ignoreOnce;
+ (void)check;
+ (void)checkUpdateAndShare;

@end
