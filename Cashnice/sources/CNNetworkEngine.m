//
//  CNNetworkEngine.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"
#import "UtilDevice.h"
#import "CustomReloginAlertView.h"
#import <SDWebImageCompat.h>
#import <PINCache.h>
#import "CNNetworkSuccHandle.h"
#import <AFNetworking.h>
#import "AFgzipRequestSerializer.h"

@implementation CNNetworkEngine{

    NSString *_jsonString;
    AFHTTPSessionManager *manager;
    //NSDictionary *respondDict;
}

-(id)init{
    
    self = [super  init];
    _closeAutoCache = YES;
    return self;
}

-(void)dealloc{
    [self cancleAllHttpRequest];
}
//
//-(BOOL)closeAutoCache{
//    return YES;
//}

- (NSString *)jsonDictionaryWithSessionkeyAndVersion:(NSString *)sessionkey uid:(int)uid namesArr:(NSArray *)namesArr parasArr:(NSArray *)parasArr versionArr:(NSArray *)verArr {
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:[NSNumber numberWithInteger:[namesArr count]] forKey:NET_KEY_COUNT];
    [jsonDict setObject:sessionkey forKey:NET_KEY_SESSIONKEY];
    [jsonDict setObject:[Util appVersion] forKey:NET_KEY_VERSIONKEY];
    [jsonDict setObject:[UtilDevice getDeviceMode] forKey:NET_KEY_MODEL];
    [jsonDict setObject:[UtilDevice getDeviceSystem] forKey:NET_KEY_SYSTEM];
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
        
        if(i<verArr.count){
            [dict setObject:[verArr objectAtIndex:i] forKey:NET_KEY_VERSION];
        }
        
        if(i<parasArr.count){
            [dict setObject:[parasArr objectAtIndex:i] forKey:NET_KEY_PARAMS];
        }
        
        if(i<namesArr.count){
            [dict setObject:[namesArr objectAtIndex:i] forKey:NET_KEY_NAME];
        }
        [reqArray addObject:dict];
    }
    [jsonDict setObject:reqArray forKey:NET_KEY_REQS];
    return [jsonDict jsonEncodedKeyValueString];
}


-(NSURLSessionDataTask *)sendHttpRequest:(NSDictionary *)params
                                pathName:(NSString*)pathName
                                 version:(NSString*)version
                      compeletionHandler:(NetResponseBlock)completionBlock
                            errorHandler:(NetErrorBlock)errorBlock{
    
    NSAssert(pathName, @"pathName cannot nil");
    
    if(![UtilDevice isNetworkConnected]){
        NSLog(@"net work failed");
        if(errorBlock){
            errorBlock();
        }
        return nil;
    }
    
    NSString *jsonStr = [self jsonDictionaryWithSessionkeyAndVersion:[ZAPP.zlogin getSessionKey] uid:[ZAPP.myuser getUserIDInt] namesArr:@[pathName] parasArr:params?@[params]:nil versionArr:@[version]];
    
    
    NetResponseBlock handleSucBlock = ^(){
        
        if (completionBlock) {
            completionBlock();
        }
        
    };
    
    _jsonString = [jsonStr copy];
    
    respondDict = nil;
    
    NSURLSessionDataTask *operation = nil;
    if ([pathName rangeOfString:@".post"].location != NSNotFound) {
        
        operation = [self sendAFPost:jsonStr compeletionHandler:handleSucBlock errorHandler:errorBlock?errorBlock:nil];
        
    }else{
        
        operation = [self sendAFGet:jsonStr compeletionHandler:handleSucBlock errorHandler:errorBlock?errorBlock:nil];
    }
    
    return operation;
    
}

-(NSURLSessionDataTask *)sendHttpRequest:(NSDictionary *)params
                                pathName:(NSString*)pathName
                      compeletionHandler:(NetResponseBlock)completionBlock
                            errorHandler:(NetErrorBlock)errorBlock {
    return [self sendHttpRequest:params pathName:pathName version:@"1.0" compeletionHandler:completionBlock errorHandler:errorBlock];
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


-(void)cancleHttpPath:(NSString *)path{
    
    [[self class] cancelOperationsContainingURLString:path];
}

-(void)cancleAllHttpRequest{
    
    [manager invalidateSessionCancelingTasks:YES];
    manager = nil;
    
    //    if (afSessionTasks) {
    //        [afSessionTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *taskObj, NSUInteger idx, BOOL *stop) {
    //            [taskObj cancel];
    //        }];
    //    }
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


-(BOOL)cacheAvailable:(NSString *)jsonString{
    
    if (NetworkOperationCacheDisable || ![self needCacheHandle:jsonString]){
        return NO;
    }
    
    if (self.closeAutoCache) {
        return NO;
    }
    
    return YES;
}

//#pragma mark - Getter
//
//-(NSString *)errMsg{
//    return netHandle.errMsg;
//}

#pragma mark - 重写并优化原父类代码

/*
 - (MKNetworkOperation *)sendPost:(NSString *)jsonString
 compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
 
 __weak CNNetworkEngine   *weakSelf = self;
 
 MKNetworkOperation *op = [self operationWithPath:YQS_API_POST_PATH params:YQS_API_POST_BODY(jsonString) httpMethod:@"POST" ssl:USESSL];
 [op addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
 [weakSelf generalCompleteBlock:completedOperation];
 if (! respondDict) {
 [Util toast:net_error_msg];
 if (ZNOTNULL(errorBlock)) {
 errorBlock();
 }
 }
 if (ZNOTNULL(completionBlock)) {
 completionBlock();
 }
 } errorHandler: ^(MKNetworkOperation *errorOp, NSError *error) {
 [weakSelf generalErrorBlock:errorOp error:error];
 if (ZNOTNULL(errorBlock)) {
 [Util toast:net_error_msg];
 errorBlock();
 }
 }];
 
 [self enqueueOperation:op];
 
 return op;
 }
 
 */

-(NSArray *)requestArr:(NSString *)jsonString{
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *reqArr = dict[@"reqs"];
    return reqArr;
}


- (NSURLSessionDataTask *)sendAFPost:(NSString *)jsonString
                  compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
    __weak CNNetworkEngine   *weakSelf = self;
    
    NSArray *reqArr = [self requestArr:jsonString];
    
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    
    CNNetworkSuccHandle *netHandle  = [[CNNetworkSuccHandle alloc]init];

    
    NSURLSessionDataTask *task = [manager POST:[self postUrl] parameters:       YQS_API_POST_BODY(jsonString)
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          
                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                          __strong __typeof(self) strongSelf = weakSelf;
                                          if (!strongSelf)return ;
                                          
                                          strongSelf->respondDict = responseObject;
#ifdef TEST_ENABLE_SERVER_LOG
                                          [UtilLog dict:strongSelf->respondDict];
#endif
                                          
                                          //记录错误码
                                          strongSelf->errCode = [[respondDict objectForKey:NET_KEY_RESULT]integerValue];
                                          
                                          //处理1020错误消息
                                          if ([netHandle needHandleSystemError:strongSelf->respondDict]) {
                                              
                                              [netHandle responseSucWithCount:(int)[reqArr count] responseDict:strongSelf->respondDict];
                                              
                                              [Util noticeServiceErrorWithMessage:netHandle.errMsg];
                                              
                                              //            [Util noticeServiceError];
                                              if (ZNOTNULL(errorBlock)) {
                                                  dispatch_main_sync_safe(errorBlock)
                                              }
                                              
                                              return ;
                                          }
                                          
                                          if (strongSelf->respondDict && ZNOTNULL(completionBlock)) {
                                              
                                              if ([netHandle needHandleLoginExp:strongSelf->respondDict]) {
                                                  
                                                  return ;
                                              }
                                              [netHandle responseSucWithCount:(int)[reqArr count] responseDict:strongSelf->respondDict];
                                              
                                              //错误
                                              if (netHandle.errMsg && [netHandle.errMsg length]>0) {
                                                  strongSelf->errMsg = netHandle.errMsg;
                                                  if (!self.closeErrToast) {
                                                      [Util toast:strongSelf->errMsg];
                                                  }
                                                  if (ZNOTNULL(errorBlock)) {
                                                      dispatch_main_sync_safe(errorBlock)
                                                      return;
                                                      
                                                  }
                                                  
                                              }
                                              
                                              if (netHandle.succ) {
                                                  [Util noticeServiceRecoveryMessage];
                                                  dispatch_main_sync_safe(completionBlock)
                                              }
                                          }else{
                                              if (!self.closeErrToast) {
                                                  [Util toast:net_error_msg];
                                              }
                                              if (ZNOTNULL(errorBlock)) {
                                                  dispatch_main_sync_safe(errorBlock)
                                              }
                                              
                                          }
                                          
                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          
                                          [self errorCodeHandle:error];
                                          
                                          if (ZNOTNULL(errorBlock)) {
                                              dispatch_main_sync_safe(errorBlock)
                                          }
                                          
                                      }];
    
    
    return task;
    
}

-(void)errorCodeHandle:(NSError *)error{
    
    if ([error code] == -1001) {
        if (!self.closeErrToast) {
            
            [Util toastStringOfLocalizedKey:@"tip.connectionToServerTimedOut"];
        }
    }else if ([error code] == -999) {
        NSLog(@"cancle.......");
    }else{
        if (!self.closeErrToast) {
            
            //[Util toast:net_error_msg];
            [Util toastExceptTopView:net_error_msg];
        }
    }
    
}


/*
 - (MKNetworkOperation *)sendGet:(NSString *)jsonString
 compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
 
 DLog()
 
 MKNetworkOperation *op = [self operationWithPath:YQS_API_GET(jsonString) params:nil httpMethod:@"GET" ssl:USESSL];
 
 __weak CNNetworkEngine      *weakSelf = self;
 
 //error handle block
 MKNKResponseErrorBlock  responseErrorBlock = ^(MKNetworkOperation* completedOperation, NSError* error){
 
 __strong __typeof(self) strongSelf = weakSelf;
 
 [strongSelf generalErrorBlock:completedOperation error:error];
 [Util toast:net_error_msg];
 if (ZNOTNULL(errorBlock)) {
 
 dispatch_main_sync_safe(errorBlock)
 
 }
 };
 
 NSArray *reqArr = [self requestArr:jsonString];
 NSString *key = [self cacheKey:jsonString];
 
 //succ handle block
 MKNKResponseBlock responseBlock = ^(MKNetworkOperation* completedOperation){
 __strong __typeof(self) strongSelf = weakSelf;
 
 [strongSelf generalCompleteBlock:completedOperation];
 
 if (respondDict && ZNOTNULL(completionBlock)) {
 
 if ([netHandle needHandleLoginExp:respondDict]) {
 return ;
 }
 
 [netHandle responseSucWithCount:(int)[reqArr count] responseDict:respondDict];
 if (netHandle.errMsg && [netHandle.errMsg length]>0) {
 errMsg = netHandle.errMsg;
 }
 
 if (netHandle.succ) {
 if ([self cacheAvailable:jsonString]) {
 /// Set Cache
 [[PINCache sharedCache]setObject:respondDict forKey:key];
 }
 }
 
 dispatch_main_sync_safe(completionBlock)
 
 }else{
 [Util toast:net_error_msg];
 if (ZNOTNULL(errorBlock)) {
 dispatch_main_sync_safe(errorBlock)
 }
 
 }
 
 
 };
 
 
 // cache closed
 if (![self cacheAvailable:jsonString])
 {
 [op addCompletionHandler:responseBlock
 errorHandler:responseErrorBlock];
 [self enqueueOperation:op];
 }
 else{
 //Cache!!
 
 __weak CNNetworkEngine      *weakSelf = self;
 
 [self getCacheIfExisted:jsonString complete:^(id cacheObject) {
 
 //cache existed
 if (cacheObject) {
 NSDictionary *cachedData = (NSDictionary *)cacheObject;
 if (cachedData) {
 if (ZNOTNULL(completionBlock)) {
 respondDict = cachedData;
 dispatch_main_sync_safe(completionBlock)
 
 }
 }
 }
 
 //then ,request net
 [op addCompletionHandler: responseBlock
 errorHandler: responseErrorBlock];
 [weakSelf enqueueOperation:op];
 }];
 
 
 
 }
 
 return op;
 }
 */


- (NSURLSessionDataTask *)sendAFGet:(NSString *)jsonString
                 compeletionHandler:(NetResponseBlock)completionBlock errorHandler:(NetErrorBlock)errorBlock {
    
    __weak CNNetworkEngine      *weakSelf = self;
    
    //find cache if possible
    if ([self cacheAvailable:jsonString])
    {
        [self getCacheIfExisted:jsonString complete:^(id cacheObject) {
            
            //cache existed
            if (cacheObject) {
                NSDictionary *cachedData = (NSDictionary *)cacheObject;
                if (cachedData) {
                    if (ZNOTNULL(completionBlock)) {
                        respondDict = cachedData;
                        dispatch_main_sync_safe(completionBlock)
                        
                    }
                }
            }
            
            
        }];
    }
    
    NSArray *reqArr = [self requestArr:jsonString];
    NSString *key = [self cacheKey:jsonString];
    
    //afnetwork默认是已支持gzip
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    
    CNNetworkSuccHandle *netHandle  = [[CNNetworkSuccHandle alloc]init];
    
    NSURLSessionDataTask *task = [manager GET:[self getUrl] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (!strongSelf)return ;
        
        
        strongSelf->respondDict = responseObject;
#ifdef TEST_ENABLE_SERVER_LOG
        [UtilLog dict:strongSelf->respondDict];
#endif
       
        //记录错误码
        strongSelf->errCode = [[respondDict objectForKey:NET_KEY_RESULT]integerValue];
            
        //处理1020错误消息
        if ([netHandle needHandleSystemError:strongSelf->respondDict]) {
            
            [netHandle responseSucWithCount:(int)[reqArr count] responseDict:strongSelf->respondDict];
             ;

            [Util noticeServiceErrorWithMessage:netHandle.errMsg];
            
            if (ZNOTNULL(errorBlock)) {
                dispatch_main_sync_safe(errorBlock)
            }
            
            return ;
        }
        
        
        if (strongSelf->respondDict && ZNOTNULL(completionBlock)) {
            
            //是否需要重新登录
            if ([netHandle needHandleLoginExp:strongSelf->respondDict]) {
                
                return ;
            }
            
            [netHandle responseSucWithCount:(int)[reqArr count] responseDict:strongSelf->respondDict];
            
            //错误
            if (netHandle.errMsg && [netHandle.errMsg length]>0) {
                strongSelf->errMsg = netHandle.errMsg;
                
                if (!self.closeErrToast) {
                    [Util toast:strongSelf->errMsg];
                }
                if (ZNOTNULL(errorBlock)) {
                    dispatch_main_sync_safe(errorBlock)
                    return;
                }
            }
            
            if (netHandle.succ) {
                if ([self cacheAvailable:jsonString]) {
                    /// Set Cache
                    [[PINCache sharedCache]setObject:strongSelf->respondDict forKey:key];
                }
            }
            
            [Util noticeServiceRecoveryMessage];
            
            dispatch_main_sync_safe(completionBlock)
        }else{
            if (!self.closeErrToast) {
                
                [Util toast:net_error_msg];
            }
            if (ZNOTNULL(errorBlock)) {
                dispatch_main_sync_safe(errorBlock)
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self errorCodeHandle:error];
        
        if (ZNOTNULL(errorBlock)) {
            dispatch_main_sync_safe(errorBlock)
        }
        
    }];
    
    return task;
    
}

-(NSString *)getUrl{
    
    NSString *httpPrefix = @"";
    if (USESSL) {
        httpPrefix = @"https://";
    }else{
        httpPrefix = @"http://";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [YQS_SERVER_URL rangeOfString:httpPrefix].location == NSNotFound?httpPrefix:@"", YQS_SERVER_URL, YQS_API_GET(_jsonString)];
    
    return url;
}


-(NSString *)postUrl{
    
    NSString *httpPrefix = @"";
    if (USESSL) {
        httpPrefix = @"https://";
    }else{
        httpPrefix = @"http://";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [YQS_SERVER_URL rangeOfString:httpPrefix].location == NSNotFound?httpPrefix:@"", YQS_SERVER_URL, YQS_API_POST_PATH];
    
    return url;
}

#pragma mark - Cache Handle

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
        key = [key stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)uid]];
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

@end
