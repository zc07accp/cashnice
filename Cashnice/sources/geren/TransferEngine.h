//
//  TransferEngine.h
//  Cashnice
//
//  Created by a on 16/10/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface TransferEngine : CNNetworkEngine

-(void)getTransferHistoryListWithUserId:(NSString *)userId
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                                success:(void (^)(NSArray *historyItems, BOOL isLastPage, NSInteger totalcount))success
                                failure:(void (^)(NSString *error))failure;

-(void)getTransferDataWithpage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(void (^)(NSArray *dataItems, BOOL isLastPage))success
                       failure:(void (^)(NSString *error))failure;
@end
