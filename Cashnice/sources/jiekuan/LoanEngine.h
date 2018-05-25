//
//  LoanEngine.h
//  Cashnice
//
//  Created by apple on 2016/11/10.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"

@interface LoanEngine : CNNetworkEngine


-(void)getLoanInvesHistoryList:(NSInteger)loanId
                      pageSize:(NSInteger)pageSize
                       pagenum:(NSInteger)num
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSString *error))failure;
    
-(void)getLoanList:(NSInteger)page
          pageSize:(NSInteger)pageSize
           success:(void (^)(NSDictionary *))success
           failure:(void (^)(NSString *error))failure;


-(NSDictionary *)readlocalData;
-(void)clearLocalData;


@end
