//
//  IOUDetailEngine.m
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailEngine.h"
#import <MJExtension.h>
#import "IOU.h"

@implementation IOUDetailEngine


-(void)actionIOU:(NSDictionary *)parms
          images:(NSArray *)images
         success:(void (^)())success
         failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    
    //有图片先传图片，再传数据
    
    void(^Post)(NSArray *reformedUploadedImgs) = ^(NSArray *reformedUploadedImgs){
        
        NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:parms];
        if(reformedUploadedImgs.count){
            newParams[@"attachments"]=reformedUploadedImgs;
        }
        
        [self sendHttpRequest:newParams pathName:HTTPPATH_IOU_ACTION compeletionHandler:^{
            
            if(success){
                success();
            }
            
        } errorHandler:^{
            if(failure){
                failure(errMsg);
            }
        }];
    };
    
    if(images.count){
        [[self class]uploadImages:images complete:^(NSArray *arr) {
            Post(arr);
        }];
    }else{
        Post(nil);
    }
}

-(void)actionIOU:(NSDictionary *)parms
         success:(void (^)())success
         failure:(void (^)(NSString *error))failure{
    [self actionIOU:parms images:nil success:success failure:failure];
    
}

-(void)getIOUDetail:(NSDictionary *)parms
            success:(void (^)(IOUDetailUnit *))success
            failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_IOU_DETAIL compeletionHandler:^{
        NSDictionary*resp = [self getDictWithIndex:0];
        if (resp) {
            if(success){
                
                IOUDetailUnit *detail =  [IOUDetailUnit mj_objectWithKeyValues:resp];
                
                success(detail);
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

-(void)getRejectReasonList:(NSInteger)oid
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSString *error))failure{
        
    NSDictionary *parms = @{@"optionid":@(oid)};
    
    [self sendHttpRequest:parms pathName:HTTPPATH_OPTIONLIST
                  version:@"2.0"
       compeletionHandler:^{
           
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               
               NSArray *items = resp[@"items"];
               if(items){
                   success(items);
               }
           }else{
               failure(errMsg);
           }
           
       } errorHandler:^{
           failure(errMsg);
       }];
    
    
}

-(void)getRejectReasonList{
    
    
    if (!_rejectArr && ZAPP.myuser.rejectReason) {
        _rejectArr = ZAPP.myuser.rejectReason;
        return;
    }
    
    NSDictionary *parms = @{@"optionid":@(9)};
    
    [self sendHttpRequest:parms pathName:HTTPPATH_OPTIONLIST
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               
               NSArray *items = resp[@"items"];
               if(items){
                   ZAPP.myuser.rejectReason = items;
                   _rejectArr = ZAPP.myuser.rejectReason;
                   
               }
           }else{
               
           }
           
       } errorHandler:^{
           
       }];
}
+(void)uploadImages:(NSArray *)images
           complete:(void (^)(NSArray *arr))complete{
    
    if(images.count){
        
        [ZAPP.netEngine uploadIOUImages:images completionHandler:^(id object) {
            
            complete([IOUDetailEngine reformAttachmentsForPosting:object[@"files"]]);
            
        } errorHandler:^{
            complete(nil);
        }];
        
        
    }else{
        complete(nil);
    }
}
+(NSArray *)reformAttachmentsForPosting:(NSArray *)oriArr{
    
    NSMutableArray *arr = @[].mutableCopy;
    
    for (id oridic in oriArr) {

        NSMutableDictionary *newdic = [NSMutableDictionary dictionary];
        newdic[@"type"] = @"img";
        newdic[@"url"] = [oridic isKindOfClass:[NSDictionary class]]? oridic[@"url"]:oridic;
        newdic[@"orgfilename"] = @"orgfilenamehahaha";
        
        [arr addObject:newdic];
    }
    
    return arr;
}



@end
