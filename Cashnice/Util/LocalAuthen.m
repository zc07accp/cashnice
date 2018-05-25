//
//  LocalAuthen.m
//  Cashnice
//
//  Created by apple on 2016/11/15.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LocalAuthen.h"
#import <LocalAuthentication/LocalAuthentication.h>

static NSString* const SetGesturePasswdKey = @"SetGesturePasswdKey";
static NSString* const DidTouchIDOpenedKey = @"DidTouchIDOpenedKey";
static NSString* const DidSetGesturePasswdFirstTimeKey = @"DidSetGesturePasswdFirstTimeKey";

@implementation LocalAuthen

+ (instancetype)sharedInstance
{
    static LocalAuthen* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocalAuthen alloc] init];
    });
    return instance;
}


-(NSString *)sgpkey{
    NSString*temp =
    [NSString stringWithFormat:@"%@%@", SetGesturePasswdKey,[ZAPP.myuser getUserID]];
    return temp;
}

-(NSString *)dtikey{
    NSString*temp =
     [NSString stringWithFormat:@"%@%@", DidTouchIDOpenedKey,[ZAPP.myuser getUserID]];
    return temp;

}

-(NSString *)dsgpfkey{
    NSString*temp =
    [NSString stringWithFormat:@"%@%@", DidSetGesturePasswdFirstTimeKey,[ZAPP.myuser getUserID]];
    return temp;
}

-(id)init{
    self =[super init ];
    
    [self readSetting];
    
    return self;
}

-(void)readSetting{
    _gesturePasswd = [[NSUserDefaults standardUserDefaults] objectForKey:[self sgpkey]]?YES:NO;
    _touchIDOpened = [[NSUserDefaults standardUserDefaults] objectForKey:[self dtikey]]?YES:NO;

}


-(BOOL)touchIDAvailble{

    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        return NO;
    }
    
    if ([self lowerThan5S]) {
        return NO;
    }
    
    NSError *error;

    LAContext *myContext = [[LAContext alloc] init];
    BOOL ava = [myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    return ava;

}

-(void)evaluate:(void(^)(BOOL suc))result{
    
    LAContext *laContext = [[LAContext alloc] init];

    [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
              localizedReason:  CNLocalizedString(@"tip.touchid.unlock", nil)
                        reply:^(BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"success to evaluate");
                                //do your work
                                
                                result(YES);
                            }
                            if (error) {
                                NSLog(@"---failed to evaluate---error: %@---", error.description);
                                //do your error handle
                                result(NO);

                            }
                        }];
    
}



-(void)setGesturePasswd:(BOOL)open{
    
    _gesturePasswd = open;
    
    if (open) {
        [[NSUserDefaults standardUserDefaults] setObject:@"setGesturePasswd" forKey:[self sgpkey]];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self sgpkey]];
    }
    
}

//当前设备是否拥有touch id功能
-(BOOL)touchIDDeviceExisted{
    return ![self lowerThan5S];
}


-(BOOL)touchIDOpened{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self dtikey]]?YES:NO;
    
}
-(void)setTouchIDOpened:(BOOL)open{
    
    _touchIDOpened = open;

    if (open) {
        [[NSUserDefaults standardUserDefaults] setObject:@"didTouchIDOpened" forKey:[self dtikey]];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self dtikey]];
    }
    
}

-(BOOL)didEsturePasswdOpened{
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:[self sgpkey]] ? YES:NO;
    
}

-(BOOL)didSetGesturePasswdFirstTime{

    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:[self dsgpfkey]];
    
    if (!temp) {
        [[NSUserDefaults standardUserDefaults] setObject:@"didSetGesturePasswdFirstTime"
                                                  forKey:[self dsgpfkey]];
        return YES;
    }
    
    return NO;
    
}



- (BOOL)lowerThan5S
{
    NSString *correspondVersion = [UtilDevice getDeviceMode];
    
    if ([correspondVersion isEqualToString:@"i386"])        return YES;
    if ([correspondVersion isEqualToString:@"x86_64"])       return YES;
    
    if ([correspondVersion isEqualToString:@"iPhone1,1"])   return YES;
    if ([correspondVersion isEqualToString:@"iPhone1,2"])   return YES;
    if ([correspondVersion isEqualToString:@"iPhone2,1"])   return YES;
    if ([correspondVersion isEqualToString:@"iPhone3,1"] || [correspondVersion isEqualToString:@"iPhone3,2"])      return YES;
    if ([correspondVersion isEqualToString:@"iPhone4,1"])     return YES;
    if ([correspondVersion isEqualToString:@"iPhone5,1"] || [correspondVersion isEqualToString:@"iPhone5,2"])     return YES;
    if ([correspondVersion isEqualToString:@"iPhone5,3"] || [correspondVersion isEqualToString:@"iPhone5,4"])    return YES;
   
    return NO;
}

@end
