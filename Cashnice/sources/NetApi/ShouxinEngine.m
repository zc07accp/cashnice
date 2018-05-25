//
//  FriendEngine.m
//  Cashnice
//
//  Created by apple on 2016/10/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ShouxinEngine.h"
#import <PINCache.h>
//#import "ContactHelper.h"
#import "IOU.h"
#import "WZChineseToPhonetic.h"

@interface ShouxinEngine()
{
    NSInteger _type;
    NSString *_userID;
}

@end

@implementation ShouxinEngine


-(void)getSearchCNContacts:(NSDictionary *)parms
                   success:(void (^)(NSArray *users))success
                   failure:(void (^)(NSString *error))failure
{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_SEARCHCONTANCT
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               if(success){
                   success([self reformListResultAddPinyin:resp[@"users"]]);
                   
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

+(void)requestStoreShouxinToMe{
    
    ShouxinEngine *engine = [[ShouxinEngine alloc]init];
    [engine getShouxin:0 pageSize:INT_MAX shouxinType:6 userID:[ZAPP.myuser getUserID] success:^(NSArray *arr) {
        
    } failure:^(NSString *error) {
        
    }];
}

-(void)getShouxin:(NSInteger)page
         pageSize:(NSInteger)pageSize
      shouxinType:(NSInteger)type
           userID:(NSString *)userID
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSString *error))failure{
    
    if (!userID) {
        return;
    }
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    
    [parms setObject:@(type) forKey:NET_KEY_QUERYTYPE];
    [parms setObject:userID forKey:NET_KEY_USERID];
    [parms setObject:@(page) forKey:NET_KEY_PAGENUM];
    [parms setObject:@(pageSize) forKey:NET_KEY_PAGESIZE];
    
    _type = type;
    _userID = userID;
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:NET_FUNC_CREDIT_USER_LIST_GET
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   
                   NSArray *creditusers = EMPTYOBJ_HANDLE(resp[@"creditusers"]);
                   [self storeShouXinList:creditusers];
                   success([self reformListResultAddPinyin:creditusers]);
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


-(void)getMightKnown:(NSInteger)page
         pageSize:(NSInteger)pageSize
           userID:(NSString *)userID
          success:(void (^)(NSDictionary *mightKnownDict))success
          failure:(void (^)(NSString *error))failure{
    
    if (!userID) {
        return;
    }
    
    NSMutableDictionary *parms = @{}.mutableCopy;
    
    [parms setObject:@(5) forKey:NET_KEY_QUERYTYPE];
    [parms setObject:userID forKey:NET_KEY_USERID];
    [parms setObject:@(page) forKey:NET_KEY_PAGENUM];
    [parms setObject:@(pageSize) forKey:NET_KEY_PAGESIZE];
    
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:NET_FUNC_CREDIT_USER_LIST_GET
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               if(success){
                   success(resp);
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


-(NSString *)cacheKey:(NSString *)userID type:(NSInteger)type{
    NSString *key = [NSString stringWithFormat:@"FriendEngineShouxinlist_%@_%@", userID,@(type)] ;
    return key;
}

-(void)storeShouXinList:(NSArray *)list{
    
    if(list && list.count){
        [[PINCache sharedCache]setObject:list forKey:[self cacheKey:_userID type:_type]];
    }else{
        [[PINCache sharedCache] removeObjectForKey:[self cacheKey:_userID type:_type]];
    }
    
    
    
}

-(NSArray *)readLocalShouxinList:(NSString *)userID type:(NSInteger)type{
    
    NSArray*pureArr = [[PINCache sharedCache] objectForKey:[self cacheKey:userID type:type]];
    return [self reformListResultAddPinyin:pureArr];
}


-(NSArray *)reformListResultAddPinyin:(NSArray *)list{
    
    if (!list || list.count == 0) {
        return nil;
    }
    
    _sectionSet = [NSMutableSet set];
    
    NSMutableArray *reformed = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in list) {
        
        NSString *fullPinyin = [WZChineseToPhonetic getPhonetic:[Util getUserRealNameOrNickName:dic]];
        NSString *firstLetter = [UtilString getFirstLetter:fullPinyin];
        
        HeaderNamePersonViewModel *model =  [[HeaderNamePersonViewModel alloc] init];
        
        model.headerUrl = dic[NET_KEY_HEADIMG];
        model.name = [Util getUserRealNameOrNickName:dic];
        model.firstLetter = firstLetter;
        model.fullPinyin = fullPinyin;
        model.moreInfoDic = dic;
        [reformed addObject:model];
        
        [_sectionSet addObject:[NSDictionary dictionaryWithObjectsAndKeys:firstLetter,@"firstLetter", nil]];
        
    }
    
    return reformed;
}


@end
