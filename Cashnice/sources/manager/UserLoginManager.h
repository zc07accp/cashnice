//
//  UserLoginManager.h
//  YQS
//
//  Created by l on 4/8/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginManager : NSObject


- (id)init;

- (NSString *)generateWeixinLoginLocalState;
- (BOOL)compareWeixinLoginResponseStateWithLocalState:(NSString *)serverState;

- (void)setTheUserDataDict:(NSDictionary *)dict;//user data from weixin
- (void)setTheAccessTokenDict:(NSDictionary *)dict;//access data from weixin
- (NSDictionary *)getWeixinUserDataDict;
- (void)setTheLoginRespondDataDict:(NSDictionary *)dict;//respond data fromr real login to our sever
- (BOOL)userDataExists;
- (void)clearUserData;

- (void)loginToServer:(NSString *)phone;

- (NSString *)getAccessToken;
- (NSString *)getWeixinRefreshToken;
- (NSString *)getSessionKey;
- (NSString *)getSocialAccountId;
- (BOOL)hasSavedPhone;
- (NSInteger)getRegionCode;

- (NSString *)getSavedPhone;
- (NSString *)getOpenID;
- (NSString *)getUnionID;
- (NSString *)getHeaderUrl;
- (NSString *)getNickName;
- (NSString *)getSavedHeadImage;
- (NSString *)getSavedUserId;

- (BOOL)isLogined;
- (void)setLogined:(BOOL)login;

- (BOOL)tokenExpired;
- (void)setTheTokenExpired:(BOOL)expired;

@end
