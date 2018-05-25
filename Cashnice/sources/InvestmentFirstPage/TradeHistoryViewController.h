//
//  TradeHistoryViewController.h
//  Cashnice
//
//  Created by a on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CustomViewController.h"



typedef enum : NSUInteger {
    FriendsTradeHistory = 1,
    OuterFriendsTradeHistory = 2,
} TradeHistoryType;


@interface TradeHistoryViewController : CustomViewController

@property (nonatomic, assign) TradeHistoryType tradeHistoryType;

@end
