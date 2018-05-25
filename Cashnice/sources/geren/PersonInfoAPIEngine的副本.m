//
//  PersonInfoAPIEngine.m
//  Cashnice
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "PersonInfoAPIEngine.h"
#import "GetUserInfoEngine.h"
#import "SystemOptionsEngine.h"

@interface PersonInfoAPIEngine()
@property (strong, nonatomic) GetUserInfoEngine   *userInfoEngine;
@property (strong, nonatomic) SystemOptionsEngine *systemEngine;
@end

@implementation PersonInfoAPIEngine{
}

+(id)sharedInstance {
    
    static PersonInfoAPIEngine*sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

-(id)init{
    
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshUserInfo) name:KUSER_INFO_FRESH object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshBankInfo) name:KVISABANK_FRESH object:nil];

    return self;
}

-(void)uploadCardID:(UIImage *)image type:(NSInteger)type success:(void (^)())success
            failure:(void (^)())failure{
    
    if (!image) {
        return;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"card_%@.jpg",@(type)];

    WS(weakSelf)
    [ZAPP.netEngine uploadImageFromFile:fileName image:image completionHandler:^(NSDictionary* s){
        [weakSelf uploadCardIDUrl:s success:success failure:failure];
    } errorHandler:^{
        failure();
    }];
}

-(void)uploadCardIDUrl:(NSDictionary *)uploadDic
               success:(void (^)())success
               failure:(void (^)())failure{
    
    if (!uploadDic) {
        return;
    }
    
    [ZAPP.netEngine commitIdcardWithComplete:^{
        NSLog(@"commitIdcardWithComplete ok");
        if(success){
            success();
        }
    }error:^{
        if (failure) {
            failure();
        }
    } realname:@"" idnumber:@"" attach:uploadDic];
}

-(void)uploadHeaderImage:(UIImage *)image success:(void (^)(NSString *))success{
    
    WS(weakSelf)

    [ZAPP.netEngine uploadImageFromFile:@"head.jpg" image:image completionHandler:^(NSDictionary* s){
        
        if (s != nil) {
            NSString * url = EMPTYSTRING_HANDLE(s[NET_KEY_URL]);
            if ([url length]) {
                [weakSelf uploadHeaderUrl:url complete:^(BOOL suc) {
                    if (suc) {
                        if (success) {
                            success(url);
                        }
                    }else{
                        if (success) {
                            success(nil);
                        }
                    }
                }];
                
                return ;
            }
        }
                
        if (success) {
            success(nil);
        }
        
    } errorHandler:^{
        if (success) {
            success(nil);
        }
    }];
    
}


-(void)uploadHeaderUrl:(NSString *)headerUrl
               complete:(void (^)(BOOL))success{
    
    if ([headerUrl length] == 0) {
        return;
    }
    
    [ZAPP.netEngine postHeadUrlWithComplete:^{
        if (success) {
            success(YES);
        }
    } error:^{
        if (success) {
            success(NO);
        }
    }
    headrul:headerUrl];
    
}

-(void)getUserIdentifyResult:(NSString *)userId
                     success:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSString *error))failure{
    
    if (!userId) {
        return;
    }
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    [parms setObject:userId forKey:NET_KEY_USERID];
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:NET_FUNC_USER_IDENTIFY_RESULT_GET
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   
                   NSMutableDictionary *mdic = @{}.mutableCopy;
                   NSArray *items = EMPTYOBJ_HANDLE(resp[@"items"]);
                   for(NSDictionary *dic in items){
                       [mdic setObject:dic forKey:dic[@"itemtype"]];
                   }
                   
                   success([mdic copy]);
                   
                   
                   
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
    
    
    
    
}

-(void)setUserIdentityCompany:(NSString *)company
                      address:(NSString *)address
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure{
    [self setUserIdentityCompany:company job:@"" address:address positions:@[] explain:@"" success:success failure:failure];
}

-(void)setUserIdentityJob:(NSString *)job
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure{
    [self setUserIdentityCompany:@"" job:job address:@"" positions:@[] explain:@"" success:success failure:failure];
}

-(void)setUserIdentityAddress:(NSString *)address
                  success:(void (^)())success
                  failure:(void (^)(NSString *error))failure{
    [self setUserIdentityCompany:@"" job:@"" address:address positions:@[] explain:@"" success:success failure:failure];
}

-(void)setUserIdentityPositions:(NSArray *)positions
                      explain:(NSString *)explain
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure{
    [self setUserIdentityCompany:@"" job:@"" address:@"" positions:positions explain:explain success:success failure:failure];
}

-(void)setUserIdentityCompany:(NSString *)company
                          job:(NSString *)job
                      address:(NSString *)address
                      success:(void (^)())success
                      failure:(void (^)(NSString *error))failure{
    [self setUserIdentityCompany:company job:job address:address positions:@[] explain:@"" success:success failure:failure];
}

-(void)setUserIdentityCompany:(NSString *)company
                          job:(NSString *)job
                      address:(NSString *)address
                    positions:(NSArray *)positions
                      explain:(NSString *)explain
                      success:(void (^)())success
                  failure:(void (^)(NSString *error))failure{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:[ZAPP.myuser getUserID] forKey:NET_KEY_USERID];
    [para setObject:@"2" forKey:NET_KEY_targetlevel];
    
    NSMutableArray *contentArray = [@[] mutableCopy];
    if ([company notEmpty]) {
        NSMutableDictionary *detail1 = [NSMutableDictionary dictionary];
        [detail1 setObject:company forKey:NET_KEY_itemvalue];
        [detail1 setObject:NET_KEY_ORGANIZATION forKey:NET_KEY_itemtype];
        
        [contentArray addObject:detail1];
    }
    
    if ([job notEmpty]) {
        NSMutableDictionary *detail2 = [NSMutableDictionary dictionary];
        [detail2 setObject:job forKey:NET_KEY_itemvalue];
        [detail2 setObject:NET_KEY_JOB forKey:NET_KEY_itemtype];
        
        [contentArray addObject:detail2];
    }
    
    if([address notEmpty]){
        NSMutableDictionary *detail3 = [NSMutableDictionary dictionary];
        [detail3 setObject:address forKey:NET_KEY_itemvalue];
        [detail3 setObject:NET_KEY_ADDRESS forKey:NET_KEY_itemtype];
        
        [contentArray addObject:detail3];
    }
    
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
    
    [self sendHttpRequest:para pathName:NET_FUNC_USER_IDENTIFY_action_post version:@"3.0" compeletionHandler:^{
        NSDictionary*resp = [self getDictWithIndex:0];
        if (resp) {
            //identifyid = 5289;
            if(success){
                success();
            }
        }
    } errorHandler:^{
        if(failure){
            failure(errMsg);
        }
    }];
    
}

- (void)checkBankValidateCode:(NSString *)code
                        orderNo:(NSString *)orderNo
                        success:(void (^)())success
                        failure:(void (^)(NSString *error))failure {
    
    NSDictionary *para = @{
                           NET_KEY_ORDERNO: orderNo,
                           NET_KEY_ACTIONTYPE : @"0",
                           NET_KEY_VALIDATECODE:code
                           };
    
    [self sendHttpRequest:para pathName:NET_FUNC_paymentway_validatecode_check_post
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   
                   success();
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
}


- (void)bindBankCommitName:(NSString *)name
                  idnumber:(NSString *)idnumber
                   success:(void (^)())success
                   failure:(void (^)(NSString *error))failure {
    
   	NSDictionary *para = @{
                           @"realname":name,
                           NET_KEY_IDNUMBER:idnumber,
                           NET_KEY_USERID : [ZAPP.myuser getUserID]
                           };
    
    [self sendHttpRequest:para pathName:@"user.info.identify.post"
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   
                   success();
               }
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
}

//NET_FUNC_system_options_list_get
-(void)getSystemSocietyPositionSuccess:(void (^)(NSDictionary *))success
                               failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parms = @{@"optionid" : @(3)};
    
    [self sendHttpRequest:parms
                 pathName:NET_FUNC_system_options_list_get
                  version:@"2.0"
       compeletionHandler:^{
           ZAPP.myuser.systemOptionsDictShehuiZhiwu = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           
           if(success){
               
               success(EMPTYOBJ_HANDLE([self getDictWithIndex:0]));
               
           }else{
               if(success){
                   success(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               failure(errMsg);
           }
       }];
}

-(void)freshUserInfo{
    
    WS(weakSelf)
    
    [self.userInfoEngine getUserInfoSuccess:^{
        
        if (weakSelf.userInfoFreshBlock) {
            weakSelf.userInfoFreshBlock();
        }
        
    } failure:^(NSString *error) {
        
    }];
}


-(void)freshBankInfo{
    
    WS(weakSelf)
    
    [self.systemEngine getVISASuccess:^{
        
        if (weakSelf.visaFreshBlock) {
            weakSelf.visaFreshBlock();
        }
        
    } failure:^(NSString *error) {
        
    }];
}


-(GetUserInfoEngine *)userInfoEngine{
    
    if (!_userInfoEngine) {
        _userInfoEngine = [[GetUserInfoEngine alloc]init];
    }
    return _userInfoEngine;
}

-(SystemOptionsEngine *)systemEngine{
    
    if (!_systemEngine) {
        _systemEngine = [[SystemOptionsEngine alloc]init];
    }
    return _systemEngine;
}



-(void)reset{
         [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [self reset];
}

@end
