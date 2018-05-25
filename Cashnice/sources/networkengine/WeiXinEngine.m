//
//  WeiXinEngine.m
//  YQS
//
//  Created by l on 3/15/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "WeiXinEngine.h"

@implementation WeiXinEngine

- (void)generalCompleteBlock:(MKNetworkOperation *)completedOperation {
	//[UtilLog string:[completedOperation isCachedResponse] ? @"cached" : @"server"];
	//[UtilLog dict:[completedOperation responseJSON]];
}


- (void)userInfoComplete:(MKNetworkOperation *)completeOperation {
	[ZAPP.zlogin setTheAccessTokenDict:[completeOperation responseJSON]];
}

- (MKNetworkOperation *)accessToken:(NSString *)code compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:WEIXIN_APP_ID forKey:WEIXIN_KEY_APPID];
	[dict setObject:WEIXIN_SECRET forKey:WEIXIN_KEY_SECRET];
	[dict setObject:code forKey:WEIXIN_KEY_CODE];
	[dict setObject:WEIXIN_KEY_AUTHORIZATION_CODE forKey:WEIXIN_KEY_GRANT_TYPE];
	MKNetworkOperation *op = [self operationWithPath:WEIXIN_API_ACCESS_TOKEN params:dict httpMethod:@"GET" ssl:YES];
	[op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
	         [self generalCompleteBlock:completedOperation];
	         [ZAPP.zlogin setTheAccessTokenDict:[completedOperation responseJSON]];
	         if (ZNOTNULL(completionBlock)) {
	                 completionBlock();
		 }
	 } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
	         if (ZNOTNULL(errorBlock)) {
	                 errorBlock();
		 }
	 }];

	[self enqueueOperation:op];

	return op;
}

- (MKNetworkOperation *)refreshTokenWithCompeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:WEIXIN_APP_ID forKey:WEIXIN_KEY_APPID];
	[dict setObject:[ZAPP.zlogin getWeixinRefreshToken] forKey:WEIXIN_KEY_REFRESH_TOKEN];
	[dict setObject:WEIXIN_KEY_REFRESH_TOKEN forKey:WEIXIN_KEY_GRANT_TYPE];
	MKNetworkOperation *op = [self operationWithPath:WEIXIN_API_REFRESH_TOKEN params:dict httpMethod:@"GET" ssl:YES];
	[op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
	         [self generalCompleteBlock:completedOperation];
	         NSDictionary *dict = [completedOperation responseJSON];
	         NSString *str = [dict objectForKey:WEIXIN_API_REFRESH_TOKEN];
	         if ([str notEmpty]) {
	                 [ZAPP.zlogin setTheAccessTokenDict:dict];
		 }
	         else {
	                 [ZAPP.zlogin setTheTokenExpired:YES];
		 }
	         if (ZNOTNULL(completionBlock)) {
	                 completionBlock();
		 }
	 } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
	         if (ZNOTNULL(errorBlock)) {
	                 errorBlock();
		 }
	 }];

	[self enqueueOperation:op];

	return op;
}

- (MKNetworkOperation *)checkTokenWithCompeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[ZAPP.zlogin getAccessToken] forKey:WEIXIN_KEY_ACCESS_TOKEN];
	[dict setObject:[ZAPP.zlogin getOpenID] forKey:WEIXIN_KEY_OPENID];
	MKNetworkOperation *op = [self operationWithPath:WEIXIN_API_CHECK_TOKEN params:dict httpMethod:@"GET" ssl:YES];
	[op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
	         [self generalCompleteBlock:completedOperation];
	         if (ZNOTNULL(completionBlock)) {
	                 completionBlock();
		 }
	 } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
	         if (ZNOTNULL(errorBlock)) {
	                 errorBlock();
		 }
	 }];

	[self enqueueOperation:op];

	return op;
}

- (MKNetworkOperation *)getInfoWithCompeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	[dict setObject:[ZAPP.zlogin getAccessToken] forKey:WEIXIN_KEY_ACCESS_TOKEN];
	[dict setObject:[ZAPP.zlogin getOpenID] forKey:WEIXIN_KEY_OPENID];
	MKNetworkOperation *op = [self operationWithPath:WEIXIN_API_USER_INFO params:dict httpMethod:@"GET" ssl:YES];
	[op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
	         [self generalCompleteBlock:completedOperation];
	         [ZAPP.zlogin setTheUserDataDict:[completedOperation responseJSON]];
	         if (ZNOTNULL(completionBlock)) {
	                 completionBlock();
		 }
	 } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
	         if (ZNOTNULL(errorBlock)) {
	                 errorBlock();
		 }
	 }];

	[self enqueueOperation:op];

	return op;
}
@end
