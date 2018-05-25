//
//  IDCardIdentifyMgr.h
//  Cashnice
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCardIdentifyMgr : NSObject

+(void)identify:(UIImage *)image cardType:(NSInteger)cardType
        success:(void(^)(BOOL resultCode, NSDictionary*detail))success;

@end
