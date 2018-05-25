//
//  ValidationCodeM.h
//  YQS
//
//  Created by l on 9/9/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationCodeM : NSObject

- (int)getRemainTime;
- (int)getRemainTimeWithTotaltime:(NSUInteger)total;
- (void)clearRemainTimeAndStopTimer;

- (void)startTimer ;
- (void)sucSend ;

//发送验证码，区号
- (void)sendPhoneCode:(NSString *)phone withRegionCode:(NSInteger)regeionCode Complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
//发送验证码
- (void)sendPhoneCode:(NSString *)phone withComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;
- (void)sendChongzhiCode:(NSString *)val visaid:(NSString *)visaid withComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock;

- (void)sendBindBankcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock cardnumber:(NSString *)cardnumber phonenumber:(NSString *)phonenumber bankCode:(NSString *)bankCode userName:(NSString *)userName idNumber:(NSString *)idNumber;

@end
