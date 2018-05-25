//
//  shareManager.m
//  YQS
//
//  Created by a on 16/2/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "shareManager.h"
#import "ShareView.h"

@interface shareManager ()

@property(nonatomic, strong)ShareView *shareView;

@end

@implementation shareManager

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dispatch{
    NSDictionary *shareDict = ZAPP.myuser.shareInfoDict;
    if (shareDict) {
        NSInteger type = [shareDict[@"displayType"] integerValue]; //0：普通 1：新春
        NSInteger trigger = [shareDict[@"isTrigger"] integerValue];// 0：不弹 1：弹窗
        if ( trigger) {
            NSInteger triggerId = [shareDict[@"triggerId"] integerValue];
            ZAPP.sharedTriggerId = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:triggerId]];
            if (type) {
                self.shareView.newYearStyle = YES;
            }
            [self.shareView showInView:nil];
        }
    }
}

- (void)trigger {
    WS(ws);

    [ZAPP.netEngine getShareTriggerWithComplete:^{
        [ws dispatch];
    } error:^{
        ;
    }];
}

+ (shareManager *)sharedManager
{
    static shareManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (ShareView *)shareView{
    if (! _shareView) {
        _shareView = [[ShareView alloc]init];
    }
    return _shareView;
}

@end
