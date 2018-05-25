//
//  UserLoginManager.m
//  YQS
//
//  Created by l on 4/8/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UserLoginManager.h"

@interface UserLoginManager () {
//	BOOL     isLoginedToServer;
	BOOL     tokenExpired;
	NSTimer *checkLoginTimer;
}

@property (strong, nonatomic) MKNetworkOperation *loginOperation;

@property (strong, nonatomic) NSString *    localState;
@property (strong, nonatomic) NSDictionary *userDataDict;
@property (strong, nonatomic) NSDictionary *accessTokenDict;
@property (strong, nonatomic) NSDictionary *loginRespondDict;

@end

@implementation UserLoginManager

- (id)init {
	self = [super init];
	if (self != nil) {
		[self load];
	}
	return self;
}

- (NSString *)userFile {
	return [UtilFile libFile:USER_FILE_NAME];
}

- (NSString *)tokenFile {
	return [UtilFile libFile:TOKEN_FILE_NAME];
}

- (NSString *)respFile {
	return [UtilFile libFile:LOGIN_RESPOND_FILE_NAME];
}

- (void)clearUserData {
//	isLoginedToServer = NO;
	[self stopLoginTimer];
	self.userDataDict     = nil;
	self.loginRespondDict = nil;
	self.accessTokenDict  = nil;
	[UtilFile fileDelete:[self userFile]];
	[UtilFile fileDelete:[self tokenFile]];
	[UtilFile fileDelete:[self respFile]];
}

- (BOOL)isLogined {
    
    return ZAPP.tabViewCtrl && ZAPP.tabViewCtrl.viewControllers.count;
    
//    return [[[ZAPP.tabViewCtrl viewControllers] firstObject] isKindOfClass:[UITabBarController class]];
//	if (!isLoginedToServer) {
//		[self loginToServer:nil];
//	}
//	return isLoginedToServer;
}

- (void)setLogined:(BOOL)login {
//	isLoginedToServer   = login;
//	self.loginOperation = nil;
}

- (void)load {
	NSString *userFile  = [self userFile];
	NSString *tokenFile = [self tokenFile];
	if ([UtilFile fileExists:userFile]) {
		self.userDataDict = [Util readDictFromFileWithBase64:userFile key:FILE_ENCODE_KEY];
	}
	if ([UtilFile fileExists:tokenFile]) {
		self.accessTokenDict = [Util readDictFromFileWithBase64:tokenFile key:FILE_ENCODE_KEY];
	}

	NSString *respFile = [self respFile];
	if ([UtilFile fileExists:respFile]) {
		self.loginRespondDict = [Util readDictFromFileWithBase64:respFile key:FILE_ENCODE_KEY];
		//[self loginToServer:nil];
	}
}

- (void)startLoginTimer {
//	if ([self userDataExists]) {
//		[self stopLoginTimer];
//		checkLoginTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loginToServer) userInfo:nil repeats:NO];
//	}
}

- (void)stopLoginTimer {
	[checkLoginTimer invalidate];
	checkLoginTimer = nil;
}


- (void)loginToServer:(NSString *)phone {
    return;
//	NSString *realPhone = @"";
//	if ([phone notEmpty]) {
//		realPhone = phone;
//	}
//	else {
//		realPhone = [self getSavedPhone];
//	}
//	if (self.loginOperation == nil && [realPhone notEmpty]) {
//		[SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeBlack];
//		self.loginOperation = [ZAPP.netEngine newloginToServerByPhone:realPhone complete:^{
//            [ZAPP.netEngine getUserInfoWithComplete:^{[self setDataLoginSuc]; } error:^{[self setDataLoginFail]; }];
//        } error:^{[self setDataLoginFail];}];
//	}
}

- (void)setDataLoginSuc {
	self.loginOperation = nil;
	[Util dispatch:MSG_login_to_server_suc];
	[SVProgressHUD dismiss];
}

- (void)setDataLoginFail {
	[SVProgressHUD dismiss];
	self.loginOperation = nil;
    [ZAPP loginout];
}

- (NSString *)generateWeixinLoginLocalState {
	self.localState = [NSString stringWithFormat:@"%@-%@", [Util randomMacAddress], NET_TEST_VALUE_SESSIONKEY];
	return self.localState;
}

- (BOOL)compareWeixinLoginResponseStateWithLocalState:(NSString *)serverState {
	if ([self.localState notEmpty] && [serverState notEmpty]) {
		return [self.localState isEqualToString:serverState];
	}
	return NO;
}

- (void)setTheUserDataDict:(NSDictionary *)dict {
	self.userDataDict = dict;
	tokenExpired      = NO;
	if (self.userDataDict != nil) {
		[Util saveDictToFileWithBase64:self.userDataDict file:[self userFile] key:FILE_ENCODE_KEY];
	}
}

- (NSDictionary *)getWeixinUserDataDict {
	return self.userDataDict;
}

- (void)setTheLoginRespondDataDict:(NSDictionary *)dict {
	if (dict != nil) {
		NSDictionary *x = [dict objectForKey:NET_KEY_USER];
		if ([x isKindOfClass:[NSNull class]]) {
			NSMutableDictionary *z = [NSMutableDictionary dictionaryWithDictionary:dict];
			[z removeObjectForKey:NET_KEY_USER];
			self.loginRespondDict = [NSDictionary dictionaryWithDictionary:z];
		}
		else {
			[ZAPP.myuser setTheUser:x];//set user data to real User Manager
			self.loginRespondDict = [NSMutableDictionary dictionaryWithDictionary:dict];
		}
		[Util saveDictToFileWithBase64:self.loginRespondDict file:[self respFile] key:FILE_ENCODE_KEY];
	}
}

- (void)setTheAccessTokenDict:(NSDictionary *)dict {
	self.accessTokenDict = dict;
	tokenExpired         = NO;
	if (self.accessTokenDict != nil) {
		[Util saveDictToFileWithBase64:self.accessTokenDict file:[self tokenFile] key:FILE_ENCODE_KEY];
	}
}

- (BOOL)userDataExists {
    return [self hasSavedPhone];
}

- (BOOL)tokenExpired {
	return tokenExpired;
}

- (void)setTheTokenExpired:(BOOL)expired {
	tokenExpired = expired;
}

- (NSString *)getAccessToken {
	NSString *str = [self.accessTokenDict objectForKey:WEIXIN_KEY_ACCESS_TOKEN];
	if (str == nil) {
		str = @"";
	}
	return str;
}

- (NSString *)getWeixinRefreshToken {
#ifdef TEST_SAME_SESSIONKEY
	return @"OezXcEiiBSKSxW0eoylIeIyuISAxJoE8wSAkd2qNV_J4XtmbUJR5Q5E8Kd4tLX6crKkomYfwcSeaZJQGMVJiJV49RjuYTTQKjcMivPdOP7BGkkIf5EEvunlG24VcCiw3ouruFF_bsOSPi9UoWczH_Q";
#else
	NSString *str = [self.accessTokenDict objectForKey:WEIXIN_KEY_REFRESH_TOKEN];
	if (str == nil) {
		str = @"";
	}
	return str;
#endif
}

- (BOOL)hasSavedPhone {
	return [[self getSavedPhone] notEmpty];
}

- (NSInteger)getRegionCode{
    if (self.loginRespondDict != nil) {
        NSDictionary *userDict = [self.loginRespondDict objectForKey:NET_KEY_USER];
        if (userDict != nil) {
            NSInteger x = [[userDict objectForKey:@"nationality"] integerValue];
            if (x) {
                return x;
            }
        }
    }
    return 0;
}

- (NSString *)getSavedHeadImage{
    if (self.loginRespondDict != nil) {
        NSDictionary *userDict = [self.loginRespondDict objectForKey:NET_KEY_USER];
        if (userDict != nil) {
            NSString *x = [userDict objectForKey:NET_KEY_HEADIMG];
            if (x) {
                return x;
            }
        }
    }
    return nil;
}

- (NSString *)getSavedUserId {
    if (self.loginRespondDict != nil) {
        NSDictionary *userDict = [self.loginRespondDict objectForKey:NET_KEY_USER];
        if (userDict != nil) {
            NSString *x = [userDict objectForKey:NET_KEY_USERID];
            if ([x notEmpty]) {
                return x;
            }
        }
    }
    return @"";
}

- (NSString *)getSavedPhone {
	if (self.loginRespondDict != nil) {
		NSDictionary *userDict = [self.loginRespondDict objectForKey:NET_KEY_USER];
		if (userDict != nil) {
			NSString *x = [userDict objectForKey:NET_KEY_PHONE];
			if ([x notEmpty]) {
				return x;
			}
		}
	}
	return @"";
}

- (NSString *)getSessionKey {
	if (self.loginRespondDict != nil) {
		NSString *x = [self.loginRespondDict objectForKey:NET_KEY_SESSIONKEY];
		if ([x notEmpty]) {
			return x;
		}
	}
	return @"";
}

- (NSString *)getSocialAccountId {
    //return @"";
	if (self.loginRespondDict != nil) {
		NSString *x = [self.loginRespondDict objectForKey:NET_KEY_socialaccountid];
		if ([x notEmpty]) {
			return x;
		}
	}
	return @"";
}

- (NSString *)getOpenID {
	NSString *str = [self.accessTokenDict objectForKey:WEIXIN_KEY_OPENID];
	if (str == nil) {
		str = @"";
	}
	return str;
}

- (NSString *)getUnionID {
//    return @"123456789abcdefghijklmn987653x21abcdefgh";
	NSString *str = [self.userDataDict objectForKey:WEIXIN_KEY_UNIONID];
	if (str == nil) {
		str = @"";
	}
	return str;
}
- (NSString *)getHeaderUrl {
	NSString *str = [self.userDataDict objectForKey:WEIXIN_KEY_headimgurl];
	if (str == nil) {
		str = @"";
	}
	return str;
}
- (NSString *)getNickName {
	NSString *str = [self.userDataDict objectForKey:WEIXIN_KEY_nickname];
	if (str == nil) {
		str = @"";
	}
	return str;
}

@end
