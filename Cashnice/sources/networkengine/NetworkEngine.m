
//
//  NetworkEngine.m
//  YQS
//
//  Created by l on 3/13/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NetworkEngine.h"
#import "UMessage.h"
#import "NoticeManager.h"
#import "CustomReloginAlertView.h"
#import <sys/utsname.h>
#import <Bugly/Bugly.h>
#import <PINCache.h>
#import "RealReachability.h"

@implementation NetworkEngine

#pragma mark - private api

#define NEW_MYBLOCK_MK_OP(__A__) NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion :[ZAPP.zlogin getRefreshToken] uid :[ZAPP.myuser getUserIDInt] namesArr : nameArray parasArr : paraArray versionArr : versionArray]; \
	return [self sendRequest : jsonStr compeletionHandler :^{ \
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]]; \
	                if (suc) {__A__} \
	                [self exeResult:suc complete:compelteBlock error:errorBlock]; \
		} errorHandler : errorBlock];



- (NSString *)jsonDictionaryWithSessionkey:(NSString *)sessionkey uid:(int)uid namesArr:(NSArray *)namesArr parasArr:(NSArray *)parasArr {
	NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
	[jsonDict setObject:[NSNumber numberWithInteger:[namesArr count]] forKey:NET_KEY_COUNT];
	[jsonDict setObject:sessionkey forKey:NET_KEY_SESSIONKEY];
    [jsonDict setObject:[Util appVersion] forKey:NET_KEY_VERSIONKEY];
    [jsonDict setObject:[self getDeviceMode] forKey:NET_KEY_MODEL];
    [jsonDict setObject:[self getDeviceSystem] forKey:NET_KEY_SYSTEM];
	if (uid == -1) {
		[jsonDict setObject:@"" forKey:NET_KEY_UID];
	}
	else {
		[jsonDict setObject:@(uid) forKey:NET_KEY_UID];

	}
	[jsonDict setObject:NET_VALUE_SOURCE forKey:NET_KEY_SOURCE];
	NSMutableArray *reqArray = [NSMutableArray array];
	for (NSInteger i = 0; i < [namesArr count]; i++) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setObject:NET_VALUE_SERVER_VERSION forKey:NET_KEY_VERSION];
		[dict setObject:[parasArr objectAtIndex:i] forKey:NET_KEY_PARAMS];
		[dict setObject:[namesArr objectAtIndex:i] forKey:NET_KEY_NAME];
		[reqArray addObject:dict];
	}
	[jsonDict setObject:reqArray forKey:NET_KEY_REQS];
	return [jsonDict jsonEncodedKeyValueString];
}

- (NSString *)jsonDictionaryWithSessionkeyAndVersion:(NSString *)sessionkey uid:(int)uid namesArr:(NSArray *)namesArr parasArr:(NSArray *)parasArr versionArr:(NSArray *)verArr {
	NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
	[jsonDict setObject:[NSNumber numberWithInteger:[namesArr count]] forKey:NET_KEY_COUNT];
	[jsonDict setObject:sessionkey forKey:NET_KEY_SESSIONKEY];
    [jsonDict setObject:[Util appVersion] forKey:NET_KEY_VERSIONKEY];
    [jsonDict setObject:[self getDeviceMode] forKey:NET_KEY_MODEL];
    [jsonDict setObject:[self getDeviceSystem] forKey:NET_KEY_SYSTEM];
	if (uid == -1) {
		[jsonDict setObject:@"" forKey:NET_KEY_UID];
	}
	else {
		[jsonDict setObject:@(uid) forKey:NET_KEY_UID];

	}
	[jsonDict setObject:NET_VALUE_SOURCE forKey:NET_KEY_SOURCE];
	NSMutableArray *reqArray = [NSMutableArray array];
	for (NSInteger i = 0; i < [namesArr count]; i++) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setObject:[verArr objectAtIndex:i] forKey:NET_KEY_VERSION];
        if (parasArr) {
            [dict setObject:[parasArr objectAtIndex:i] forKey:NET_KEY_PARAMS];
        }
		[dict setObject:[namesArr objectAtIndex:i] forKey:NET_KEY_NAME];
		[reqArray addObject:dict];
	}
	[jsonDict setObject:reqArray forKey:NET_KEY_REQS];
	return [jsonDict jsonEncodedKeyValueString];
}

- (void)generalCompleteBlock:(MKNetworkOperation *)completedOperation {
	respondDict = [completedOperation responseJSON];
#ifdef TEST_ENABLE_SERVER_LOG
	[UtilLog dict:respondDict];
#endif
}

- (NSString *)getDeviceMode {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machine = [NSString stringWithCString:systemInfo.machine
                                           encoding:NSUTF8StringEncoding];
    
    return machine ;//[[UIDevice currentDevice]model];
}

- (NSString *)getDeviceSystem {
    return [NSString stringWithFormat:@"%@,%@",[[UIDevice currentDevice]systemName], [[UIDevice currentDevice]systemVersion]];
}

- (void)generalErrorBlock:(MKNetworkOperation *)errorOperation error:(NSError *)error{
    /*
    if ([error code] == -1001) {
        [Util toastStringOfLocalizedKey:@"tip.connectionToServerTimedOut"];
    }
    */
}


-(BOOL)needCacheHandle:(NSString *)jsonString{
    
    // 不需要缓存
    if ( [jsonString mycontainsString:@"transfer.constraint.check.get"]     ||
         [jsonString mycontainsString:@"user.bill.list.get"]                ||
         [jsonString mycontainsString:NET_FUNC_LOAN_WARRANTY_LIST_GET]      ||
         [jsonString mycontainsString:@"system.appupdate.check.get"]        ||
         [jsonString mycontainsString:@"system.configure.info.get"]         ||
         [jsonString mycontainsString:@"user.red"]                          ||
         [jsonString mycontainsString:@"user.profile.info.get"]             ||
         [jsonString mycontainsString:@"notice.update.remind.get"]          ||
        [jsonString mycontainsString:@"loan.order.calcvals.get"] ){
        return NO;
    
    }

    return YES;
}


-(NSString *)cacheKey:(NSString *)jsonString{
    
    NSString *key = @"";
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *reqArr = dict[@"reqs"];
    for (NSDictionary *req in reqArr) {
        NSString *name = req[@"name"];
        key = [key stringByAppendingString:name];
        
        NSDictionary *params = req[@"params"];
        for (NSString *pKey in params.allKeys) {
            key = [key stringByAppendingString:[NSString stringWithFormat:@"%@.%@", pKey, params[pKey]]];
        }
    }
    if (dict[@"uid"]) {
        NSInteger uid = [dict[@"uid"] integerValue];
        key = [key stringByAppendingString:[NSString stringWithFormat:@"%ld", uid]];
    }

    return key;
}


-(void)getCacheIfExisted:(NSString *)jsonString complete:(void (^)(id obj))complete{
    
    NSString *key = [self cacheKey:jsonString];
 
    //get Cache
    [[PINCache sharedCache] objectForKey:key
                                  block:^(PINCache *cache, NSString *key, id object) {
                                      complete(object);
        }
        
    ];
    
 }

-(NSArray *)requestArr:(NSString *)jsonString{
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *reqArr = dict[@"reqs"];
    return reqArr;
}


- (MKNetworkOperation *)sendGet:(NSString *)jsonString compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
//    DLog()
    
	MKNetworkOperation *op = [self operationWithPath:YQS_API_GET(jsonString) params:nil httpMethod:@"GET" ssl:USESSL];
    
    __weak NetworkEngine      *weakSelf = self;

    //error handle block
    MKNKResponseErrorBlock  responseErrorBlock = ^(MKNetworkOperation* completedOperation, NSError* error){
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        //[strongSelf generalErrorBlock:completedOperation error:error];
        
        [Util noticeServiceError];
        if (ZNOTNULL(errorBlock)) {
            [strongSelf performSelectorOnMainThread:@selector(callBlock:) withObject:errorBlock waitUntilDone:YES];
        
        }
    };
    
    // 不需要缓存
    if (NetworkOperationCacheDisable || ![self needCacheHandle:jsonString])
    {

        
        MKNKResponseBlock responseBlock = ^(MKNetworkOperation* completedOperation){
            __strong __typeof(self) strongSelf = weakSelf;

            [strongSelf generalCompleteBlock:completedOperation];
            
            if (respondDict && ZNOTNULL(completionBlock)) {
                [strongSelf performSelectorOnMainThread:@selector(callBlock:) withObject:completionBlock waitUntilDone:YES];
            }else{
                
                [Util noticeServiceError];
                if (ZNOTNULL(errorBlock)) {
                    [strongSelf performSelectorOnMainThread:@selector(callBlock:) withObject:errorBlock waitUntilDone:YES];
                }

            }
        };
        
        [op addHeaders:[NSDictionary dictionaryWithObject:@"gzip" forKey: @"Accept-Encoding"]];
        [op addCompletionHandler:responseBlock
                    errorHandler:responseErrorBlock];
        [self enqueueOperation:op];
    }
    else{
        //Cache!!
        
        NSArray *reqArr = [self requestArr:jsonString];
        
        __weak NetworkEngine      *weakSelf = self;
        
        NSString *key = [self cacheKey:jsonString];
        [self getCacheIfExisted:jsonString complete:^(id cacheObject) {
        
            //cache existed
            if (cacheObject) {
                NSDictionary *cachedData = (NSDictionary *)cacheObject;
                if (cachedData) {
                    if (ZNOTNULL(completionBlock)) {
                        respondDict = cachedData;
                        //completionBlock();
                        [self performSelectorOnMainThread:@selector(callBlock:) withObject:completionBlock waitUntilDone:YES];
                    }
                }
            }
            
            [op addHeaders:[NSDictionary dictionaryWithObject:@"gzip" forKey: @"Accept-Encoding"]];
            [op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
                [weakSelf generalCompleteBlock:completedOperation];
                if (! respondDict) {
                    if ([UtilDevice isNetworkConnected]) {
                        [Util dispatch:MSG_system_service_updating];
                    }
                    [Util noticeServiceError];
                    if (ZNOTNULL(errorBlock) && !cacheObject) {
                        [self performSelectorOnMainThread:@selector(callBlock:) withObject:errorBlock waitUntilDone:YES];
                    }
                
                    return ;
                }
                if (ZNOTNULL(completionBlock)) {
                    BOOL suc = [self responseSucWithCount:(int)[reqArr count]];
                    if (suc) {
                        if (!self.closeAutoCache) {
                            /// Set Cache
                            [[PINCache sharedCache]setObject:respondDict forKey:key];
                        }
                    }
                    [self performSelectorOnMainThread:@selector(callBlock:) withObject:completionBlock waitUntilDone:YES];
                }
            }
             
                        errorHandler: responseErrorBlock];
            [weakSelf enqueueOperation:op];
        }];
        
        
        
        
        

//        //get Cache
//        [[TMCache sharedCache] objectForKey:key block:^(TMCache *cache, NSString *key, id cacheObject) {
//            if (cacheObject) {
//                NSDictionary *cachedData = (NSDictionary *)cacheObject;
//                if (cachedData) {
//                    if (ZNOTNULL(completionBlock)) {
//                        respondDict = cachedData;
//                        //completionBlock();
//                        [self performSelectorOnMainThread:@selector(callBlock:) withObject:completionBlock waitUntilDone:YES];
//                    }
//                }
//                /////////////////////////////////////////////////////////////////////////////
//                [op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
//                    [weakSelf generalCompleteBlock:completedOperation];
//                    if (respondDict) {
//                        if (ZNOTNULL(completionBlock)) {
//                            BOOL                                                                  suc = [self responseSucWithCount:(int)[reqArr count]];
//                            if (suc) {
//                                
//                                if (!self.closeAutoCache) {
//                                    /// Set Cache
//                                    [[TMCache sharedCache]setObject:respondDict forKey:key];
//                                }
//
//                            }
//                            // 再刷新UI
//                            [self performSelectorOnMainThread:@selector(callBlock:) withObject:completionBlock waitUntilDone:YES];
//                        }
//                    }
//                    
//                } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//                    ;
//                }];
//                [weakSelf enqueueOperation:op];
//                /////////////////////////////////////////////////////////////////////////////
//            }
//            else{
//            /////////////////////////////////////////////////////////////////////////////
//            [op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
//                [weakSelf generalCompleteBlock:completedOperation];
//                if (! respondDict) {
//                    [Util toast:net_error_msg];
//                    if (ZNOTNULL(errorBlock) && !cacheObject) {
//                        [self performSelectorOnMainThread:@selector(callBlock:) withObject:errorBlock waitUntilDone:YES];
//                    }
//                }
//                if (ZNOTNULL(completionBlock)) {
//                    BOOL suc = [self responseSucWithCount:(int)[reqArr count]];
//                    if (suc) {
//                        if (!self.closeAutoCache) {
//                        /// Set Cache
//                        [[TMCache sharedCache]setObject:respondDict forKey:key];
//                        }
//                    }
//                    [self performSelectorOnMainThread:@selector(callBlock:) withObject:completionBlock waitUntilDone:YES];
//                }
//            } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
//                [weakSelf generalErrorBlock:errorOp error:error];
//                [Util toast:net_error_msg];
//                if (ZNOTNULL(errorBlock) && !cacheObject) {
//                    [self performSelectorOnMainThread:@selector(callBlock:) withObject:errorBlock waitUntilDone:YES];
//                }
//            }];
//                [weakSelf enqueueOperation:op];
//            }
//        }];
        
    }
    
	return op;
}

- (void)callBlock:(NetResponseBlock)completionBlock {
    completionBlock();
}

- (MKNetworkOperation *)sendPost:(NSString *)jsonString compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
	MKNetworkOperation *op = [self operationWithPath:YQS_API_POST_PATH params:YQS_API_POST_BODY(jsonString) httpMethod:@"POST" ssl:USESSL];
	[op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
	         [self generalCompleteBlock:completedOperation];
        if (! respondDict) {
            if ([UtilDevice isNetworkConnected]) {
                [Util dispatch:MSG_system_service_updating];
            }
            [Util noticeServiceError];
            if (ZNOTNULL(errorBlock)) {
                errorBlock();
            }
        }
        if (ZNOTNULL(completionBlock)) {
             completionBlock();
        }
	 } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
         [self generalErrorBlock:errorOp error:error];
	         if (ZNOTNULL(errorBlock)) {
                 if ([UtilDevice isNetworkConnected]) {
                     [Util dispatch:MSG_system_service_updating];
                 }
                 [Util noticeServiceError];
	                 errorBlock();
		 }
	 }];

	[self enqueueOperation:op];

	return op;
}

- (MKNetworkOperation *)sendRequest:(NSString *)jsonString compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    [UtilLog string:YQS_SERVER_URL];
	if ([jsonString mycontainsString:@".post"]) {
        [UtilLog string:jsonString tag:@"POST"];
		return [self sendPost:jsonString compeletionHandler:completionBlock errorHandler:errorBlock];
	}
	else if ([jsonString mycontainsString:@".get"]) {
        [UtilLog string:jsonString tag:@"GET"];
		return [self sendGet:jsonString compeletionHandler:completionBlock errorHandler:errorBlock];
	}
	return nil;
}

- (void)exeResult:(BOOL)suc complete:(NetResponseBlock)com error:(NetErrorBlock)err {
	if (suc) {
		if (ZNOTNULL(com)) {
			com();
		}
	}
	else {
		if (ZNOTNULL(err)) {
			err();
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [ZAPP loginout];
}


- (BOOL)responseSucWithCount:(int)count exception:(BOOL)exception {
    BOOL suc = NO;
    NSInteger successCount = [[respondDict objectForKey:NET_KEY_SUCCESSCOUNT] integerValue];
    if (successCount == count && [[respondDict objectForKey:NET_KEY_RESPS] count] == count && [[respondDict objectForKey:NET_KEY_FAILCOUNT] integerValue] == 0) {
        for (int i = 0; i < count; i++) {
            NSDictionary *resp = [[respondDict objectForKey:NET_KEY_RESPS] objectAtIndex:i];
            if ([[resp objectForKey:NET_KEY_RESULT] integerValue] != NET_RESULT_CODE_SUC) {
                return NO;
            }
        }
        [Util noticeServiceRecoveryMessage];
        suc = YES;
    }
    else {
        int result_code = [[respondDict objectForKey:NET_KEY_RESULT] intValue];
        //系统维护
        if (result_code == 1020) {
            [Util noticeServiceErrorWithMessage:[self getMsgFromResp]];
            return NO;
        }
        if (result_code == 1006) {
            [ZAPP loginout];
            
            NSString *errorMsg = respondDict[@"msg"];
            if ([errorMsg isKindOfClass:[NSString class]] && errorMsg.length > 0) {
                CustomReloginAlertView *alertView = [[CustomReloginAlertView alloc] initWithMessage:errorMsg closeDelegate:nil buttonTitles:@[@"确定"]];
                alertView.tag = 0;
                [alertView show];
                [alertView formatAlertButton];
            }
            //[Util toast:@"您已经在别处登录"];
            return NO;
        }
        NSString *msg = [respondDict objectForKey:NET_KEY_MSG];
        if ([msg notEmpty] && exception) {
            [Util toast:msg];
        }
        
        NSArray *resps = [respondDict objectForKey:NET_KEY_RESPS];
        if ([resps isKindOfClass:[NSArray class]] && resps.count > 0) {
            NSInteger respsCount = resps.count;
            for (int i = 0; i < respsCount; i++) {
                NSDictionary *resp = [[respondDict objectForKey:NET_KEY_RESPS] objectAtIndex:i];
                if ([[resp objectForKey:NET_KEY_RESULT] integerValue] != NET_RESULT_CODE_SUC) {
                    NSString *ths = [resp objectForKey:NET_KEY_MSG];
                    if ([ths notEmpty] && exception) {
                        [Util toast:ths];
                    }
                }
            }
        }
    }
    return suc;
}

- (BOOL)responseSucWithCount:(int)count {
	BOOL suc = NO;
    NSInteger respCount = [[respondDict objectForKey:NET_KEY_SUCCESSCOUNT] integerValue];
	if (respCount == count && [[respondDict objectForKey:NET_KEY_RESPS] count] == count && [[respondDict objectForKey:NET_KEY_FAILCOUNT] integerValue] == 0) {
		for (int i = 0; i < count; i++) {
			NSDictionary *resp = [[respondDict objectForKey:NET_KEY_RESPS] objectAtIndex:i];
			if ([[resp objectForKey:NET_KEY_RESULT] integerValue] != NET_RESULT_CODE_SUC) {
				return NO;
			}
		}
        [Util noticeServiceRecoveryMessage];
		suc = YES;
	}
	else {
		int result_code = [[respondDict objectForKey:NET_KEY_RESULT] intValue];
        //系统维护
        if (result_code == 1020) {
            [Util noticeServiceErrorWithMessage:[self getMsgFromResp]];
            return NO;
        }
		if (result_code == 1006) {
            NSString *logedId = [ZAPP.myuser getUserID];
            if (logedId.length < 1) {
                return NO;
            }
            [ZAPP loginout];
            
            NSString *errorMsg = respondDict[@"msg"];
            if ([errorMsg isKindOfClass:[NSString class]] && errorMsg.length > 0) {
                CustomReloginAlertView *alertView = [[CustomReloginAlertView alloc] initWithMessage:errorMsg closeDelegate:nil buttonTitles:@[@"确定"]];
                alertView.tag = 0;
                [alertView show];
                [alertView formatAlertButton];
            }
//            [Util toast:@"您已经在别处登录"];
			return NO;
		}
		NSString *msg = [respondDict objectForKey:NET_KEY_MSG];
		if ([msg notEmpty]) {
			[Util toast:msg];
		}
        if ([[self getMsgFromResp] notEmpty]) {
            [Util toast:[self getMsgFromResp]];
        }
	}
	return suc;
}

- (NSString *)getMsgFromResp{
    NSString *result = nil;
    NSArray *resps = [respondDict objectForKey:NET_KEY_RESPS];
    if ([resps isKindOfClass:[NSArray class]] && resps.count > 0) {
        NSInteger respsCount = resps.count;
        for (int i = 0; i < respsCount; i++) {
            NSDictionary *resp = [[respondDict objectForKey:NET_KEY_RESPS] objectAtIndex:i];
            if ([[resp objectForKey:NET_KEY_RESULT] integerValue] != NET_RESULT_CODE_SUC) {
                NSString *ths = [resp objectForKey:NET_KEY_MSG];
                if([ths length]){
                    result = [[NSString alloc] initWithString:ths];
                }
                
            }
        }
    }
    return result;
}

- (NSDictionary *)getDictWithIndex:(int)index {
	NSArray *     arr = [respondDict objectForKey:NET_KEY_RESPS];
	NSDictionary *rDict;
	if (index < [arr count] && index >= 0) {
		NSDictionary *resp = [arr objectAtIndex:index];
		rDict = [resp objectForKey:NET_KEY_RESP];
	}
	return rDict;
}

#pragma mark - operations

#define CHECK_PARA_STRING(_AA_) if ([_AA_ notEmpty]) {\
}\
else {\
    _AA_ = @"";\
}

// 登录 3.0
- (MKNetworkOperation *)newloginToServerByPhone:(NSString *)phone regionCode:(NSInteger)regionCode validationCode:(NSString *)validationCode validationUUID:(NSString *)validationUUID  complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(phone)
	NSDictionary *para = @{
		NET_KEY_ACTIONTYPE:@"1",
        NET_KEY_phoneaccountinfo : @{NET_KEY_PHONE:phone},
        @"validatecodeinfo" : @{@"device" : phone,
                                @"validatecode" : validationCode,
                                @"validateuuid" : validationUUID},
        @"international" : @(regionCode)
	};

	NSArray *nameArray    = @[NET_FUNC_SYSTEM_AUTHENTICATION_USER_POST];
	NSArray *paraArray    = @[para];
	NSArray *versionArray = @[@"3.0"];

	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:nameArray parasArr:paraArray versionArr:versionArray];
	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        [ZAPP.zlogin setTheLoginRespondDataDict:[self getDictWithIndex:0]];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:errorBlock];
}
// 登录 用于测试
- (MKNetworkOperation *)newloginToServerByPhone4Test:(NSString *)phone regionCode:(NSInteger)regionCode complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(phone)
    NSDictionary *para = @{
                           NET_KEY_ACTIONTYPE:@"1",
                           NET_KEY_phoneaccountinfo : @{NET_KEY_PHONE:phone},
                           @"international" : @(regionCode)
                           };
    
    NSArray *nameArray    = @[NET_FUNC_SYSTEM_AUTHENTICATION_USER_POST];
    NSArray *paraArray    = @[para];
    NSArray *versionArray = @[@"2.0"];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:nameArray parasArr:paraArray versionArr:versionArray];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            [ZAPP.zlogin setTheLoginRespondDataDict:[self getDictWithIndex:0]];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)newloginToServerByPhone:(NSString *)phone validationCode:(NSString *)validationCode validationUUID:(NSString *)validationUUID complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(phone)
    NSDictionary *para = @{
                           NET_KEY_ACTIONTYPE:@"1",
                           NET_KEY_phoneaccountinfo : @{NET_KEY_PHONE:phone},
                           @"validatecodeinfo" : @{@"device" : phone,
                                                   @"validatecode" : validationCode,
                                                   @"validateuuid" : validationUUID},
                           };
    
    NSArray *nameArray    = @[NET_FUNC_SYSTEM_AUTHENTICATION_USER_POST];
    NSArray *paraArray    = @[para];
    NSArray *versionArray = @[@"3.0"];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:nameArray parasArr:paraArray versionArr:versionArray];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            [ZAPP.zlogin setTheLoginRespondDataDict:[self getDictWithIndex:0]];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

// 获取国际化地区
- (MKNetworkOperation *)getSupportedRegionWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:@[@"system.international.list.get"] parasArr:@[@{}] versionArr:@[@"1.0"]];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)1];
        if (suc) {
            ZAPP.myuser.systemRegionArray = (NSArray *)[self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:^{
        if (errorBlock) {
            errorBlock();
        }
    }];
}

// 大额充值上传二维码内容
- (MKNetworkOperation *)postQrCode:(NSString *)code step:(NSString *)step complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    
    NSArray * nameArray = @[@"system.qrcode.item.post"];
    NSArray * paraArray = @[@{@"token" :  code,
                              @"step"   : step}];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.qrcodePostRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

// 提现算费
- (MKNetworkOperation *)getWithDrawLimit:(CGFloat)amount complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    NSArray * nameArray = @[@"user.withdraw.limit.post"];
    NSArray * paraArray = @[@{@"amount" :  @(amount),
                              @"userid" :  [ZAPP.myuser getUserID]
                            }];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.withdrawLimitRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//微信登录 微信绑定
- (MKNetworkOperation *)bindPhoneWithWeiXinAndLoginToServer:(NSString *)phone socialid:(NSString *)socialid token:(NSString *)token nickname:(NSString *)nickname headimg:(NSString *)headimg regionCode:(NSInteger)regionCode  validationCode:(NSString *)validationCode  validationUUID:(NSString *)validationUUID complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(phone)
    CHECK_PARA_STRING(socialid)
    CHECK_PARA_STRING(token)
    CHECK_PARA_STRING(nickname)
    CHECK_PARA_STRING(headimg)
	NSDictionary *para = @{
		NET_KEY_ACTIONTYPE:@"1",
		NET_KEY_socialaccountid: socialid,
		NET_KEY_ACCOUNT : phone,
		NET_KEY_TOKEN:token,
		NET_KEY_NICKNAME : nickname,
		NET_KEY_HEADIMG : headimg,
        @"international" : @(regionCode),
        @"validatecodeinfo" : @{@"device" : phone,
                                @"validatecode" : validationCode,
                                @"validateuuid" : validationUUID
                                },
	};

	NSArray *nameArray    = @[NET_FUNC_user_socialaccount_binding_POST];
	NSArray *paraArray    = @[para];
	NSArray *versionArray = @[@"3.0"];

	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:nameArray parasArr:paraArray versionArr:versionArray];
	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        [ZAPP.zlogin setTheLoginRespondDataDict:[self getDictWithIndex:0]];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:errorBlock];
}

// 微信登录
- (MKNetworkOperation *)newloginToServerByWeixinWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock regionCode:(NSInteger)regionCode{
	NSMutableDictionary *paras_weixin = [NSMutableDictionary dictionary];
	[paras_weixin setObject:[ZAPP.zlogin getUnionID] forKey:NET_KEY_OPENID];
	[paras_weixin setObject:[ZAPP.zlogin getWeixinRefreshToken] forKey:NET_KEY_TOKEN];
	[paras_weixin setObject:[ZAPP.zlogin getHeaderUrl] forKey:NET_KEY_HEADIMG];
	[paras_weixin setObject:[ZAPP.zlogin getNickName] forKey:NET_KEY_NICKNAME];

	NSDictionary *para = @{
		NET_KEY_ACTIONTYPE:@"0",
		NET_KEY_weixinaccountinfo: paras_weixin
	};

	NSArray *nameArray    = @[NET_FUNC_SYSTEM_AUTHENTICATION_USER_POST];
	NSArray *paraArray    = @[para];
	NSArray *versionArray = @[@"2.0"];

	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:nameArray parasArr:paraArray versionArr:versionArray];
	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        [ZAPP.zlogin setTheLoginRespondDataDict:[self getDictWithIndex:0]];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:errorBlock];
}



- (MKNetworkOperation *)getSystemConfigurationInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    if (NO) { //[ZAPP.myuser getUserID].length > 0
        
        NSDictionary *para = @{
                               NET_KEY_USERID : [ZAPP.myuser getUserID]
                               };
        
        NSDictionary *para2 = [self para_dict_me_USER_VISA_LIST_GET];
        NSString *version = @"2.0";
    #ifdef USER_VISA_LIST_GET_API_VER_1
        version = @"1.0";
    #endif
        
        NSArray *nameArray    = @[NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_user_visa_list_get, NET_FUNC_USER_IDENTIFY_progress_get,NET_FUNC_system_configure_info_get, NET_FUNC_system_options_list_get, @"system.international.list.get"];
        NSArray *paraArray    = @[[self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]], para2, para,@{}, @{@"optionid" : @(3)}, @{}];
        NSArray *versionArray = @[@"1.0", version, @"2.0",@"2.0", @"2.0", @"1.0"];
        
        NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:versionArray];
        return [self sendRequest:jsonStr compeletionHandler:^{
            BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
            if (suc) {
                ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:0];
                ZAPP.myuser.bankcardListRespondDict = [self getDictWithIndex:1];
                ZAPP.myuser.identifyProgressDict = [self getDictWithIndex:2];
                ZAPP.myuser.systemInfoDict = [self getDictWithIndex:3];
                ZAPP.myuser.systemOptionsDictShehuiZhiwu = [self getDictWithIndex:4];
                ZAPP.myuser.systemRegionArray = (NSArray *)[self getDictWithIndex:5];
    #ifdef TEST_TOAST_SYSTEM_PARAS
                [self logSystem];
    #endif
            }
            [self exeResult:suc complete:compelteBlock error:errorBlock];
        } errorHandler:^{
            ;
            errorBlock();
        }
                ];
        
    }else{
        NSArray *nameArray    = @[NET_FUNC_system_configure_info_get, NET_FUNC_system_options_list_get, @"system.international.list.get"];
        NSArray *paraArray    = @[@{}, @{@"optionid" : @(3)}, @{}];
        NSArray *versionArray = @[@"2.0", @"2.0", @"1.0"];
        
        NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:@"" uid:-1 namesArr:nameArray parasArr:paraArray versionArr:versionArray];
        return [self sendRequest:jsonStr compeletionHandler:^{
            BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
            if (suc) {
               
                
                ZAPP.myuser.systemInfoDict = [self getDictWithIndex:0];

                ZAPP.myuser.systemOptionsDictShehuiZhiwu = [self getDictWithIndex:1];

                ZAPP.myuser.systemRegionArray = (NSArray *)[self getDictWithIndex:2];
#ifdef TEST_TOAST_SYSTEM_PARAS
                [self logSystem];
#endif
                //UserManager *um = ZAPP.myuser;
                //id re = um.bankInfoRespondDict;
                //NSLog(@"***********=%@",re);
            }
            [self exeResult:suc complete:compelteBlock error:errorBlock];
        } errorHandler:errorBlock];
    }
}


- (void)logSystem {
	NSMutableString *str = [NSMutableString string];
	NSArray *        arr = [ZAPP.myuser.systemInfoDict objectForKey:NET_KEY_items];
	int              cnt = [[ZAPP.myuser.systemInfoDict objectForKey:NET_KEY_itemcount] intValue];
	for (int i = 0; i < cnt; i++) {
		NSString *s = [[arr objectAtIndex:i] objectForKey:NET_KEY_NAME];
		NSString *x = [[arr objectAtIndex:i] objectForKey:NET_KEY_VALUE];
		if ([s notEmpty] && [x notEmpty]) {
			[str appendFormat:@"%@ %@\n", s, x];
		}
	}
	[Util toast:str];
}

- (NSDictionary *)para_dict_USER_PROFILE_INFO_GET:(NSString *)userid {
    CHECK_PARA_STRING(userid)
	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:@(0) forKey:NET_KEY_ACTIONTYPE];
	[paras setObject:userid forKey:NET_KEY_USERID];
	return paras;
}

- (NSDictionary *)para_dict_me_USER_PROFILE_INFO_GET {
	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:@(0) forKey:NET_KEY_ACTIONTYPE];
	[paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	return paras;
}

- (NSDictionary *)para_dict_me_USER_IDENTIFY_PROGRESS_GET {
	NSDictionary *para = @{
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};
	return para;
}

- (NSDictionary *)para_dict_me_USER_VISA_LIST_GET {
    #ifdef USER_VISA_LIST_GET_API_VER_1
    return @{
             NET_KEY_USERID : [ZAPP.myuser getUserID]
             };
#else
    return @{
                            NET_KEY_USERID : [ZAPP.myuser getUserID],
                            @"sourcetype":@(0),
                            @"querytype":@(0),
                            @"statusarray": @[@(1), @(2), @(3)]
                            };
#endif
}

- (NSDictionary *)para_dict_me_USER_VISA_LIST_GET_NOCACHE {

    return @{
             NET_KEY_USERID         : [ZAPP.myuser getUserID],
             @"sourcetype"          : @(0),
             @"querytype"           : @(0),
             @"statusarray"         : @[@(1), @(2), @(3)],
             NET_KEY_cachedisabled  : @YES
             };
}

- (MKNetworkOperation *)getUserInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
	NSDictionary *para = @{
		NET_KEY_USERID : [ZAPP.myuser getUserID]
	};
    
    NSDictionary *para2 = [self para_dict_me_USER_VISA_LIST_GET];
    NSString *version = @"2.0";
#ifdef USER_VISA_LIST_GET_API_VER_1
    version = @"1.0";
#endif

	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_user_visa_list_get, NET_FUNC_USER_IDENTIFY_progress_get] parasArr:@[[self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]], para2, para] versionArr:@[@"1.0", version, @"2.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:3];
	                if (suc) {
                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:0];
                        ZAPP.myuser.bankcardListRespondDict = [self getDictWithIndex:1];
                        ZAPP.myuser.identifyProgressDict = [self getDictWithIndex:2];
                        [self addUMessageAlias];
			}
            [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:
            errorBlock
            ];
}

- (MKNetworkOperation *)getUserInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid {
    CHECK_PARA_STRING(userid)

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_USER_PROFILE_INFO_GET] parasArr:@[[self para_dict_USER_PROFILE_INFO_GET:userid]]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.personInfoDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)getLoanListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {

//    NSString *userid = [ZAPP.myuser getUserID];
    
	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:@[@(0),@(2),@(5)] forKey:NET_KEY_QUERYTYPES];
	[paras setObject:@[@(1), @(2)] forKey:NET_KEY_LOANSTATUS];
	[paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[paras setObject:@(page) forKey:NET_KEY_PAGENUM];
	[paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
//	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_LOAN_ORDER_LIST_GET] parasArr:@[[self para_dict_USER_PROFILE_INFO_GET:userid], paras] versionArr:@[@"1.0",@"2.0"]];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[ NET_FUNC_LOAN_ORDER_LIST_GET] parasArr:@[ paras] versionArr:@[@"2.0"]];
    

	return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
           //ß®ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:0];
            ZAPP.myuser.loanListDict = [self getDictWithIndex:0];
            
            [self addUMessageAlias];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:^{
        errorBlock();
    }
    ];
}
- (MKNetworkOperation *)getMyBetDetailWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock loanid:(NSInteger)loanid{
    
    NSDictionary *param = @{@"userid" : @([ZAPP.myuser getUserIDInt]),
                            @"loanid" : @(loanid),
                            NET_KEY_PAGENUM  : @(page),
                            NET_KEY_PAGESIZE : @(pagesize)
                            };
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[@"bet.loan.detail.get"] parasArr:@[param] versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.gerenMyBetDetail = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

/*
 *     /////////////////   获取还款账单列表        /////////////////
 *     add by cc
 */
//获取还款账单列表
- (MKNetworkOperation *)getRepaymentListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    [paras setObject:@[@(1), @(2), @(3), @(4), @(5), @(9), @(14)] forKey:NET_KEY_TYPEarray];
    [paras setObject:@[@(4)] forKey:NET_KEY_TYPEarray];
//    [paras setObject:@[@(1), @(2)] forKey:NET_KEY_STARTTIME];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(page) forKey:NET_KEY_PAGENUM];
    [paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_NOTICE_BILL_LIST_GET] parasArr:@[paras]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.repaymentBillsListRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}
//投资详情  用于投资首页
- (MKNetworkOperation *)getBetDetailWithBetid:(NSString *)betid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    
    NSDictionary *param = @{@"betid" : betid};
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[@"bet.order.detail.get"] parasArr:@[param] versionArr:@[@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.gerenBetDetail = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}
//我的投资
- (MKNetworkOperation *)getGerenMyBetListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock withStage:(NSInteger)stage withOrder:(NSInteger)order{

    DDLogDebug(@"getGerenMyBetListWithPageIndex");
    
	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_QUERYval];
	[paras setObject:@"1" forKey:NET_KEY_QUERYTYPE];
	//[paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[paras setObject:@(page) forKey:NET_KEY_PAGENUM];
	[paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
    [paras setObject:@(stage) forKey:NET_KEY_STAGE];
    [paras setObject:@(order) forKey:NET_KEY_ORDER];
    
	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_BET_ORDER_LIST_GET] parasArr:@[paras] versionArr:@[@"3.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.gerenMyBetList = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}
//我的借款
- (MKNetworkOperation *)getGerenMyLoanListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {

	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:@[@(-1), @(0), @(1),@(2),@(3),@(4), @(5), @(6), @(7)] forKey:NET_KEY_LOANSTATUS];
	[paras setObject:@[@(1),@(2)] forKey:NET_KEY_QUERYTYPES];
	[paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[paras setObject:@(page) forKey:NET_KEY_PAGENUM];
	[paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];

	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_MYORDER_LIST_GET] parasArr:@[paras] versionArr:@[@"2.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.gerenMyLoanList = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}
//我的借款详情
- (MKNetworkOperation *)getMyLoanDetailWithLoanID:(NSString *)loanid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(loanid)
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:loanid forKey:NET_KEY_LOANID];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_MYORDER_DETAIL_GET] parasArr:@[paras] versionArr:@[@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.loanDetailDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}
//我的借款带排序
- (MKNetworkOperation *)getOrderedLoanListWithPage:(int)page pagesize:(int)pagesize order:(NSInteger)order ishistoric:(BOOL)historic complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if (historic) {
        [paras setObject:@[@(3)] forKey:NET_KEY_LOANSTATUS];
    }else{
        [paras setObject:@[@(-3), @(-2), @(0), @(1),@(2), @(7)] forKey:NET_KEY_LOANSTATUS];
    }
    [paras setObject:@(order) forKey:@"order"];
    [paras setObject:@[@(1),@(2)] forKey:NET_KEY_QUERYTYPES];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(page) forKey:NET_KEY_PAGENUM];
    [paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_MYORDER_LIST_GET] parasArr:@[paras] versionArr:@[@"3.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.gerenMyLoanList = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
          
    } errorHandler:errorBlock];
}

//我授信的借款
- (MKNetworkOperation *)getGerenMyShouxinLoanListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock withStage:(NSInteger)stage withOrder:(NSInteger)order historic:(BOOL)historic{
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@[@(3)] forKey:NET_KEY_QUERYTYPES];
    
    if (historic) {
        [paras setObject:@[@(3)] forKey:NET_KEY_LOANSTATUS];
    }else{
        [paras setObject:@[@(-3), @(0), @(1),@(2), @(7)] forKey:NET_KEY_LOANSTATUS];
    }
    
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(page) forKey:NET_KEY_PAGENUM];
    [paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
    [paras setObject:@(stage) forKey:NET_KEY_STAGE];
    [paras setObject:@(order) forKey:NET_KEY_ORDER];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ORDER_LIST_GET] parasArr:@[paras] versionArr:@[@"3.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.gerenMyShouxinLoanList = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}
//借款详情 用于投资首页
- (MKNetworkOperation *)getLoanDetailWithLoanID:(NSString *)loanid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(loanid)
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:loanid forKey:NET_KEY_LOANID];
    
    /*
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_LOAN_ORDER_DETAIL_GET] parasArr:@[[self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]], paras] versionArr:@[@"1.0", @"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:2];
        if (suc) {
            ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:0];
            ZAPP.myuser.loanDetailDict = [self getDictWithIndex:1];
        }
     */
    
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ORDER_DETAIL_GET] parasArr:@[paras] versionArr:@[@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.loanDetailDict = [self getDictWithIndex:0];
        }
        
        
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
        
        
        
    } errorHandler:errorBlock];
}
//借款详情
- (MKNetworkOperation *)getLoanDetailWithLoanID:(NSString *)loanid userid:(NSString *)loanuserid page:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(loanid)
    CHECK_PARA_STRING(loanuserid)

	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:loanid forKey:NET_KEY_LOANID];

	NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
	[para2 setObject:@(4) forKey:NET_KEY_QUERYTYPE];
	[para2 setObject:loanuserid forKey:NET_KEY_USERID];
	[para2 setObject:loanid forKey:NET_KEY_LOANID];
	[para2 setObject:@(page) forKey:NET_KEY_PAGENUM];
	[para2 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];

	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ORDER_DETAIL_GET, NET_FUNC_CREDIT_USER_LIST_GET, NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_LOAN_ATTACHMENT_LIST_GET] parasArr:@[paras, para2, [self para_dict_USER_PROFILE_INFO_GET:loanuserid],@{NET_KEY_LOANID:loanid}] versionArr:@[@"2.0", @"1.0", @"1.0", @"1.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:4];
	                if (suc) {
	                        ZAPP.myuser.loanDetailDict = [self getDictWithIndex:0];
	                        ZAPP.myuser.loanDetailCommonShouxinrenDict = [self getDictWithIndex:1];
	                        ZAPP.myuser.loanDetailLoanUserDict = [self getDictWithIndex:2];
	                        ZAPP.myuser.loanDetailAttachmentList = [self getDictWithIndex:3];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)getGerenMyLoanDetailWithLoanID:(NSString *)loanid fromtype:(NSNumber *)fromtype userid:(NSString *)loanuserid page:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(loanid)
    CHECK_PARA_STRING(loanuserid)
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:loanid forKey:NET_KEY_LOANID];
    [paras setObject:fromtype forKey:@"fromtype"];
    
    NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
    [para2 setObject:@(4) forKey:NET_KEY_QUERYTYPE];
    [para2 setObject:loanuserid forKey:NET_KEY_USERID];
    [para2 setObject:loanid forKey:NET_KEY_LOANID];
    [para2 setObject:@(page) forKey:NET_KEY_PAGENUM];
    [para2 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_MYORDER_DETAIL_GET, NET_FUNC_CREDIT_USER_LIST_GET, NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_LOAN_ATTACHMENT_LIST_GET] parasArr:@[paras, para2, [self para_dict_USER_PROFILE_INFO_GET:loanuserid],@{NET_KEY_LOANID:loanid}] versionArr:@[@"2.0", @"1.0", @"1.0", @"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:4];
        if (suc) {
            ZAPP.myuser.loanDetailDict = [self getDictWithIndex:0];
            ZAPP.myuser.loanDetailCommonShouxinrenDict = [self getDictWithIndex:1];
            ZAPP.myuser.loanDetailLoanUserDict = [self getDictWithIndex:2];
            ZAPP.myuser.loanDetailAttachmentList = [self getDictWithIndex:3];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)getLoanDetailAttachmentsWithLoanID:(NSString *)loanid page:(int)page pagesize:(int)pagesize  complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    CHECK_PARA_STRING(loanid)
	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ATTACHMENT_LIST_GET] parasArr:@[@{NET_KEY_LOANID:loanid}]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.loanDetailAttachmentList = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

//借条-我的借款
- (MKNetworkOperation *)getMyIouListWithPageIndex:(int)page pagesize:(int)pagesize complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock
                                      withIouType:(int)iouType historical:(BOOL)historical andOrder:(NSInteger)order {
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(iouType) forKey:NET_KEY_QUERYTYPE];        //我的借款
    [paras setObject:@(page) forKey:NET_KEY_PAGENUM];
    [paras setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    
    [paras setObject:@(historical?2:1) forKey:NET_KEY_STAGE];
    [paras setObject:@(order) forKey:NET_KEY_ORDER];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_IOU_ORDER_LIST_GET] parasArr:@[paras] versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.gerenMyIouList = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//借条-借条详情
- (MKNetworkOperation *)getMyIouDetailIouid:(NSInteger)iouid complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(iouid) forKey:@"iouid"];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_IOU_ORDER_DETAIL_GET] parasArr:@[paras] versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.gerenMyIouDetail = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//借条-还款方式
- (MKNetworkOperation *)getIouRepayTypesWithCompelte:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_IOU_REPAYTYPE_LIST_GET] parasArr:nil versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.iouRepayTypeList = (NSArray *)[self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//借条-发起还款
- (MKNetworkOperation *)iouRepayActionWithUiId:(NSString *)UiId
                                           amount:(CGFloat)amount
                                        repayType:(NSInteger)repayType
                                    attachments:(NSArray *)attachments
                                         Compelte:(NetResponseBlock)compelteBlock
                                            error:(NetErrorBlock)errorBlock{
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:UiId forKey:@"ui_id"];
    [paras setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras setObject:@(4) forKey:NET_KEY_ACTION];
    [paras setObject:@(amount) forKey:@"ui_repay_amount"];
    [paras setObject:@(repayType) forKey:@"ui_repay_type"];
    [paras setObject:attachments forKey:@"attachments"];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[@"iou.item.action.post"] parasArr:@[paras] versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            //ZAPP.myuser.iouRepayTypeList = (NSArray *)[self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//借条-上传凭证
-(MKNetworkOperation*) uploadIOUImages:(NSArray<UIImage *> *)images
                     completionHandler:(IDBlock) completionBlock
                          errorHandler:(NetErrorBlock) errorBlock {
    
    MKNetworkOperation *op = [self operationWithPath:YQS_API_POST_IMAGE_PATH params:
                              @{NET_KEY_UID:[ZAPP.myuser getUserID],
                                NET_KEY_VERSIONKEY : [Util appVersion],
                                NET_KEY_MODEL : [self getDeviceMode],
                                NET_KEY_SYSTEM : [self getDeviceSystem],
                                NET_KEY_SOURCE : NET_KEY_SOURCE,
                                NET_KEY_RESOURCEkey : @"iou",
                                NET_KEY_RESOURCEid : @"",
                                NET_KEY_FILEtype : @"img"
                                } httpMethod:@"POST" ssl:USESSL];
    
    for (int i = 0; i < images.count; i++) {
        
        NSData *imageData = UIImageJPEGRepresentation(images[i], 0);
        if (imageData == nil || imageData.length == 0) {
            if (ZNOTNULL(errorBlock)) { errorBlock(); }
            return nil;
        }
        [op addData:imageData forKey:@"files[]" mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"iou%zd", i]];
        
    }
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        [self generalCompleteBlock:completedOperation];
        if (ZNOTNULL(completionBlock)) {
            BOOL suc = [self responseSucWithCount:1];
            
            if (suc) {
                if (ZNOTNULL(completionBlock)) {
                    completionBlock([self getDictWithIndex:0]);
                }
            }
            else {
                if (ZNOTNULL(errorBlock)) { errorBlock(); }
            }
        }
    }
                errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                    if (ZNOTNULL(errorBlock)) { errorBlock(); }
                }];
    
    [self enqueueOperation:op];
    
    
    return op;
}
////  End of IOU
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



- (MKNetworkOperation *)getMutualFriendWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock friendUserid:(NSString *)friendUserid page:(int)page pagesize:(int)pagesize {
    
    NSString *jsonStr =
    [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey]
                                   uid:[ZAPP.myuser getUserIDInt]
                              namesArr:@[@"credit.mutual.friend.get"]
                              parasArr:@[@{@"otheruserid" : friendUserid,
                                           NET_KEY_USERID : [ZAPP.myuser getUserID],
                                           NET_KEY_PAGENUM : @(page),
                                           NET_KEY_PAGESIZE : @(pagesize)}]
     ];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.mutualFriendDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//
//- (MKNetworkOperation *)getMightKnownWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid page:(int)page pagesize:(int)pagesize {
//    CHECK_PARA_STRING(userid)
//	NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
//	[para2 setObject:@(5) forKey:NET_KEY_QUERYTYPE];
//	[para2 setObject:userid forKey:NET_KEY_USERID];
//	[para2 setObject:@(page) forKey:NET_KEY_PAGENUM];
//	[para2 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
//
//    CREDIT_USER_LIST_TYPE = 5;
//    /* 第一个请求不用NET_FUNC_CREDIT_USER_LIST_GET  1.0   改为 ：
//     获取新的索要授信请求列表（credit.incomingrequest.list.get  2.0
//     */
//	//  NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getRefreshToken] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_CREDIT_USER_LIST_GET] parasArr:@[para2]];
//	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_CREDIT_USER_LIST_GET, NET_FUNC_USER_PROFILE_INFO_GET] parasArr:@[para2, [self para_dict_USER_PROFILE_INFO_GET:userid]]];
//
//	return [self sendRequest:jsonStr compeletionHandler:^{
//	                BOOL suc = [self responseSucWithCount:2];
//	                if (suc) {
//	                        ZAPP.myuser.mightKnownDict = [self getDictWithIndex:0];
//	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
//			}
//	                [self exeResult:suc complete:compelteBlock error:errorBlock];
//
//		} errorHandler:errorBlock];
//}

NSInteger CREDIT_USER_LIST_TYPE ;
- (MKNetworkOperation *)getShouxinWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid page:(int)page pagesize:(int)pagesize shouxintype:(int)ty {
    CHECK_PARA_STRING(userid)

	NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
	int                  t;
	if (ty == 0) {
		[UtilLog string:@"没向我授信的人"];
		t = 1;
	}
	else if (ty == 1) {
		[UtilLog string:@"已向我授信的人"];
		t = 0;
	}
	else {
		[UtilLog string:@"相互授信的人"];
		t = 3;
	}
    CREDIT_USER_LIST_TYPE = t;
	[para2 setObject:@(t) forKey:NET_KEY_QUERYTYPE];
	[para2 setObject:userid forKey:NET_KEY_USERID];
	[para2 setObject:@(page) forKey:NET_KEY_PAGENUM];
	[para2 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_CREDIT_USER_LIST_GET] parasArr:@[para2]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.shouxinListDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)getAllShouxinPeopleWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock loadid:(NSString *)loadid page:(int)page pagesize:(int)pagesize {
    CHECK_PARA_STRING(loadid)
	NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
	[para1 setObject:loadid forKey:NET_KEY_LOANID];
	[para1 setObject:@(page) forKey:NET_KEY_PAGENUM];
	[para1 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    /*
    NSDictionary *param = @{NET_KEY_LOANID : loadid,
                             NET_KEY_PAGENUM : @(0),
                             NET_KEY_PAGESIZE : @(pagesize)};
    NSDictionary *param2 = @{NET_KEY_LOANID : loadid,
                             NET_KEY_PAGENUM : @(1),
                             NET_KEY_PAGESIZE : @(pagesize)};
    NSDictionary *param3 = @{NET_KEY_LOANID : loadid,
                             NET_KEY_PAGENUM : @(2),
                             NET_KEY_PAGESIZE : @(pagesize)};
    */
    NSArray *namearr = @[NET_FUNC_LOAN_WARRANTY_LIST_GET/*,NET_FUNC_LOAN_WARRANTY_LIST_GET,NET_FUNC_LOAN_WARRANTY_LIST_GET*/];
	NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:namearr parasArr:@[para1/*,param, param2, param3*/] versionArr:@[@"2.0"]];
    
	return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)namearr.count];
        if (suc) {
            /*
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self getDictWithIndex:0][@"warrantys"]];
            [arr addObjectsFromArray:[self getDictWithIndex:1][@"warrantys"]];
            [arr addObjectsFromArray:[self getDictWithIndex:2][@"warrantys"]];
            
            NSMutableArray *userids = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in arr) {
                NSString *userid = dict[@"userid"];
                [userids addObject:userid];
            }
            for (NSDictionary *dict in arr) {
                NSString *userid = dict[@"userid"];
                for (NSString *savedId in userids) {
                    if ([userid isEqualToString:savedId]) {
                        NSLog(@"Catched !!!!");
                    }
                }
            }
            */
            ZAPP.myuser.allShouxinPeopleListDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];

    } errorHandler:errorBlock];
}

// 查询向他授信
- (NSDictionary *)para_creditHeRelation:(NSString *)userid {
    CHECK_PARA_STRING(userid)
    NSMutableDictionary *paras2 = [NSMutableDictionary dictionary];
    [paras2 setObject:@(0) forKey:NET_KEY_QUERYTYPE];
    [paras2 setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [paras2 setObject:userid forKey:NET_KEY_targetuserid];
    return paras2;
}
// 查询向我授信
- (NSDictionary *)para_creditMeRelation:(NSString *)userid {
    CHECK_PARA_STRING(userid)
    NSMutableDictionary *paras2 = [NSMutableDictionary dictionary];
    [paras2 setObject:@(0) forKey:NET_KEY_QUERYTYPE];
    [paras2 setObject:userid forKey:NET_KEY_USERID];
    [paras2 setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_targetuserid];
    return paras2;
}

- (MKNetworkOperation *)getPersonInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid{
    CHECK_PARA_STRING(userid)
	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey]
                                                       uid:[ZAPP.myuser getUserIDInt]
                                                  namesArr:@[NET_FUNC_USER_PROFILE_INFO_GET,
                                                             NET_FUNC_CREDIT_USER_creditvals_GET,
                                                             NET_FUNC_CREDIT_USER_creditvals_GET,
                                                             NET_FUNC_CREDIT_USER_LIST_GET,
                                                             //@"credit.incomingrequest.exists.get"
                                                             ]
                                                  parasArr:@[[self para_dict_USER_PROFILE_INFO_GET:userid],
                                                             [self para_creditHeRelation:userid],
                                                             [self para_creditMeRelation:userid],
                                                             @{@"querytype":@(CREDIT_USER_LIST_TYPE), @"userid":userid, @"pagenum":@(0), @"pagesize":@(NSIntegerMax)},
                                                             //@{@"userid": [[AppDelegate zapp].myuser getUserID], @"targetuserid":userid}
                                                             ]
                         ];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:4];
	                if (suc) {
	                        ZAPP.myuser.personInfoDict = [self getDictWithIndex:0];
                        ZAPP.myuser.personHeRelationshipDict = [self getDictWithIndex:1];
                        ZAPP.myuser.personMeRelationshipDict = [self getDictWithIndex:2];
                        ZAPP.myuser.creditUserList = [self getDictWithIndex:3];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)creditWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid intv:(int)v {
    CHECK_PARA_STRING(userid)
	if (v == 0) {
		[UtilLog string:@"取消授信"];
	}
	else {
		[UtilLog string:[NSString stringWithFormat:@"授信%d", v]];
	}
	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:@(v) forKey:NET_KEY_CREDITVAL];
	[paras setObject:userid forKey:NET_KEY_targetuserid];
    if (v < 0) {
        [paras setObject:@(0) forKey:NET_KEY_ACTION];
    }

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_CREDIT_COMMON_ACTION_POST, NET_FUNC_USER_PROFILE_INFO_GET, NET_FUNC_CREDIT_USER_creditvals_GET] parasArr:@[paras,[self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]], [self para_creditMeRelation:userid]]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:3];
	                if (suc) {
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
	                        ZAPP.myuser.personMeRelationshipDict = [self getDictWithIndex:2];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)requestCreditWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid {
    CHECK_PARA_STRING(userid)
	[UtilLog string:@"索要授信"];
	NSMutableDictionary *paras = [NSMutableDictionary dictionary];
	[paras setObject:userid forKey:NET_KEY_targetuserid];

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_CREDIT_USER_acquire_post] parasArr:@[paras]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

// 我的账单
- (MKNetworkOperation *)getBillNGWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock page:(int)page pagesize:(int)pagesize begin:(NSString *)begin end:(NSString *)end bill_type:(NSInteger)bill_type{
    
    NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
    [para2 setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [para2 setObject:@(page) forKey:NET_KEY_PAGENUM];
    [para2 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
    [para2 setObject:begin forKey:@"begindate"];
    [para2 setObject:end forKey:@"enddate"];
    [para2 setObject:@(bill_type) forKey:@"bill_type"];

    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[@"user.bill.list.get"] parasArr:@[para2] versionArr:@[@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.billDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)getBillWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userid:(NSString *)userid page:(int)page pagesize:(int)pagesize {
    CHECK_PARA_STRING(userid)
	NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
	[para2 setObject:userid forKey:NET_KEY_USERID];
	[para2 setObject:@(page) forKey:NET_KEY_PAGENUM];
	[para2 setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];
	[para2 setObject:@[@(1), @(2), @(3), @(4), @(5), @(9), @(14)] forKey:NET_KEY_TYPEarray];

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_NOTICE_BILL_LIST_GET] parasArr:@[para2]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.billDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)searchWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock searchkey:(NSString *)searchkey page:(int)page pagesize:(int)pagesize {
    CHECK_PARA_STRING(searchkey)
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:searchkey forKey:NET_KEY_SEARCHKEY];
	[para setObject:@(page) forKey:NET_KEY_PAGENUM];
	[para setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_USER_LIST_SEARCH_GET] parasArr:@[para]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.searchListDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}


- (MKNetworkOperation *)getMortgateComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    
    NSDictionary *para1 = @{@"userid"         : [ZAPP.myuser getUserID]};
    NSDictionary *para2 = @{@"conditions"     : @[@"专属用户借款天数", @"专属用户借款筹款天数", @"专属借款年化利率"]};
    
    NSString *jsonStr =
    [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey]
                                             uid:[ZAPP.myuser getUserIDInt]
                                        namesArr:@[NET_FUNC_mortgage_constraint_check_get,NET_FUNC_system_configure_info_get]
                                        parasArr:@[para1, para2]
                                      versionArr:@[@"1.0", @"3.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:2];
        if (suc) {
            NSDictionary *loanMortgageDict = [self getDictWithIndex:0];
            NSDictionary *configurationDict = [self getDictWithIndex:1];
            
            if (loanMortgageDict && configurationDict) {
                
                NSMutableDictionary *tdict = [[NSMutableDictionary alloc]init];
                
                ZAPP.myuser.loanMortgateStatus          = [loanMortgageDict[@"status"] integerValue];
                ZAPP.myuser.loanMortgateConfiguration   = configurationDict;
                
                NSArray *configArr = configurationDict[@"items"];
                
                for (int idx = 0; idx<configArr.count; idx++) {
                    switch (idx) {
                        case 0:{
                            ZAPP.myuser.loanMortgatedays = configArr[idx];
                        }
                            break;
                            
                        default:{
                            NSDictionary *dict = configArr[idx];
                            [tdict setValue:dict[@"value"] forKey:dict[@"name"]];
                        }
                            break;
                    }
                }
                
            }
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    
    } errorHandler:errorBlock];
                            
}

- (MKNetworkOperation *)getTransferDataComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    
    NSArray * nameArray = @[@"user.transfer.data.get"];
    NSArray * paraArray = @[@{@"userid" : [ZAPP.myuser getUserID]}];
    NSString *jsonStr =
    [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"3.0"]];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            
            ZAPP.myuser.transferDataList = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)getTransferLimitComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    
    NSArray * nameArray = @[@"user.withdraw.limit.post", @"user.transfer.limit.get"];
    NSArray * paraArray = @[@{@"amount" :  @(0),@"userid" :  [ZAPP.myuser getUserID]},
                            @{@"userid" : [ZAPP.myuser getUserID],}
                        ];
    NSString *jsonStr =
    [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0", @"3.0"]];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:2];
        if (suc) {
            
            ZAPP.myuser.withdrawLimitRespondDict = [self getDictWithIndex:0];
            NSDictionary * leftReps = [self getDictWithIndex:1];
            ZAPP.myuser.transferLimitLeft = [leftReps[@"left"] doubleValue];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}


- (MKNetworkOperation *)fabuWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
	NSDictionary *dict = [ZAPP.myuser fabuGetDataDict];

	[UtilLog dict:dict];

	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[para setObject:[dict objectForKey:def_key_fabu_name] forKey:NET_KEY_TITLE];
	[para setObject:[dict objectForKey:def_key_fabu_money] forKey:NET_KEY_VAL];//FIXME: 修改参数类型为number
	[para setObject:[dict objectForKey:def_key_fabu_borrow_day] forKey:NET_KEY_LOANDAYCOUNT];//FIXME: 修改参数类型为number
	[para setObject:[dict objectForKey:def_key_fabu_friend_type] forKey:NET_KEY_LOANTYPE];
    
	CGFloat    x = [[dict objectForKey:def_key_fabu_lixi] doubleValue];
	NSString *z = [NSString stringWithFormat:@"%.1f", x];
	[para setObject:z forKey:NET_KEY_LOANRATE];//FIXME: 修改参数类型为number
    
	[para setObject:[dict objectForKey:def_key_fabu_huankuan_day] forKey:NET_KEY_interestdaycount];//FIXME: 修改参数类型为number
	[para setObject:[dict objectForKey:def_key_fabu_yongtu] forKey:NET_KEY_PURPOSE];

	[UtilLog dict:para];
#ifdef TEST_RELEASE_SMALL_VAL
	[para setObject:@([[dict objectForKey:def_key_fabu_money] intValue]*0.0001)  forKey:NET_KEY_VAL];
#endif

	NSString *loanid = [ZAPP.myuser.fabuGetDataDict objectForKey:def_key_fabu_loanid];
	if ([loanid notEmpty]) {
		[para setObject:loanid forKey:NET_KEY_LOANID];
	}

	NSMutableArray *arr  = [NSMutableArray array];
	NSArray *       aaaa = [ZAPP.myuser fabuFujianArray];
	if ([aaaa count] > 0) {
		for (NSDictionary *x in aaaa) {
			[arr addObject:[self getAttachDict:x]];
		}
		[para setObject:arr forKey:NET_KEY_ATTACHMENTS];
	}


	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ORDER_ITEM_POST, NET_FUNC_USER_PROFILE_INFO_GET] parasArr:@[para, [self para_dict_me_USER_PROFILE_INFO_GET]]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:2];
	                if (suc) {
	                        ZAPP.myuser.loanFabuSucDetailDict = [self getDictWithIndex:0];
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}
- (MKNetworkOperation *)loanCalWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock mainval:(NSInteger)mainval loanrate:(CGFloat)loanrate couponrate:(CGFloat)couponrate daycount:(NSInteger)daycount{
    
    NSDictionary *para = @{@"userid" : [ZAPP.myuser getUserID],
                           @"loantype" : @(1),
                           @"mainval" : @(mainval),
                           @"loanrate" : @(loanrate),
                           @"interestrate"   : @(couponrate),
                           @"interestdaycount" : @(daycount)};
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ORDER_CALCVALS_GET] parasArr:@[para]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.myuser.fabuCalDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}
- (MKNetworkOperation *)loanCalWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
	NSDictionary *dict = [ZAPP.myuser fabuGetDataDict];

	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [para setObject:[dict objectForKey:def_key_fabu_money] forKey:NET_KEY_MAINVAL];//FIXME: 修改参数类型为number
    
	[para setObject:[dict objectForKey:def_key_fabu_friend_type] forKey:NET_KEY_LOANTYPE];
    
    CGFloat    x = [[dict objectForKey:def_key_fabu_lixi] doubleValue];
    NSString *z = [NSString stringWithFormat:@"%.1f", x];
    [para setObject:z forKey:NET_KEY_LOANRATE];//FIXME: 修改参数类型为number
    
	[para setObject:[dict objectForKey:def_key_fabu_huankuan_day] forKey:NET_KEY_interestdaycount];//FIXME: 修改参数类型为number


	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_LOAN_ORDER_CALCVALS_GET] parasArr:@[para]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.myuser.fabuCalDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)getRemindNumWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock date:(NSDate *)date {
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	if (date != nil) {
		[para setObject:[UtilTimeStamp yqsTimestampString:date] forKey:NET_KEY_TIMESTAMP];
	}

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_NOTICE_UPDATE_REMIND_GET] parasArr:@[para]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        [ZAPP.znotice setTheDataDict:[self getDictWithIndex:0]];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}
- (MKNetworkOperation *)deleteRemindListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock notices:(NSArray *)notices{
    NSDictionary *paraDelete = @{NET_KEY_USERID : [ZAPP.myuser getUserID],
                           @"ids": notices};
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[@"notice.common.item.post"] parasArr:@[paraDelete] versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:1];
        if (suc) {
            ZAPP.znotice.noticeListDict = [self getDictWithIndex:1];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)getRemindListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock page:(int)page pagesize:(int)pagesize {

	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[para setObject:@(page) forKey:NET_KEY_PAGENUM];
	[para setObject:@(pagesize) forKey:NET_KEY_PAGESIZE];

    NSString * v = @"1.0";
#ifdef TEST_ALL_TIXING_MSG
    v = @"1.1";
#endif
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[NET_FUNC_NOTICE_COMMON_LIST_GET] parasArr:@[para] versionArr:@[v]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:1];
	                if (suc) {
	                        ZAPP.znotice.noticeListDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:errorBlock];
}

// 发送验证码，带有区号
- (MKNetworkOperation *)sendValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock phonenum:(NSString *)phonenum  regionCode:(NSInteger)regionCode{
    CHECK_PARA_STRING(phonenum)
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(0) forKey:NET_KEY_VALIDATETYPE];
    [para setObject:phonenum forKey:NET_KEY_PHONE];
    [para setObject:@(regionCode) forKey:@"international"];
    
    NSArray * nameArray = @[NET_FUNC_SYSTEM_VALIDATECODE_ITEM_POST];
    NSArray * paraArray = @[para];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.sendValidateCodeRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)sendValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock phonenum:(NSString *)phonenum {
    CHECK_PARA_STRING(phonenum)
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:@(0) forKey:NET_KEY_VALIDATETYPE];
	[para setObject:phonenum forKey:NET_KEY_PHONE];

	NSArray * nameArray = @[NET_FUNC_SYSTEM_VALIDATECODE_ITEM_POST];
	NSArray * paraArray = @[para];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.sendValidateCodeRespondDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)sendValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock email:(NSString *)email {
    CHECK_PARA_STRING(email)
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:@(1) forKey:NET_KEY_VALIDATETYPE];
	[para setObject:email forKey:NET_KEY_EMAIL];

	NSArray * nameArray = @[NET_FUNC_SYSTEM_VALIDATECODE_ITEM_POST];
	NSArray * paraArray = @[para];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.sendValidateCodeEmailRespondDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)checkValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock uuid:(NSString *)uuid code:(NSString *)code savedphone:(NSString *)savedphone {
    CHECK_PARA_STRING(uuid)
    CHECK_PARA_STRING(savedphone)
    CHECK_PARA_STRING(code)
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:uuid forKey:NET_KEY_VALIDATEUUID];
	[para setObject:code forKey:NET_KEY_VALIDATECODE];
	[para setObject:savedphone forKey:NET_KEY_device];

	NSArray * nameArray = @[NET_FUNC_SYSTEM_VALIDATECODE_CHECK_POST];
	NSArray * paraArray = @[para];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.checkValidateCodeRespondDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

//修改手机号
- (MKNetworkOperation *)postPhoneAfterValidationWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock savedphone:(NSString *)savedphone regionCode:(NSInteger)regionCode validationCode:(NSString *)validationCode  validationUUID:(NSString *)validationUUID{
    CHECK_PARA_STRING(savedphone)
	NSDictionary *para2 = @{
		NET_KEY_PHONE : savedphone,
		NET_KEY_USERID : [ZAPP.myuser getUserID],
        @"international" : @(regionCode),
        @"validatecodeinfo" : @{@"device" : savedphone,
                                @"validatecode" : validationCode,
                                @"validateuuid" : validationUUID
                                },
        };

	NSArray * nameArray = @[NET_FUNC_USER_PROFILE_DETAIL_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray * paraArray = @[para2, [self para_dict_me_USER_PROFILE_INFO_GET]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"3.0", @"1.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)postNickNameWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock nickname:(NSString *)nickname {
    CHECK_PARA_STRING(nickname)
	NSDictionary *para2 = @{
		NET_KEY_NICKNAME: nickname,
		NET_KEY_USERID : [ZAPP.myuser getUserID]
	};

	NSArray * nameArray = @[NET_FUNC_USER_PROFILE_DETAIL_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray * paraArray = @[para2, [self para_dict_me_USER_PROFILE_INFO_GET]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}


//微信分享
- (MKNetworkOperation *)getShareTriggerWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    NSDictionary *para = @{@"userid" : [ZAPP.myuser getUserID]};
    NSArray * nameArray = @[@"user.red.info.get"];
    NSArray * paraArray = @[para];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.shareInfoDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)postShareTriggerWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock triggerid:(NSString *)triggerid {
    NSDictionary *para = @{@"userid" : [ZAPP.myuser getUserID],
                           @"triggerid" : triggerid};
    NSArray * nameArray = @[@"user.red.item.post"];
    NSArray * paraArray = @[para];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            //ZAPP.myuser.shareInfoDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)postHeadUrlWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock headrul:(NSString *)headurl {
    CHECK_PARA_STRING(headurl)
	NSDictionary *para2 = @{
		NET_KEY_HEADIMG: headurl,
		NET_KEY_USERID : [ZAPP.myuser getUserID]
	};

	NSArray * nameArray = @[NET_FUNC_USER_PROFILE_DETAIL_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray * paraArray = @[para2, [self para_dict_me_USER_PROFILE_INFO_GET]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)checkValidateCodeEmailWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock uuid:(NSString *)uuid code:(NSString *)code savedemail:(NSString *)savedemail {
    CHECK_PARA_STRING(uuid)
    CHECK_PARA_STRING(code)
    CHECK_PARA_STRING(savedemail)
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:uuid forKey:NET_KEY_VALIDATEUUID];
	[para setObject:code forKey:NET_KEY_VALIDATECODE];
	[para setObject:savedemail forKey:NET_KEY_device];

	NSArray * nameArray = @[NET_FUNC_SYSTEM_VALIDATECODE_CHECK_POST];
	NSArray * paraArray = @[para];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.checkValidateCodeEmailRespondDict = [self getDictWithIndex:0];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)bindBankcardCommitNameAndIdNumberWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock userrealname:(NSString *)name idcardnumber:(NSString *)idcard {
    CHECK_PARA_STRING(name)
    CHECK_PARA_STRING(idcard)
   	NSDictionary *para = @{
                           @"realname":name,
                           NET_KEY_IDNUMBER:idcard,
                           NET_KEY_USERID : [ZAPP.myuser getUserID]
                           };
    
    NSArray * nameArray = @[@"user.info.identify.post", NET_FUNC_USER_PROFILE_INFO_GET];
    NSArray * paraArray = @[para,  [self para_dict_me_USER_PROFILE_INFO_GET]];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0",@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}


- (MKNetworkOperation *)bindBankcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock cardnumber:(NSString *)cardnumber phonenumber:(NSString *)phonenumber bankCode:(NSString *)bankCode userName:(NSString *)username idNumber:(NSString *)idnumber{
    CHECK_PARA_STRING(cardnumber)
    CHECK_PARA_STRING(phonenumber)
	NSDictionary *para = @{
		NET_KEY_PHONE: phonenumber,
//		NET_KEY_city:cityName,
//		NET_KEY_province:provinceName,
		NET_KEY_visacode:cardnumber,
        @"bankcode":bankCode,
		NET_KEY_USERID : [ZAPP.myuser getUserID]
	};
    
    NSMutableDictionary *mPara = para.mutableCopy;
    
    if (username.length > 0) {
        [mPara setObject:username forKey:@"userrealname"];
    }
    
    if (idnumber.length > 0) {
        [mPara setObject:idnumber forKey:@"idnumber"];
    }
    
    para = mPara.copy;
    
    //@"userrealname" : username,
    //@"idnumber" : idnumber,
    
    NSDictionary *para2 = [self para_dict_me_USER_VISA_LIST_GET];
    NSString *version = @"2.0";
#ifdef USER_VISA_LIST_GET_API_VER_1
    version = @"1.0";
#endif

	NSArray * nameArray = @[NET_FUNC_user_visa_binding_post, NET_FUNC_user_visa_list_get];
	NSArray * paraArray = @[para,  para2];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0",version]];

	return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.bindBankcardRespondDict = [self getDictWithIndex:0];
            ZAPP.myuser.bankcardListRespondDict = [self getDictWithIndex:1];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
		} errorHandler:errorBlock];
}

- (NSDictionary *)getAttachDict:(NSDictionary *)attach {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSString *           ty   = [attach objectForKey:NET_KEY_TYPE];
	NSString *           name = [attach objectForKey:NET_KEY_NAME];
	NSString *           url  = [attach objectForKey:NET_KEY_URL];
	if ([name notEmpty]) {
	}
	else {
		name = [attach objectForKey:NET_KEY_ORGFILENAME];
	}
	if ([ty notEmpty]) {

	}
	else {
		ty = [attach objectForKey:@"attrtype"];
	}
	if ([name notEmpty]) {
		[dict setObject:name forKey:NET_KEY_ORGFILENAME];

	}
	if ([ty notEmpty]) {
		[dict setObject:ty forKey:NET_KEY_TYPE];
	}
	if ([url notEmpty]) {
		[dict setObject:url forKey:NET_KEY_URL];
	}
	return dict;
}

- (MKNetworkOperation *)commitIdcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock realname:(NSString *)realname idnumber:(NSString *)idnumber attach:(NSDictionary *)attach {
    CHECK_PARA_STRING(realname)
    CHECK_PARA_STRING(idnumber)

	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	NSDictionary *       atta = [self getAttachDict:attach];
	[para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[para setObject:@"1" forKey:NET_KEY_targetlevel];

	NSMutableDictionary *detail1 = [NSMutableDictionary dictionary];
    if([realname length]){
        [detail1 setObject:realname forKey:NET_KEY_itemvalue];
        [detail1 setObject:NET_KEY_USERREALNAME forKey:NET_KEY_itemtype];
    }

	NSMutableDictionary *detail2 = [NSMutableDictionary dictionary];
    if([idnumber length]){
        [detail2 setObject:idnumber forKey:NET_KEY_itemvalue];
    }
    [detail2 setObject:@"idcard" forKey:NET_KEY_itemtype];
	[detail2 setObject:@[atta] forKey:NET_KEY_ATTACHMENTS];

	[para setObject:@[detail2] forKey:NET_KEY_details];

	NSArray * nameArray = @[NET_FUNC_USER_IDENTIFY_action_post, NET_FUNC_USER_IDENTIFY_progress_get];
	NSArray * paraArray = @[para, [self para_dict_me_USER_IDENTIFY_PROGRESS_GET]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"3.0", @"2.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.identifyProgressDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)newCommitCompanyWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock company:(NSString *)company job:(NSString *)job address:(NSString *)address positions:(NSArray *)positions explain:(NSString *)explain {
    CHECK_PARA_STRING(company)
    CHECK_PARA_STRING(job)
    CHECK_PARA_STRING(address)
	NSMutableDictionary *para = [NSMutableDictionary dictionary];
	[para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
	[para setObject:@"2" forKey:NET_KEY_targetlevel];

	NSMutableDictionary *detail1 = [NSMutableDictionary dictionary];
	[detail1 setObject:company forKey:NET_KEY_itemvalue];
	[detail1 setObject:NET_KEY_ORGANIZATION forKey:NET_KEY_itemtype];

	NSMutableDictionary *detail2 = [NSMutableDictionary dictionary];
	[detail2 setObject:job forKey:NET_KEY_itemvalue];
	[detail2 setObject:NET_KEY_JOB forKey:NET_KEY_itemtype];

	NSMutableDictionary *detail3 = [NSMutableDictionary dictionary];
	[detail3 setObject:address forKey:NET_KEY_itemvalue];
	[detail3 setObject:NET_KEY_ADDRESS forKey:NET_KEY_itemtype];

    
    NSMutableArray *contentArray = [@[detail1, detail2, detail3] mutableCopy];
    
    if ([positions isKindOfClass:[NSArray class]] && positions.count > 0) {
        //社会职务
        NSMutableDictionary *detail4 = [NSMutableDictionary dictionary];
        [detail4 setObject:positions forKey:NET_KEY_itemvalue];
        [detail4 setObject:@"own_group" forKey:NET_KEY_itemtype]; //NET_KEY_SOCIALFUNC
        
        [contentArray addObject:detail4];
    }
    
    if ([explain isKindOfClass:[NSString class]] && explain.length > 0) {
        //其他说明
        NSMutableDictionary *detail5 = [NSMutableDictionary dictionary];
        [detail5 setObject:explain forKey:NET_KEY_itemvalue];
        [detail5 setObject:@"explain" forKey:NET_KEY_itemtype];
        
        [contentArray addObject:detail5];
    }

	[para setObject:contentArray forKey:NET_KEY_details];

	NSArray * nameArray = @[NET_FUNC_USER_IDENTIFY_action_post, NET_FUNC_USER_IDENTIFY_progress_get];
	NSArray * paraArray = @[para, [self para_dict_me_USER_IDENTIFY_PROGRESS_GET]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"3.0", @"2.0"]];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.identifyProgressDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

#define DO_NOTNULL_ERROR_BLOCK if (ZNOTNULL(errorBlock)) { errorBlock(); }

- (NSDictionary *)getFirstFileUrl {
	NSDictionary *res       = nil;
	NSDictionary *firstResp = [self getDictWithIndex:0];
	if (firstResp != nil) {
		int filecnt = [[firstResp objectForKey:NET_KEY_FILEcount] intValue];
		if (filecnt == 1) {
			NSArray *files = [firstResp objectForKey:@"files"];
			if (filecnt == [files count]) {
				res = [files objectAtIndex:0];
			}
		}
	}
	return res;
}

- (NSArray *)getIDCardFileUrl {
    NSDictionary *res       = nil;
    NSDictionary *firstResp = [self getDictWithIndex:0];
    if (firstResp != nil) {
        int filecnt = [[firstResp objectForKey:NET_KEY_FILEcount] intValue];
        if (filecnt == 2) {
            NSArray *files = [firstResp objectForKey:@"files"];
            return files;
//            if (filecnt == [files count]) {
//                res = [files objectAtIndex:0];
//            }
        }
    }
    return nil;
}



-(MKNetworkOperation*) uploadImages:(NSArray *)imagesArr
                              files:(NSArray *)filesArr
                         completionHandler:(CardIDBlock) completionBlock
                              errorHandler:(NetErrorBlock) errorBlock {
//    CHECK_PARA_STRING(imagesArr)
    
    if(!imagesArr || (imagesArr.count != filesArr.count))return nil;
    
    
    NSMutableDictionary *mdic = [@{NET_KEY_UID:[ZAPP.myuser getUserID],
                                  NET_KEY_VERSIONKEY : [Util appVersion],
                                  NET_KEY_MODEL : [self getDeviceMode],
                                  NET_KEY_SYSTEM : [self getDeviceSystem],
                                  NET_KEY_SOURCE : @(2),
                                  NET_KEY_RESOURCEkey : @"user",
                                  NET_KEY_RESOURCEid : @"",
                                  NET_KEY_FILEtype : @"img"
                                  } mutableCopy];
    
    MKNetworkOperation *op = [self operationWithPath:YQS_API_POST_IMAGE_PATH params:            mdic
                               httpMethod:@"POST" ssl:USESSL];
    
    
    for (NSInteger i=0;i<imagesArr.count;i++) {
        UIImage *image = imagesArr[i];
        NSString *file = filesArr[i];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0);
        if (imageData == nil || imageData.length == 0) {
            DO_NOTNULL_ERROR_BLOCK
            return nil;
        }
        [op addData:imageData forKey:@"files[]" mimeType:@"image/jpeg" fileName:file];
        
    }
    

    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        [self generalCompleteBlock:completedOperation];
        if (ZNOTNULL(completionBlock)) {
            BOOL suc = [self responseSucWithCount:1];
            
            if (suc) {
                
                NSArray *arr = [self getIDCardFileUrl];

//                if (urlstr != nil) {
//                    if (ZNOTNULL(completionBlock)) {
                completionBlock(arr);
//                    }
//                }
//                else {
//                    DO_NOTNULL_ERROR_BLOCK
//                }
            }
            else {
                DO_NOTNULL_ERROR_BLOCK
            }
        }
    }
                errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                    DO_NOTNULL_ERROR_BLOCK
                }];
    
    [self enqueueOperation:op];
    
    
    return op;
}


-(MKNetworkOperation*) uploadImageFromFile:(NSString*) file image:(UIImage *)img
        completionHandler:(IDBlock) completionBlock
        errorHandler:(NetErrorBlock) errorBlock {
    CHECK_PARA_STRING(file)

	MKNetworkOperation *op = [self operationWithPath:YQS_API_POST_IMAGE_PATH params:
	                          @{NET_KEY_UID:[ZAPP.myuser getUserID],
                                NET_KEY_VERSIONKEY : [Util appVersion],
                                NET_KEY_MODEL : [self getDeviceMode],
                                NET_KEY_SYSTEM : [self getDeviceSystem],
                                NET_KEY_SOURCE : NET_KEY_SOURCE,
	                            NET_KEY_RESOURCEkey : NET_KEY_LOAN,
                                NET_KEY_RESOURCEid : @"",
                                NET_KEY_FILEtype : @"img"
                                } httpMethod:@"POST" ssl:USESSL];

    
    CGFloat compression = 0.0f;
    if ([file hasPrefix:@"license"]) {
        compression = 1.0f;
    }
	NSData *imageData = UIImageJPEGRepresentation(img, compression);
	if (imageData == nil || imageData.length == 0) {
		DO_NOTNULL_ERROR_BLOCK
		return nil;
	}
	[op addData:imageData forKey:@"files[]" mimeType:@"image/jpeg" fileName:file];

	// setFreezable uploads your images after connection is restored!
	[op setFreezable:YES];

	[op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
	         [self generalCompleteBlock:completedOperation];
	         if (ZNOTNULL(completionBlock)) {
	                 BOOL suc = [self responseSucWithCount:1];

	                 if (suc) {
	                         NSDictionary *urlstr = [self getFirstFileUrl];
	                         if (urlstr != nil) {
	                                 if (ZNOTNULL(completionBlock)) {
	                                         completionBlock(urlstr);
					 }
				 }
	                         else {
	                                 DO_NOTNULL_ERROR_BLOCK
				 }
			 }
	                 else {
	                         DO_NOTNULL_ERROR_BLOCK
			 }
		 }
	 }
	 errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
	         DO_NOTNULL_ERROR_BLOCK
	 }];

	[self enqueueOperation:op];


	return op;
}

- (MKNetworkOperation *)commitProvinceCityWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock province:(NSString *)provinceName city:(NSString *)cityName {
    CHECK_PARA_STRING(provinceName)
    CHECK_PARA_STRING(cityName)
	NSDictionary *para = @{
		NET_KEY_cityname:cityName,
		NET_KEY_provincename:provinceName,
		NET_KEY_USERID : [ZAPP.myuser getUserID]
	};

	NSArray * nameArray = @[NET_FUNC_USER_PROFILE_DETAIL_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray * paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)commitIntroWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock intro:(NSString *)intro {
    CHECK_PARA_STRING(intro)
	NSDictionary *para = @{
		NET_KEY_SHORTDESC:intro,
		NET_KEY_USERID : [ZAPP.myuser getUserID]
	};

	NSArray * nameArray = @[NET_FUNC_USER_PROFILE_DETAIL_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray * paraArray = @[para, [self para_dict_me_USER_PROFILE_INFO_GET]];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

- (MKNetworkOperation *)getUserBankcardListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    NSArray * nameArray = @[NET_FUNC_user_visa_list_get];
    NSArray * paraArray = @[[self para_dict_me_USER_VISA_LIST_GET_NOCACHE]];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.bankcardListRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)api2_getBanksListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    
    NSArray * nameArray = @[@"paymentway.bank.list.get"];
    NSArray * paraArray = @[@{NET_KEY_QUERYTYPE : @"1"}];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.bankcardPayListRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:^{
        errorBlock();
    }];
}
- (MKNetworkOperation *)api2_getBankcardListWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    
    
    
    if ([ZAPP.myuser getUserID].length) {
    
        NSDictionary *para = [self para_dict_me_USER_VISA_LIST_GET];
        NSString *version = @"2.0";
    #ifdef USER_VISA_LIST_GET_API_VER_1
        version = @"1.0";
    #endif
        
        NSArray * nameArray = @[NET_FUNC_user_visa_list_get, @"paymentway.bank.list.get"];
        NSArray * paraArray = @[para, @{NET_KEY_QUERYTYPE : @"1"}];
        NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[version, @"1.0"]];
        
        return [self sendRequest:jsonStr compeletionHandler:^{
            BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
            if (suc) {
                ZAPP.myuser.bankcardListRespondDict = [self getDictWithIndex:0];
                ZAPP.myuser.bankcardPayListRespondDict = [self getDictWithIndex:1];
            }
            [self exeResult:suc complete:compelteBlock error:errorBlock];
            
        } errorHandler:^{
            errorBlock();
        }];
        
    }else{
        
        NSArray * nameArray = @[@"paymentway.bank.list.get"];
        NSArray * paraArray = @[@{NET_KEY_QUERYTYPE : @"1"}];
        NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0"]];
        
        return [self sendRequest:jsonStr compeletionHandler:^{
            BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
            if (suc) {
                ZAPP.myuser.bankcardPayListRespondDict = [self getDictWithIndex:0];
            }
            [self exeResult:suc complete:compelteBlock error:errorBlock];
            
        } errorHandler:^{
            errorBlock();
        }];
        
    }
    
}

- (MKNetworkOperation *) requestVisaActiveValidateCodeComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    
//    [self api2_getBankcardListWithComplete:^{
//        ;
//    } error:^{
//        ;
//    }];
//    NSString *visaId = ZAPP.myuser.bankcardListRespondDict[@"visas"][0][@"visaid"];
//    CHECK_PARA_STRING(visaId);
    
    NSDictionary *p = [self para_dict_me_USER_VISA_LIST_GET];
    NSDictionary *para = @{
                           @"querytype": @(0),
                           @"queryval" : @"@visas.0.visaid@",
                           };
    NSDictionary *para2 = @{
                            @"userid"   : ZAPP.myuser.getUserID,
                            @"visaid"   : @"@visaid@",
                            @"value"    : @"@lowlimiteverytrade@"
                            };
    
    NSArray * nameArray = @[NET_FUNC_user_visa_list_get, @"user.visa.info.get",@"user.visa.active.post"]; //, @"user.visa.active.post"
    NSArray * paraArray = @[p, para, para2];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0",@"2.0",@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.userVisaInfoRespondDict = [self getDictWithIndex:1];
            ZAPP.myuser.userVisaActiveRespondDict = [self getDictWithIndex:2];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:
            errorBlock
            ];
}

- (MKNetworkOperation *)guestBankWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock bankCard:(NSString *)bankCard{
    CHECK_PARA_STRING(bankCard)
    
    NSArray * nameArray = @[NET_FUNC_user_visa_list_get, @"paymentway.bank.list.get", @"user.visa.guestbank.get"];
    NSArray * paraArray = @[[self para_dict_me_USER_VISA_LIST_GET], @{NET_KEY_QUERYTYPE : @"1"}, @{@"visacode":bankCard}];
    
    
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0",@"1.0",@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.bankcardListRespondDict = [self getDictWithIndex:0];
            ZAPP.myuser.bankcardPayListRespondDict = [self getDictWithIndex:1];
            ZAPP.myuser.visaGuestBank = [self getDictWithIndex:2];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)checkBankcardValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock orderno:(NSString *)orderno code:(NSString *)code {
    CHECK_PARA_STRING(orderno)
    CHECK_PARA_STRING(code)
	NSDictionary *para = @{
		NET_KEY_ORDERNO: orderno,
		NET_KEY_ACTIONTYPE : @"0",
		NET_KEY_VALIDATECODE:code
	};
	NSArray * nameArray = @[NET_FUNC_paymentway_validatecode_check_post];
	NSArray * paraArray = @[para];
	NSString *jsonStr   = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];

	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.checkBankValidateCodeRespondDict = [self getDictWithIndex:0];
                    }else{
                        ZAPP.myuser.checkBankValidateCodeRespondDict = respondDict[@"resps"][0];
                    }
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}

#define MYBLOCK_MK_OP(__A__) NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray]; \
	return [self sendRequest:jsonStr compeletionHandler:^{ \
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]]; \
	                if (suc) {__A__} \
	                [self exeResult:suc complete:compelteBlock error:errorBlock]; \
		} errorHandler:errorBlock];



- (MKNetworkOperation *)unbindBankcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock cardid:(NSString *)cardid {
    CHECK_PARA_STRING(cardid)
	NSDictionary *para = @{
		NET_KEY_visaid: cardid,
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};
	NSArray *nameArray = @[NET_FUNC_user_visa_unbinding_post, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray *paraArray = @[para, [self para_dict_me_USER_PROFILE_INFO_GET]];

	NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];
	return [self sendRequest:jsonStr compeletionHandler:^{
	                BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
	                if (suc) {
	                        ZAPP.myuser.unbindBankcardRespondDict = [self getDictWithIndex:0];
	                        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
			}
	                [self exeResult:suc complete:compelteBlock error:errorBlock];

		} errorHandler:errorBlock];
}
- (MKNetworkOperation *)getBankInfoWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock bankcode:(NSString *)bankcode {
    CHECK_PARA_STRING(bankcode)
	NSDictionary *para = @{
		NET_KEY_bankcode: bankcode
	};
	NSArray *nameArray = @[NET_FUNC_paymentway_bank_info_get, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray *paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];

    NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.bankInfoRespondDict = [self getDictWithIndex:0];
            ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
    
//	MYBLOCK_MK_OP()
}

/*
- (MKNetworkOperation *)applyLevelWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock level:(int)level {
	NSDictionary *para = @{
		NET_KEY_targetlevel: @(level),
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};
	NSDictionary *para2 = @{
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};
	NSArray *nameArray = @[NET_FUNC_user_identify_check_post, NET_FUNC_USER_IDENTIFY_RESULT_GET];
	NSArray *paraArray = @[para,para2];

	MYBLOCK_MK_OP(ZAPP.myuser.shenfenInfoDict = [self getDictWithIndex:1]; )
}*/

//////////  测试 新浪收银台
- (MKNetworkOperation *)sinaRechargeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock val:(NSString *)val {
    CHECK_PARA_STRING(val)
    NSDictionary *para = @{
                           NET_KEY_VALUE: [Util formatMoneyNumber:val],
//                           NET_KEY_visaid: visaid,
                           NET_KEY_USERID: [ZAPP.myuser getUserID]
                           };
    
    NSArray *nameArray = @[NET_FUNC_transfer_recharge_action_post];
    NSArray *paraArray = @[para];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"3.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.visaValidationCodeRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}
//////////  测试 新浪收银台
- (MKNetworkOperation *)sinaWithdrawWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock val:(NSString *)val {
    CHECK_PARA_STRING(val)
    NSDictionary *para = @{
                           NET_KEY_VALUE: [Util formatMoneyNumber:val],
                           //                           NET_KEY_visaid: visaid,
                           NET_KEY_USERID: [ZAPP.myuser getUserID]
                           };
    
    NSArray *nameArray = @[NET_FUNC_transfer_withdraw_action_post];
    NSArray *paraArray = @[para];
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"3.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.visaValidationCodeRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)sendChongzhiValidationCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock val:(NSString *)val visaid:(NSString *)visaid {
    CHECK_PARA_STRING(val)
    CHECK_PARA_STRING(visaid)
	NSDictionary *para = @{
		NET_KEY_VALUE: [Util formatMoneyNumber:val],
		NET_KEY_visaid: visaid,
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};

	NSArray *nameArray = @[NET_FUNC_transfer_recharge_action_post];
	NSArray *paraArray = @[para];

	//MYBLOCK_MK_OP(ZAPP.myuser.visaValidationCodeRespondDict = [self getDictWithIndex:0]; )
    NSString *jsonStr = [self jsonDictionaryWithSessionkey:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.visaValidationCodeRespondDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)checkChongzhiValidateWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value {
    CHECK_PARA_STRING(value)
    NSDictionary *para = @{
                           NET_KEY_ACTIONTYPE : @"1",
                           NET_KEY_USERID: [ZAPP.myuser getUserID],
                           NET_KEY_VAL:value
                           };
    
    NSArray *nameArray = @[@"transfer.constraint.check.get"];
    NSArray *paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0"]];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)checkChongzhiValidateCodeWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock orderno:(NSString *)orderno code:(NSString *)code {
    CHECK_PARA_STRING(orderno)
    CHECK_PARA_STRING(code)
	NSDictionary *para = @{
		NET_KEY_ORDERNO: orderno,
		NET_KEY_ACTIONTYPE : @"1",
		NET_KEY_VALIDATECODE:code
	};

	NSArray *nameArray = @[NET_FUNC_paymentway_validatecode_check_post, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray *paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];
	MYBLOCK_MK_OP(ZAPP.myuser.visaValidationCheckRespondDict = [self getDictWithIndex:0];
	              ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
	              )
}
- (MKNetworkOperation *)tixianValidateWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value {
    CHECK_PARA_STRING(value)
    
    NSDictionary *para = @{
                           NET_KEY_ACTIONTYPE : @"2",
                           NET_KEY_USERID: [ZAPP.myuser getUserID],
                           NET_KEY_VAL:value,
                           NET_KEY_cachedisabled  : @YES
                           };
    
    NSArray *nameArray = @[@"transfer.constraint.check.get"];
    NSArray *paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0"]];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)tixianWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value {
    CHECK_PARA_STRING(value)
	NSDictionary *para = @{
		NET_KEY_VALUE: [Util formatMoneyNumber:value],
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};

	NSArray *nameArray = @[NET_FUNC_transfer_withdraw_action_post, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray *paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];
	MYBLOCK_MK_OP(
	        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
	        )
}
- (MKNetworkOperation *)huankuanWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value debtid:(NSString *)debtid {
    CHECK_PARA_STRING(value)
    CHECK_PARA_STRING(debtid)
	NSDictionary *para = @{
		@"repayval": [Util formatMoneyNumber:value],
		@"debtid": debtid,
		NET_KEY_USERID:[ZAPP.myuser getUserID]
	};

	NSArray *nameArray = @[NET_FUNC_REPAYMENT_ORDER_ITEM_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray *paraArray = @[para, [self para_dict_USER_PROFILE_INFO_GET:[ZAPP.myuser getUserID]]];
	MYBLOCK_MK_OP(
	        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
	        )
}

- (MKNetworkOperation *)closeTheLoanWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock loanid:(NSString *)loanid {
    CHECK_PARA_STRING(loanid)
	NSDictionary *para = @{
		NET_KEY_ACTION: @"0",
		NET_KEY_LOANID: loanid,
		NET_KEY_USERID: [ZAPP.myuser getUserID]
	};

	NSArray *nameArray = @[NET_FUNC_loan_item_action_post];
	NSArray *paraArray = @[para];
	MYBLOCK_MK_OP(
	        )
}
// 投资
- (MKNetworkOperation *)investWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value loanid:(NSString *)loanid {
    CHECK_PARA_STRING(value)
    CHECK_PARA_STRING(loanid)
    NSDictionary *para =  @{ NET_KEY_ACTIONTYPE: @"0",
                             NET_KEY_LOANID: loanid,
                             NET_KEY_BETVAL: [Util formatMoneyNumber:value]
                             };
    
    
    NSArray *nameArray = @[NET_FUNC_BET_ORDER_ITEM_POST, NET_FUNC_USER_PROFILE_INFO_GET];
    NSArray *paraArray = @[para, [self para_dict_me_USER_PROFILE_INFO_GET]];
    MYBLOCK_MK_OP(
                  ZAPP.myuser.touziRespondDict = [self getDictWithIndex:0];
                  ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
                  )
}
- (MKNetworkOperation *)touziValidateWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value loanid:(NSString *)loanid{
    CHECK_PARA_STRING(value)
    CHECK_PARA_STRING(loanid)
//    CHECK_PARA_STRING(betid)
    NSDictionary *para;
//    if ([betid notEmpty]) {
        para = @{
                 NET_KEY_USERID: [ZAPP.myuser getUserID],
                 NET_KEY_LOANID: loanid,
                 NET_KEY_BETVAL: [Util formatMoneyNumber:value]
                 };
//    }
//    else {
//        para = @{
//                 NET_KEY_ACTIONTYPE: @"0",
//                 NET_KEY_LOANID: loanid,
//                 NET_KEY_BETVAL: [Util formatMoneyNumber:value]
//                 };
//    }
    
    
    NSArray *nameArray = @[@"bet.constraint.check.get"];
    NSArray *paraArray = @[para];
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0"]];
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {

        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
    
//    MYBLOCK_MK_OP(
//                  ZAPP.myuser.touziRespondDict = [self getDictWithIndex:0];
//                  )
}

- (MKNetworkOperation *)touziWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock value:(NSString *)value loanid:(NSString *)loanid betid:(NSString *)betid {
    CHECK_PARA_STRING(value)
    CHECK_PARA_STRING(loanid)
    CHECK_PARA_STRING(betid)
	NSDictionary *para;
	if ([betid notEmpty]) {
		para = @{
			NET_KEY_ACTIONTYPE: @"1",
			NET_KEY_LOANID: loanid,
			NET_KEY_BETID: betid,
			NET_KEY_BETVAL: [Util formatMoneyNumber:value]
		};
	}
	else {
		para = @{
			NET_KEY_ACTIONTYPE: @"0",
			NET_KEY_LOANID: loanid,
			NET_KEY_BETVAL: [Util formatMoneyNumber:value]
		};
	}


	NSArray *nameArray = @[NET_FUNC_BET_ORDER_ITEM_POST, NET_FUNC_USER_PROFILE_INFO_GET];
	NSArray *paraArray = @[para, [self para_dict_me_USER_PROFILE_INFO_GET]];
	MYBLOCK_MK_OP(
	        ZAPP.myuser.touziRespondDict = [self getDictWithIndex:0];
	        ZAPP.myuser.gerenInfoDict = [self getDictWithIndex:1];
	        )
}
- (MKNetworkOperation *)getBillDetailWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock noticeID:(NSString *)noticeid {
    CHECK_PARA_STRING(noticeid)
	NSDictionary *para = @{
		NET_KEY_NOTCEID: noticeid,
	};

	NSArray *nameArray = @[NET_FUNC_NOTICE_BILL_detail_GET];
	NSArray *paraArray = @[para];
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"2.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.billDetailDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
    } errorHandler:errorBlock];
}

- (MKNetworkOperation *)getInviteWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock page:(int)page pagesize:(int)pagesize {
	NSDictionary *para = @{
		NET_KEY_USERID: [ZAPP.myuser getUserID],
		NET_KEY_PAGENUM:@(page),
		NET_KEY_PAGESIZE:@(pagesize)
	};

	NSArray *nameArray = @[NET_FUNC_credit_user_invitelist_get];
	NSArray *paraArray = @[para];
	MYBLOCK_MK_OP(
	        ZAPP.myuser.inviteListDict = [self getDictWithIndex:0];
	        )
}

- (MKNetworkOperation *)getIdCardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
	NSDictionary *para = @{
		NET_KEY_USERID: [ZAPP.myuser getUserID],
		NET_KEY_identifytype:@"idcard",
	};

	NSArray *nameArray = @[NET_FUNC_USER_IDENTIFY_detail_GET];
	NSArray *paraArray = @[para];
	MYBLOCK_MK_OP(
	        ZAPP.myuser.identifyIdCardRespondDict = [self getDictWithIndex:0];
	        )
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

- (MKNetworkOperation *)checkUpdateInfo:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    NSDictionary *para = @{};
    NSArray * nameArray = @[@"system.appupdate.check.get"];
    NSArray * paraArray = @[para];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.versionUpdateInfoDict = [self getDictWithIndex:0];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

//
- (MKNetworkOperation *)getPaymentDate:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock{
    NSDictionary *para = @{};
    NSArray * nameArray = @[@"system.payment.date.get"];
    NSArray * paraArray = @[para];
    NSString *jsonStr   = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:nameArray parasArr:paraArray versionArr:@[@"1.0"]];
    
    return [self sendRequest:jsonStr compeletionHandler:^{
        BOOL suc = [self responseSucWithCount:(int)[nameArray count]];
        if (suc) {
            ZAPP.myuser.paymentDate = [self getDictWithIndex:0][@"date"];
        }
        [self exeResult:suc complete:compelteBlock error:errorBlock];
        
    } errorHandler:errorBlock];
}

- (void)addUMessageAlias{
    [ZAPP registerUMessagePush];
    
    if (ZAPP.myuser.gerenInfoDict) {
        
    //设置个推别名
        NSString *alias = ZAPP.myuser.gerenInfoDict[@"p2paccount"];
        [GeTuiSdk bindAlias:ZAPP.myuser.gerenInfoDict[@"p2paccount"] andSequenceNum:@"alias"];
        
//#ifdef TEST_TEST_SERVER
//        [GeTuiSdk bindAlias:@"Cashnice11809"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ZAPP.myuser.gerenInfoDict[@"p2paccount"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//#endif
        NSString *userrealname = ZAPP.myuser.gerenInfoDict[@"userrealname"];
        NSString *phone = ZAPP.myuser.gerenInfoDict[@"phone"];
        [Bugly setUserIdentifier:[NSString stringWithFormat:@"%@-%@", userrealname, phone]];
    }
 
    
    //设置友盟别名
//    [UMessage addAlias:ZAPP.myuser.gerenInfoDict[@"p2paccount"] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
#ifdef TEST_TEST_SERVER
//        if(responseObject)
//        {
//            [self showMessageAlert:@"绑定成功！"];
//        }
//        else
//        {
//            [self showMessageAlert:error.localizedDescription];
//        }
#endif
//    }];
}
- (void)showMessageAlert:(NSString *)message
{
    if([message length])
    {
        //处理前台消息框弹出
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification",@"Notification") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"showMessageAlert: Message is nil...[%@]",message);
    }
    
}

@end
