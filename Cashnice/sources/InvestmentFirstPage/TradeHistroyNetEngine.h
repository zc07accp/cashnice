//
//  TradeHistroyNetEngine.h
//  Cashnice
//
//  Created by a on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface TradeHistroyNetEngine : CNNetworkEngine

//获取交易记录
- (void)historyList:(NSInteger)queryType
            pageNum:(NSInteger)pageNum
           pageSize:(NSInteger)pagSize
            success:(void (^)(NSDictionary *contentArray))success
            failure:(void (^)(NSString *))failure;



@end
