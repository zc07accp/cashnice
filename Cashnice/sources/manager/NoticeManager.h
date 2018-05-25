//
//  NoticeManager.h
//  YQS
//
//  Created by l on 4/20/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeManager : NSObject

@property (strong, nonatomic) NSDictionary *noticeListDict;

- (void)load;
- (void)startTimer;
- (void)stopTimer;

- (int)getNtfNum;
- (void)clearNtfNum;

/**
 *  新消息数目的返回数据
 */
- (void)setTheDataDict:(NSDictionary *)dict;

@end
