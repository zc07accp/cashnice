//
//  ContactsUploadEngine.m
//  Cashnice
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ContactsUploadEngine.h"

@implementation ContactsUploadEngine

-(id)init{
    self = [super init];
    self.closeErrToast = YES;
    
    return self;
}

-(void)uploadContacts:(NSString *)contacts
               userid:(NSInteger)userid
              success:(void (^)())success
              failure:(void (^)(NSString *error))failure;
{
//    
//    if (!contacts || contacts.length == 0 ) {
//         return;
//    }
//    
    NSParameterAssert(userid);
    
    NSDictionary *parms = @{@"userid":@(userid), @"data":[contacts length]?contacts:@""};
    
    [self sendHttpRequest:parms pathName:@"contact.analysis.data.post"
                  version:@"2.0"
       compeletionHandler:^{
        NSDictionary*resp = [self getDictWithIndex:0];
        NSInteger process_status = [resp[@"process_status"] integerValue];
        if (process_status == 1) {
            if(success){
                success();
            }
        }else{
            if(failure){
                failure(errMsg);
            }
        }
        
    } errorHandler:^{
        if(failure){
            failure(errMsg);
        }
    }];
    
}



@end
