//
//  IOUDetailEngine.h
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNetworkEngine.h"
#import "IOUDetailUnit.h"

@interface IOUDetailEngine : CNNetworkEngine
@property(nonatomic,strong,readonly) NSArray *rejectArr;

//获取详情
-(void)getIOUDetail:(NSDictionary *)parms
            success:(void (^)(IOUDetailUnit *))success
            failure:(void (^)(NSString *error))failure;


-(void)actionIOU:(NSDictionary *)parms
          images:(NSArray *)images
         success:(void (^)())success
         failure:(void (^)(NSString *error))failure;


//动作
-(void)actionIOU:(NSDictionary *)parms
         success:(void (^)())success
         failure:(void (^)(NSString *error))failure;

-(void)getRejectReasonList:(NSInteger)oid
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSString *error))failure;
//驳回理由
-(void)getRejectReasonList;

//+(NSArray *)reformAttachmentsForPosting:(NSArray *)oriArr;

+(void)uploadImages:(NSArray *)images
           complete:(void (^)(NSArray *arr))complete;

+(NSArray *)reformAttachmentsForPosting:(NSArray *)oriArr;


@end
