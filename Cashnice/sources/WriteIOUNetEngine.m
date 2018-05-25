//
//  WriteIOUNetEngine.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WriteIOUNetEngine.h"
#import "MJExtension.h"
#import "IOU.h"
#import "IOUDetailEngine.h"
#import "PersonObject.h"
#import "Base64EncoderDecoder.h"
#import "SinaCashierModel.h"

@implementation WriteIOUNetEngine

-(id)init{
    self = [super init];
    return self;
}

-(void)getSearchContacts:(NSDictionary *)parms
                 success:(void (^)(NSArray *users,  NSInteger totalCount))success
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
                NSInteger totalCount = [resp[@"totalcount"] integerValue];
                success([self resloveSearchContactsData:resp[@"users"]], totalCount);
            }
        }else{
            if(success){
                success(nil, 0);
            }
        }
        
    } errorHandler:^{
        if(failure){
            failure(errMsg);
        }
    }];
    
}

-(NSArray*)resloveSearchContactsData:(NSArray *)users{
    NSLog(@"%@",users);
    NSArray *resut = [PersonObject mj_objectArrayWithKeyValuesArray:users];
    return resut;
}


-(void)payServe:(NSDictionary *)parms
                 success:(void (^)())success
                 failure:(void (^)(NSString *error))failure;
{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_CHARGE_SERVEMONEY compeletionHandler:^{

        NSDictionary*resp = [self getDictWithIndex:0];
        if (resp) {
            NSInteger process_status = [resp[@"process_status"] integerValue];
            if (process_status==1) {
                if(success){
                    success();
                }
            }else{
                if(failure){
                    failure(errMsg);
                }
 
            }
        }
        
        
    } errorHandler:^{
        failure(errMsg);
    }];
    
}

//-(void)addNewIOU:(NSDictionary *)parms
//       success:(void (^)(NSInteger))success
//       failure:(void (^)(NSString *error))failure{
//
//    if (!parms) {
//        failure(@"parms null");
//        return;
//    }
//    
//    if(![UtilDevice isNetworkConnected]){
//        return;
//    }
////    
////    void(^Post)(NSArray *reformedUploadedImgs) = ^(NSArray *reformedUploadedImgs){
////        
////        
//        [self sendHttpRequest:parms pathName:HTTPPATH_POST_IOU
//           compeletionHandler:^{
//               NSDictionary*resp = [self getDictWithIndex:0];
//               if (resp) {
//                   NSInteger ui_id = [resp[@"ui_id"] integerValue];
//                   NSInteger ui_status = [resp[@"ui_status"] integerValue];
//                   success(ui_id);
//               }else{
//                   if(failure){
//                       failure(errMsg);
//                   }
//               }
//               
//           } errorHandler:^{
//               DLog(@"%@", errMsg);
//               if(failure){
//                   failure(errMsg);
//               }
//           }];
////    };
////
////    
////    if(images.count){
////        
////        [ZAPP.netEngine uploadIOUImages:images completionHandler:^(id object) {
////            
////            Post(nil);
////            
////        } errorHandler:^{
////            ;
////        }];
////
////        
////    }
////    
//
//    
//
//}
//
//


-(void)getIOUCounterfee:(NSDictionary *)parms
                success:(void (^)(CGFloat))success
                failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_IOU_COUNTERFEE
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
                CGFloat counterfee = [resp[@"counterfee"] floatValue];
               success(counterfee);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];

    
}


-(void)updateIOU:(NSDictionary *)parms
          images:(NSArray *)images
         success:(void (^)(NSInteger, NSArray*))success
         failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    //有图片先传图片，再传数据
    
    void(^Post)(NSArray *reformedUploadedImgs) = ^(NSArray *reformedUploadedImgs){
        
        NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:parms];
        if(reformedUploadedImgs.count){
            newParams[@"attachments"]=reformedUploadedImgs;
        }
        
        [self sendHttpRequest:newParams pathName:HTTPPATH_POST_IOU
           compeletionHandler:^{
               NSDictionary*resp = [self getDictWithIndex:0];
               if (resp) {
                   NSInteger ui_id = [resp[@"ui_id"] integerValue];
                   success(ui_id, reformedUploadedImgs);
               }else{
                   if(failure){
                       failure(errMsg);
                   }
               }
               
           } errorHandler:^{
               DLog(@"%@", errMsg);
               if(failure){
                   failure(errMsg);
               }
           }];
    };

    if(images.count){
        [IOUDetailEngine uploadImages:images complete:^(NSArray *arr) {
            Post(arr);
        }];
    }else{
        Post(nil);
    }

}


-(void)payforIOU:(NSDictionary *)parms
          images:(NSArray *)images
         success:(void (^)(NSInteger,NSData*))success
         failure:(void (^)(NSString *error))failure{
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_POST_IOU
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               NSInteger ui_id = [resp[@"ui_id"] integerValue];
               NSString *content = resp[@"content"];
               ///////
               NSData *decodedData = [Base64EncoderDecoder base64Decode:content];
               NSData *contentData = [SinaCashierModel ungzipData:decodedData];
               //////
               
               success(ui_id, contentData);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
    
}


-(void)getIOUTotalFee:(NSDictionary *)parms
              success:(void (^)(CGFloat t,CGFloat i,CGFloat v))success
              failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    if(totalFeeEngine){
        [totalFeeEngine cancel];
        totalFeeEngine = nil;
    }
    
    
   totalFeeEngine = [self sendHttpRequest:parms pathName:HTTPPATH_IOU_TOTALFEE
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               CGFloat total = [resp[@"total"] floatValue];
               CGFloat interest = [resp[@"interest"] floatValue];
               CGFloat val = [resp[@"val"] floatValue];
               NSLog(@"total=%.2f val=%.2f", total, val);
               success(total,interest,val);
           }else{
               if(failure){
                   failure(errMsg);
               }
           }
           
       } errorHandler:^{
           DLog(@"%@", errMsg);
           if(failure){
               failure(errMsg);
           }
       }];
    
    
}


-(void)getUseageList{
    
    
    if (ZAPP.myuser.iouUseage) {
        return;
    }
    
    NSDictionary *parms = @{@"optionid":@(7)};
    
    [self sendHttpRequest:parms pathName:HTTPPATH_OPTIONLIST
                  version:@"2.0"
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               
               NSArray *items = resp[@"items"];
               if(items){
                   ZAPP.myuser.iouUseage = items;
               }
           }else{
               
           }
           
       } errorHandler:^{
           
       }];
    
    
}

-(void)getAverageSuccess:(void (^)(CGFloat rate))success
                  failure:(void (^)(NSString *error))failure{
    
    if (ZAPP.myuser.averageRate) {
        success(ZAPP.myuser.averageRate);
        return;
    }
    
    [self sendHttpRequest:nil pathName:HTTPPATH_IOU_GETAVERAGE_RATE
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {

                   ZAPP.myuser.averageRate = [resp[@"rate"] doubleValue];
                   success(ZAPP.myuser.averageRate);
           }else{
               failure(errMsg);
           }
           
       } errorHandler:^{
           failure(errMsg);
       }];
    
}

-(void)getLoanRateSuccess:(void (^)(NSArray *))success
                  failure:(void (^)(NSString *error))failure{
    
    if (ZAPP.myuser.loanRateArr) {
        success(ZAPP.myuser.loanRateArr);
        return;
    }
    
    [self sendHttpRequest:nil pathName:HTTPPATH_IOU_GETLOANRATE
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               
               NSArray *items = (NSArray*)resp;
               if(items){
                   ZAPP.myuser.loanRateArr = items;
                   success(ZAPP.myuser.loanRateArr);
               }
           }else{
               failure(errMsg);
           }
           
       } errorHandler:^{
           failure(errMsg);
       }];
    
}

-(void)sendIOUAgain:(NSDictionary *)parms
                   Success:(void (^)())success
                  failure:(void (^)(NSString *error))failure{
    
    if(![UtilDevice isNetworkConnected]){
        return;
    }
    
    if (!parms) {
        failure(@"parms null");
        return;
    }
    
    [self sendHttpRequest:parms pathName:HTTPPATH_IOU_PUSH
       compeletionHandler:^{
           NSDictionary*resp = [self getDictWithIndex:0];
           if (resp) {
               success();
           }else{
               failure(errMsg);
           }
           
       } errorHandler:^{
           failure(errMsg);
       }];
    
}

@end
