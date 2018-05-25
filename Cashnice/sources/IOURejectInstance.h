//
//  IOURejectInstance.h
//  Cashnice
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOUDetailEngine.h"

@interface IOURejectInstance : NSObject
{
    NSMutableDictionary *dic;
    
    IOUDetailEngine *engine;
}

+(IOURejectInstance*)shareInstance;

-(void)getRejectReasonList:(NSInteger)oid
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSString *error))failure;

@end
