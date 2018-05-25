//
//  shareManager.h
//  YQS
//
//  Created by a on 16/2/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedTrigger [[shareManager sharedManager] trigger];

@interface shareManager : NSObject

+ (shareManager *)sharedManager;
- (void)trigger ;

@end
