//
//  IDCardIdentifyMgr.m
//  Cashnice
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IDCardIdentifyMgr.h"
#import "TXQcloudFrSDK.h"
#import "Auth.h"
#import "Conf.h"

@implementation IDCardIdentifyMgr

+(void)identify:(UIImage *)image cardType:(NSInteger)cardType
        success:(void(^)(BOOL, NSDictionary*))success{
    
    NSString *auth = [Auth appSign:1000000 userId:nil];
    TXQcloudFrSDK *sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId authorization:auth];

    [sdk idcardOcr:image cardType:cardType sessionId:nil successBlock:^(id responseObject) {
//        NSLog(@"idcard address = %@", responseObject[@"address"]);
        
        if([[responseObject[@"errormsg"] lowercaseStringWithLocale:[NSLocale currentLocale]] isEqualToString:@"ok"]){
 
            //检测背面是否过期
            if (cardType == 1 && ![self valideDateHandle:responseObject[@"valid_date"]]) {
                TOAST_LOCAL_STRING(@"tip.idcardauthen.validdatefailed");
                success(NO,responseObject);

            }else{
                success(YES,responseObject);
            }
            
        }else{

            TOAST_LOCAL_STRING(@"tip.idcardauthen.failed");
            success(NO,nil);
        }
        
        
    } failureBlock:^(NSError *error) {
//        [self errToast];
        TOAST_LOCAL_STRING(@"tip.idcardauthen.failed");
        success(NO,nil);

    }];
    
    
}

+(BOOL)valideDateHandle:(NSString *)valideDate{
    
    NSArray *array = [valideDate componentsSeparatedByString:@"-"];
    if (array.count!=2) {
        return NO;
    }
    
    NSString *endDate = array[1];
    if([endDate isEqualToString:@"长期"]){
        return YES;
    }
    
    
    NSDate *end = [Util dateMDByString:endDate];
    if (!end) {
        return NO;
    }
    
    
    if ([[NSDate date] compare:end]!= NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

//+(void)errToast{
//    TOAST_LOCAL_STRING(@"tip.idcardauthen.failed");
//}


@end
