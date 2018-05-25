//
//  ValidationCodeM.m
//  YQS
//
//  Created by l on 9/9/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "ValidationCodeM.h"

@interface ValidationCodeM ()
{
    BOOL _isNavigationBack;
    
    NSUInteger _totalSecond;
}


@property (nonatomic, strong) NSDate * lastSendDate;
@property (nonatomic, strong) NSTimer * validTimer;
@property (nonatomic, strong) MKNetworkOperation *op;

@end

@implementation ValidationCodeM

- (void)startTimer {
    if (self.validTimer) {
        [self clearRemainTimeAndStopTimer];
    }
    self.lastSendDate = [NSDate date];
	self.validTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dispatchValidateTimeInfo) userInfo:nil repeats:YES];
    [self dispatchValidateTimeInfo];
}

- (void)dispatchValidateTimeInfo {
    [Util dispatch:MSG_validatecode_time_update];
    if ([self getRemainTimeWithTotaltime:_totalSecond] <= 0) {
        [self clearRemainTimeAndStopTimer];
    }
}

- (int)getRemainTime {
    /*
    if (self.lastSendDate == nil) {
        return 0;
    }
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:self.lastSendDate];
    return (int)([ZAPP.myuser getSMSWaitingSencods] - t);
     */
    return [self getRemainTimeWithTotaltime:[ZAPP.myuser getSMSWaitingSencods]];
}


- (int)getRemainTimeWithTotaltime:(NSUInteger)total {
    
    _totalSecond = total;
    
    if (self.lastSendDate == nil) {
        return 0;
    }
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:self.lastSendDate];
    return (int)(total - t);
}

- (void)clearRemainTimeAndStopTimer {
    self.lastSendDate = nil;
    [self.validTimer invalidate];
    self.validTimer = nil;
}

- (void)sucSend {

    [Util toastStringOfLocalizedKey:@"tip.ValidationCodeHasSend"];
    [self startTimer];
}

- (void)sendChongzhiCode:(NSString *)val visaid:(NSString *)visaid withComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
	bugeili_net_new
	[self.op cancel];
    
    if ([visaid notEmpty]) {
    }
    else {
        visaid = @"";
    }
	_isNavigationBack = NO;
	[SVProgressHUD show];
	self.op = [ZAPP.netEngine sendChongzhiValidationCodeWithComplete:^{[self sucSend]; progress_hide
        if (compelteBlock != nil) {
            compelteBlock();
        }
    } error:^{[SVProgressHUD dismiss];
               if (errorBlock != nil) {
                   errorBlock();
               }
               } val:val visaid:visaid];
}

- (void)sendPhoneCode:(NSString *)phone withComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
	bugeili_net_new
	[self.op cancel];
	
	if ([phone notEmpty]) {
        _isNavigationBack = NO;
		[SVProgressHUD show];
		self.op = [ZAPP.netEngine sendValidateCodeWithComplete:^{[self sucSend]; progress_hide
            if (compelteBlock != nil) {
                compelteBlock();
            }
        } error:^{ [SVProgressHUD dismiss];
            if (errorBlock != nil) {
                errorBlock();
            }
        } phonenum:phone];
	}
    else {
        if (errorBlock != nil) {
            errorBlock();
        }
    }
}


- (void)sendPhoneCode:(NSString *)phone withRegionCode:(NSInteger)regeionCode Complete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock {
    bugeili_net_new
    [self.op cancel];
    
    if ([phone notEmpty]) {
        _isNavigationBack = NO;
        [SVProgressHUD show];
        self.op = [ZAPP.netEngine sendValidateCodeWithComplete:^{
            [self sucSend];
            progress_hide
            if (compelteBlock != nil) {
                compelteBlock();
            }
        } error:^{
            [SVProgressHUD dismiss];
            if (errorBlock != nil) {
                errorBlock();
            }
        } phonenum:phone regionCode:regeionCode];
    }
    else {
        if (errorBlock != nil) {
            errorBlock();
        }
    }
}

- (void)sendBindBankcardWithComplete:(NetResponseBlock)compelteBlock error:(NetErrorBlock)errorBlock cardnumber:(NSString *)cardnumber phonenumber:(NSString *)phonenumber bankCode:(NSString *)bankCode userName:(NSString *)userName idNumber:(NSString *)idNumber {
    bugeili_net_new
    [self.op cancel];
    _isNavigationBack = NO;
    [SVProgressHUD show];
    self.op = [ZAPP.netEngine bindBankcardWithComplete:^{[self sucSend]; progress_hide
        if (compelteBlock != nil) {
            compelteBlock();
        }
    } error:^{
        [SVProgressHUD dismiss];
        if (errorBlock != nil) {
            errorBlock();
        }
    } cardnumber:cardnumber phonenumber:phonenumber bankCode:bankCode userName:userName idNumber:idNumber];
}

@end
