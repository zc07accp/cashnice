//
//  NoticeManager.m
//  YQS
//
//  Created by l on 4/20/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NoticeManager.h"

@interface NoticeManager ()

@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSDictionary *dataDict;//新消息数目的返回数据
@property (nonatomic, strong) NSTimer *ntfTimer;
@property (nonatomic, strong) NSDate *lastTixingDate;//上一次成功获取通知列表的时间

@end

@implementation NoticeManager

- (void)setTheDataDict:(NSDictionary *)dict {
	self.dataDict = dict;
}

- (NSDate *)lastTixingDate {
    
//	if (_lastTixingDate == nil) {
		_lastTixingDate = [[NSUserDefaults standardUserDefaults] objectForKey:def_key_tixing_update_date];
		if (_lastTixingDate == nil) {
			/**
			 *  设置为30天前
			 */
			_lastTixingDate = [NSDate dateWithTimeInterval:-3600*24*30 sinceDate:[NSDate date]];
		}
//	}
	return _lastTixingDate;
}

- (void)load {
    [self lastTixingDate];
//    [self startTimer];
    [self connectToGetNtfNum];

}

- (void)startTimer {
	[self stopTimer];
	self.ntfTimer = [NSTimer scheduledTimerWithTimeInterval:30*2 target:self selector:@selector(connectToGetNtfNum) userInfo:nil repeats:YES];
	[self connectToGetNtfNum];
}

- (void)stopTimer {
    
    if(self.ntfTimer){
        [self.ntfTimer invalidate];
        self.ntfTimer = nil;
    }
}

- (void)clearNtfNum {
	self.dataDict = nil;
	//_lastTixingDate = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:def_key_tixing_update_date];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[ZAPP updateNavBarRightItems];
}

- (int)getNtfNum {
	@try {
		return [[self.dataDict objectForKey:NET_KEY_newnoticecount ] intValue];
	}
	@catch (NSException *exception) {
	}
	@finally {
	}
	return 0;
}

- (void)connectToGetNtfNum {
	bugeili_net_new
	[self.op cancel];
    if ([ZAPP.zlogin isLogined]) {
        self.op = [ZAPP.netEngine getRemindNumWithComplete:^{ [ZAPP updateNavBarRightItems]; } error:nil date:self.lastTixingDate];
    }
}

@end
