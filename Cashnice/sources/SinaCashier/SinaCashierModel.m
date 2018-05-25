//
//  SinaCashierModel.m
//  Cashnice
//
//  Created by a on 16/8/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SinaCashierModel.h"
#import "SinaCashierNetEngine.h"
#import "Base64EncoderDecoder.h"
#import "zlib.h"

@interface SinaCashierModel ()
@property (nonatomic, strong) SinaCashierNetEngine *netEngine;
@end

@implementation SinaCashierModel

////设置密码
- (void)setPayPasswordWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                          failure:(void (^)(NSString * error))failure {
    return [self sinaProfileWithType:@"setPayPassword" success:success failure:failure];
}

////修改密码
- (void)modifyPayPasswordWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                          failure:(void (^)(NSString * error))failure {
    return [self sinaProfileWithType:@"modifyPayPassword" success:success failure:failure];
}

////找回密码
- (void)findPayPasswordWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                           failure:(void (^)(NSString * error))failure{
    return [self sinaProfileWithType:@"findPayPassword" success:success failure:failure];
}

////我的银行卡管理
- (void)bankCardManagementWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                              failure:(void (^)(NSString * error))failure{
    return [self sinaProfileWithType:@"myBankCard" success:success failure:failure];
}

////修改绑定的手机号
- (void)modifyVerifyMobileWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                              failure:(void (^)(NSString * error))failure{
    return [self sinaProfileWithType:@"modifyVerifyMobile" success:success failure:failure];
}

////找回绑定手机号
- (void)findVerifyMobileWithsuccess:(void (^)(NSString * URL, NSData *Content))success
                              failure:(void (^)(NSString * error))failure{
    return [self sinaProfileWithType:@"findVerifyMobile" success:success failure:failure];
}

////是否设置密码
- (void)queryIsSetPayPasswordWithsuccess:(void (^)(BOOL isSetPayPassword))success
                              failure:(void (^)(NSString * error))failure{
    NSDictionary *param = @{
                            NET_KEY_OPERATE: @"queryIsSetPayPassword",
                            NET_KEY_USERID : [ZAPP.myuser getUserID]
                            };
    
    return [self.netEngine doAction:param path:@"sina.cashier.info.post" success:^(NSDictionary *response) {
        
        NSInteger redirect = [response[@"redirect"] integerValue];
        if (0 == redirect) {
            //raw data of integer
            BOOL isSetPayPassword = [response[@"content"] integerValue];
            
            if (success) {
                success(isSetPayPassword);
            }
        }
        
    } failure:^(NSString *error) {
        failure(error);
    }];
}

- (void)sinaProfileWithType:(NSString *)operation
                    success:(void (^)(NSString * URL, NSData *Content))success
                    failure:(void (^)(NSString * error))failure {
    
    NSDictionary *param = @{
                            NET_KEY_OPERATE: operation,
                            NET_KEY_USERID : [ZAPP.myuser getUserID]
                            };
    
    [self.netEngine doAction:param path:@"sina.cashier.info.post" success:^(NSDictionary *response) {
        
        NSInteger redirect = [response[@"redirect"] integerValue];
        if (1 == redirect) {
            //content contains a URL
            NSString *content = response[@"content"];
            if (content.length > 0 && success) {
                success(content, nil);
            }
            
        }else{
            //raw data of integer
            
            
            //ziped content contains the html
            NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
            
            if (contentData && success) {
                success(nil, contentData);
            }
        }
        

    } failure:^(NSString *error) {
        [Util toast:net_error_msg];
        failure(error);
    }];
}

////投资
-(void)investAction:(NSString *)value
             loanId:(NSString *)loanId
             couId:(NSString *)couId
              bicid:(NSString *)bicid
            success:(void (^)(NSData *contentData))success
            failure:(void (^)(NSDictionary *error))failure {
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                            NET_KEY_BETVAL: [Util formatMoneyNumber:value],
                            NET_KEY_LOANID : loanId,
                            NET_KEY_USERID: [ZAPP.myuser getUserID],
                            NET_KEY_ACTIONTYPE : @0,
                            @"couid"    :   couId,
                            @"bicid"    :   bicid
                            };
    
    
    [self.netEngine doActionWithResponse:param path:NET_FUNC_BET_ORDER_ITEM_POST success:^(NSDictionary *response) {
        
        NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSDictionary *error) {
        [Util toast:net_error_msg];
        failure([error copy]);
    }];
}

////还款
-(void)repaymentAction:(NSString *)value
                loanId:(NSString *)loanId
               success:(void (^)(NSData *contentData, NSString *contentString))success
               failure:(void (^)(NSString *error))failure {
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                            NET_KEY_REPAYVALUE: [Util formatMoneyNumber:value],
                            @"debtid" : loanId,
                            NET_KEY_USERID: [ZAPP.myuser getUserID],
                            NET_KEY_ACTIONTYPE : @0
                            };
    
    [self.netEngine doAction:param path:NET_FUNC_REPAYMENT_ORDER_ITEM_POST success:^(NSDictionary *response) {
        NSNumber *redirect = response[@"redirect"];
        if (![redirect isKindOfClass:[NSNull class]] && (1 == [redirect integerValue])) {
           
            //新浪未授权
            NSString *content = response[@"content"];
            if (content && success) {
                success(nil, content);
            }
            
        }else{
            NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
            if (contentData && success) {
                success(contentData, nil);
            }
        }
        
    } failure:^(NSString *error) {
        [Util toast:net_error_msg];
        failure(error);
    }];
}


////支付担保金
-(void)guaranteeAction:(NSString *)value
                loanId:(NSString *)loanId
               success:(void (^)(NSData *contentData))success
               failure:(void (^)(NSString *error))failure {
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                            NET_KEY_REPAYVALUE: [Util formatMoneyNumber:value],
                            @"ulw_id" : loanId,
                            NET_KEY_USERID: [ZAPP.myuser getUserID],
                            //NET_KEY_ACTIONTYPE : @0,
                            NET_KEY_API_VERSION : @"1.0"
                            };
    
    [self.netEngine doAction:param path:NET_FUNC_REPAYMENT_GUARANTEE_POST success:^(NSDictionary *response) {
        
        NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSString *error) {
        [Util toast:net_error_msg];
        failure(error);
    }];
}

////充值
- (void)recharge:(NSString *)value
         success:(void (^)(NSData *contentData))success
         failure:(void (^)(NSString *))failure {
    
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                            NET_KEY_VALUE: [Util formatMoneyNumber:value],
                            NET_KEY_USERID: [ZAPP.myuser getUserID]
                            };
    
    [self.netEngine doAction:param path:NET_FUNC_transfer_recharge_action_post success:^(NSDictionary *response) {
        
        NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSString *error) {
        [Util toast:net_error_msg];
        failure(error);
    }];
}


////体现
- (void)withdraw:(NSString *)value
         success:(void (^)(NSData *contentData))success
         failure:(void (^)(NSString *))failure {
    
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                           NET_KEY_VALUE: [Util formatMoneyNumber:value],
                           NET_KEY_USERID: [ZAPP.myuser getUserID]
                           };
    
    [self.netEngine doAction:param path:NET_FUNC_transfer_withdraw_action_post success:^(NSDictionary *response) {
        
        NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSString *error) {
        [Util toast:net_error_msg];
        failure(error);
    }];
    
//    [ZAPP.netEngine sinaWithdrawWithComplete:^{
//        NSDictionary *response = ZAPP.myuser.visaValidationCodeRespondDict;
//        NSString *content = response[@"content"];
//        NSLog(@"%@", content);
//    } error:^{
//        ;
//    } val:@"1"];
}

////转账
- (void)transfer:(NSString *)value
          target:(NSString *)targetUserId
         comment:(NSString *)comment
         success:(void (^)(NSData *contentData))success
         failure:(void (^)(NSString *))failure {
    
    //参数检查，参数不正确返回failure()
    NSDictionary *param = @{
                            @"money"    : [Util formatMoneyNumber:value],
                            @"userid"   : targetUserId,
                            @"comment"  : comment
                            };
    
    [self.netEngine doAction:param path:NET_FUNC_user_transfer_action_post success:^(NSDictionary *response) {
        
        NSData *contentData = [self getUnzipedContentFrom:response withKey:@"content"];
        if (contentData && success) {
            success(contentData);
        }
    } failure:^(NSString *error) {
        [Util toast:net_error_msg];
        failure(error);
    }];
}

- (NSData *)getUnzipedContentFrom:(NSDictionary *)dictionary withKey:(NSString *)contentKey{
    
    if (! dictionary) {
        return nil;
    }
    
    NSString *content = dictionary[contentKey];
    if (content && ![[content class] isSubclassOfClass:[NSNull class]] && content.length  > 0) {
        NSData *decodedData = [Base64EncoderDecoder base64Decode:content];
        NSData *unzipedData = [[self class] ungzipData:decodedData];
        return unzipedData;
    }else{
        return nil;
    }
}


- (SinaCashierNetEngine *)netEngine{
    if (! _netEngine) {
        _netEngine = [[SinaCashierNetEngine alloc] init];
    }
    return _netEngine;
}

+ (NSData *)ungzipData:(NSData *)compressedData
{
    if ([compressedData length] == 0)
        return compressedData;
    
    NSUInteger full_length = [compressedData length];
    NSUInteger half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    
    if (inflateEnd (&strm) != Z_OK)
        return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    return nil;
}

@end
