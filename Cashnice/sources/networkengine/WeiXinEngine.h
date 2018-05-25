//
//  WeiXinEngine.h
//  YQS
//
//  Created by l on 3/15/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface WeiXinEngine : MKNetworkEngine 

- (MKNetworkOperation *)accessToken:(NSString *)code compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;
//- (MKNetworkOperation *)refreshTokenWithCompeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)checkTokenWithCompeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;
- (MKNetworkOperation *)getInfoWithCompeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock;

@end
