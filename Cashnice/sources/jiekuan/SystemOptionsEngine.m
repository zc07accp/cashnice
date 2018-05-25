//
//  SystemOptionsEngine.m
//  Cashnice
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SystemOptionsEngine.h"
#import <PINCache.h>

@implementation SystemOptionsEngine

-(id)init{
    self = [super init];
    self.closeErrToast = YES;
    return self;
}

-(void)getSystemConfigSuccess:(void (^)())success
                     failure:(void (^)(NSString *error))failure{
    

    
    [self sendHttpRequest:@{} pathName:NET_FUNC_system_configure_info_get
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(success){
                   
                   ZAPP.myuser.systemInfoDict = resp;

                   success();
               }
           }else{
               if(success){
                   success();
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(errMsg);
           }
       }];
    
}


-(void)getSystemConfigItem:(NSArray *)item
                   success:(void (^)(NSArray *))success
                      failure:(void (^)(NSString *error))failure{
    
    NSDictionary *para = @{@"conditions"     : item};
    
    [self sendHttpRequest:para pathName:NET_FUNC_system_configure_info_get
                  version:@"3.0"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(success){
                   
                   //ZAPP.myuser.systemInfoDict = resp;
                   
                   NSArray *items = resp[@"items"];
                   
                   if ([items isKindOfClass:[NSArray class]]) {
                       success(items);
                   }else{
                       success(@[]);
                   }
               }
           }else{
               if(success){
                   success(@[]);
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(errMsg);
           }
       }];
    
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


-(void)getVISASuccess:(void (^)())success
                      failure:(void (^)(NSString *error))failure{
    
    
    NSDictionary *para2 = [self para_dict_me_USER_VISA_LIST_GET];

    NSString *version = @"2.0";
#ifdef USER_VISA_LIST_GET_API_VER_1
    version = @"1.0";
#endif
    
    [self sendHttpRequest:para2 pathName:NET_FUNC_user_visa_list_get
                  version:version
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(success){
                   
                   ZAPP.myuser.bankcardListRespondDict = resp;
                   
                   success();
               }
           }else{
               if(success){
                   success();
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(errMsg);
           }
       }];
    
}



-(void)getUserIdentifyProgressSuccess:(void (^)())success
              failure:(void (^)(NSString *error))failure{
    
    NSDictionary *para = @{
                           NET_KEY_USERID : [ZAPP.myuser getUserID]
                           };
    
    NSString *version = @"2.0";
    
    [self sendHttpRequest:para pathName:NET_FUNC_USER_IDENTIFY_progress_get
                  version:version
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(success){
                   
                   ZAPP.myuser.identifyProgressDict = resp;
                   
                   success();
               }
           }else{
               if(success){
                   success();
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(errMsg);
           }
       }];
    
}


-(void)getSystemOptionsListSuccess:(void (^)())success
                              failure:(void (^)(NSString *error))failure{
    
    NSDictionary *para = @{@"optionid" : @(3)};
    
    NSString *version = @"2.0";

    [self sendHttpRequest:para pathName:NET_FUNC_system_options_list_get
                  version:version
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(success){
                   
                   ZAPP.myuser.systemOptionsDictShehuiZhiwu = resp;
                   
                   success();
               }
           }else{
               if(success){
                   success();
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(errMsg);
           }
       }];
    
}


-(void)getInternationListSuccess:(void (^)())success
                           failure:(void (^)(NSString *error))failure{
    
    NSDictionary *para = @{};
    
    NSString *version = @"1.0";
    
    [self sendHttpRequest:para pathName:@"system.international.list.get"
                  version:version
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(success){
                   
                   ZAPP.myuser.systemRegionArray = (NSArray *)resp;
                   
                   success();
               }
           }else{
               if(success){
                   success();
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(errMsg);
           }
       }];
    
}

-(void)getUserTransferSwitchComplete:(void (^)(BOOL opened))complete{

    if ([[ZAPP.myuser getUserID] length] == 0) {
        return;
    }
    
    NSDictionary *para = @{
                           NET_KEY_USERID : [ZAPP.myuser getUserID]
                           };
    NSString *version = @"1.0";

    [self sendHttpRequest:para pathName:@"user.transfer.switch.get"
                  version:version
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(complete){
                   
                   //1显示转账按钮  2不显示转账按钮
                   NSInteger status = [resp[@"status"] integerValue];
                   ZAPP.myuser.showTransferEntrance = status==1;
                   complete(status==1);
               }
           }else{
               if(complete){
                   complete(NO);
               }
           }
           
       } errorHandler:^{
           if(complete){
               DLog(@"");
               complete(NO);
           }
       }];
    

    
}


-(NSString *)cacheKey{
    NSString *key = @"BANNER_CACHE";
    return key;
}

-(void)storeData:(NSDictionary *)dic{
    
    //存储本地
    
    if(dic){
        [[PINDiskCache sharedCache]setObject:dic forKey:[self cacheKey]];
    }else{
        [[PINDiskCache sharedCache] removeObjectForKey:[self cacheKey]];
    }
}

-(void)getBannersSuccess:(void (^)(NSArray*))complete
    failure:(void (^)(NSString *error))failure{

    NSDictionary *para = @{
                           NET_KEY_PAGENUM : @(0),
                           NET_KEY_PAGESIZE : @(20)
                           };
    WS(weakSelf)

    [self sendHttpRequest:para pathName:@"system.banner.list.get"
       compeletionHandler:^{
           NSDictionary*resp = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resp) {
               
               if(complete){
                   
                   [weakSelf storeData:resp];

                   //1显示转账按钮  2不显示转账按钮

                   NSArray *banners = EMPTYOBJ_HANDLE(resp[@"banners"]);
                   NSMutableArray *mutarr = [NSMutableArray array];
                   for (NSDictionary *tempdic in banners) {
                       
                       ShowUnit *unit = [[ShowUnit alloc]init];
                       unit.type = [tempdic[@"type"] integerValue];
                       unit.atitle = EMPTYSTRING_HANDLE(tempdic[@"title"]);
                       unit.picurl = EMPTYSTRING_HANDLE(tempdic[@"picurl"]);
                       unit.contentUrl = EMPTYSTRING_HANDLE(tempdic[@"url"]);
                       unit.desc = EMPTYSTRING_HANDLE(tempdic[@"desc"]);

                       
                       [mutarr addObject:unit];
                   }
                   
                   complete(mutarr);
               }
           }else{
               if(complete){
                   complete(nil);
               }
           }
           
       } errorHandler:^{
           if(failure){
               DLog(@"");
               failure(nil);
           }
       }];
    
    
}

-(NSArray *)readLocalBannerData{
    NSDictionary *dic = (NSDictionary *)[[PINDiskCache sharedCache] objectForKey:[self cacheKey]];
    
    if (!dic) {
        return nil;
    }
    
    NSArray *banners = EMPTYOBJ_HANDLE(dic[@"banners"]);
    NSMutableArray *mutarr = [NSMutableArray array];
    for (NSDictionary *tempdic in banners) {
        
        ShowUnit *unit = [[ShowUnit alloc]init];
        unit.type = [tempdic[@"type"] integerValue];
        unit.picurl = EMPTYSTRING_HANDLE(tempdic[@"picurl"]);
        unit.atitle = EMPTYSTRING_HANDLE(tempdic[@"title"]);
        unit.contentUrl = EMPTYSTRING_HANDLE(tempdic[@"url"]);
        
        [mutarr addObject:unit];
    }

    return mutarr;
}

-(void)getADComplete:(void (^)(NSDictionary *))complete{

    NSDictionary *para = @{
                           NET_KEY_USERID : [ZAPP.myuser getUserID]
                           };
    NSString *version = @"1.0";
    
    [self sendHttpRequest:para pathName:@"system.bootimage.list.get"
                  version:version
       compeletionHandler:^{
           NSDictionary*resps = EMPTYOBJ_HANDLE([self getDictWithIndex:0]);
           if (resps) {
               
               if(complete){
                   
                    //1显示转账按钮  2不显示转账按钮
                   complete(resps);
               }
           }else{
               if(complete){
                   complete(nil);
               }
           }
           
       } errorHandler:^{
           if(complete){
               DLog(@"");
               complete(nil);
           }
       }];
    
    
    
}



@end
