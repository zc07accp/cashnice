//
//  NetDef.h
//  YQS
//
//  Created by l on 3/14/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#ifndef YQS_NetDef_h
#define YQS_NetDef_h

#import "NetKey.h"
#import "NetFunc.h"

//api.weixin.qq.com
//api.cashnice.com
#define WEIXIN_SERVER_URL        @"api.weixin.qq.com"
#define WEIXIN_API_ACCESS_TOKEN  @"sns/oauth2/access_token"
#define WEIXIN_API_REFRESH_TOKEN @"sns/oauth2/refresh_token"
#define WEIXIN_API_CHECK_TOKEN   @"sns/auth"
#define WEIXIN_API_USER_INFO     @"sns/userinfo"


#define WEIXIN_KEY_ACCESS_TOKEN       @"access_token"
#define WEIXIN_KEY_EXPIRES_IN         @"expires_in"
#define WEIXIN_KEY_REFRESH_TOKEN      @"refresh_token"
#define WEIXIN_KEY_OPENID             @"openid"
#define WEIXIN_KEY_SCOPE              @"scope"
#define WEIXIN_KEY_UNIONID            @"unionid"
#define WEIXIN_KEY_APPID              @"appid"
#define WEIXIN_KEY_SECRET             @"secret"
#define WEIXIN_KEY_CODE               @"code"
#define WEIXIN_KEY_AUTHORIZATION_CODE @"authorization_code"
#define WEIXIN_KEY_GRANT_TYPE         @"grant_type"
#define WEIXIN_KEY_city               @"city"
#define WEIXIN_KEY_country            @"country"
#define WEIXIN_KEY_headimgurl         @"headimgurl"
#define WEIXIN_KEY_language           @"language"
#define WEIXIN_KEY_nickname           @"nickname"
#define WEIXIN_KEY_privilege          @"privilege"
#define WEIXIN_KEY_province           @"province"
#define WEIXIN_KEY_sex                @"sex"


//// Bugly
#define BUGLY_APP_ID            @"5aa74ce51c"
#define BUGLY_APP_KEY           @"26eaef06-d523-480f-9a12-7f9fda0cb5f6"

#ifdef HUBEI
//  =========   =========   =========   湖北版配置   =========   =========   ==========
//  =========   =========   =========   湖北版配置   =========   =========   ==========

#define APPSTORE_URL            @"https://newhubei.cashnice.com/index.php"
#define INDEX_PAGE_URL          @"https://newhubei.cashnice.com/index.php"
// 微信
#define WEIXIN_APP_ID           @"wx28a3fc0146bec41e"               //@"wx783a036babaee375"
#define WEIXIN_SECRET           @"899415ee1782418b7266a6884107652d" //@"2a0dbf469d727bc1b4911b9e2868b3b5"
// 个推
#define kGtAppId                @"x8x0ZXYFal54GDLyEPmYR1"
#define kGtAppKey               @"7IEXRrRdmT8pWY3Jt0vMRA"
#define kGtAppSecret            @"jYz0siPWmr7LKvoUIrCqI9"
// 友盟推送
#define UMessageAppKey          @"5771d398e0f55aa20c00026c"
// 友盟统计
#define MobClickAppKey          @"5771d398e0f55aa20c00026c"

#define SHAREURL_IOU @"https://newhubei.cashnice.com/iou.php?iou_id=%@&user_id=%@"


#ifdef  TEST_TEST_SERVER
    #define YQS_SERVER_URL      @"rc1api.cashnice.com" //@"rc1.hubeiapi.cashnice.com"
    #define YQS_IMAGE_URL       @"timg.cashnice.com"
    #define WEB_DOC_URL_ROOT    @"https://rc1api.cashnice.com"  //@"http://rc0.hubeiapi.cashnice.com"
    #define INVITATION_WX_URL   @"http://rc0.m.cashnice.com/oauth/jump?sourceprovince=2&"
    #define IOU_API_PREFIX      WEB_DOC_URL_ROOT


#else
    #define YQS_SERVER_URL      @"hbnewapi.cashnice.com"        //hubeiapi.cashnice.com
    #define YQS_IMAGE_URL       @"img.cashnice.com"
    #define WEB_DOC_URL_ROOT    @"https://hbnewapi.cashnice.com"
    #define INVITATION_WX_URL   @"https://m.cashnice.com/oauth/jump?sourceprovince=2&"

    #define IOU_API_PREFIX      WEB_DOC_URL_ROOT


#endif

#else
////  =========   =========   =========   通用版配置   =========   =========   ==========
////  =========   =========   =========   通用版配置   =========   =========   ==========
//@"https://itunes.apple.com/cn/app/Cashnice/id1095232601?l=en&mt=8"
#define APPSTORE_URL            @"https://newapp.cashnice.com/index.php"
#define INDEX_PAGE_URL          @"https://newapp.cashnice.com/index.php"
//// 微信
#define WEIXIN_APP_ID           @"wxec502288b8bd077f"                //@"wxbf260021ccfae4d9"
#define WEIXIN_SECRET           @"7813fffdc1341153fb65ae2461864bd3"  //@"c0f59741a6771be2fa394fa5b2ecfb1d"
//// 友盟推送
#define UMessageAppKey          @"56e12920e0f55a63cd001629"
//// 友盟统计
#define MobClickAppKey          @"56e12920e0f55a63cd001629"

#define SHAREURL_IOU @"https://newapp.cashnice.com/iou.php?iou_id=%@&user_id=%@"


#ifdef  TEST_TEST_SERVER

    //#define YQS_SERVER_URL      @"rc0.api.cashnice.com"
    #define YQS_SERVER_URL      @"rc1api.cashnice.com"
    #define YQS_IMAGE_URL       @"timg.cashnice.com"
    #define WEB_DOC_URL_ROOT    @"https://rc1api.cashnice.com"
    #define INVITATION_WX_URL   @"https://rc1.m.cashnice.com/oauth/jump?"

    #define IOU_API_PREFIX      WEB_DOC_URL_ROOT


    //// 个推

    #define kGtAppId                @"9XQJPahyWy50s946T3Rwy8"
    #define kGtAppKey               @"154GQlftsH67NvmOsReJt9"
    #define kGtAppSecret            @"bMUvZdqWHP96iC3QKrGUw3"



#else
    #define YQS_SERVER_URL      @"newapi.cashnice.com"                  //@"api.cashnice.com"
    #define YQS_IMAGE_URL       @"img.cashnice.com"
    #define WEB_DOC_URL_ROOT    @"https://newapi.cashnice.com"
    #define INVITATION_WX_URL   @"https://m.cashnice.com/oauth/jump?"

    #define IOU_API_PREFIX      WEB_DOC_URL_ROOT

    //// 个推
    #define kGtAppId                @"h7huCTzqNi8qCi58J24KW4"
    #define kGtAppKey               @"Rz6eWNmFDF9GlWLoXsfO24"
    #define kGtAppSecret            @"tCCzn0WOrN70OI2SGlqdO9"


#endif
#endif


#define YQS_API_GET(__A__)       [NSString stringWithFormat : @"api?c=%@", [__A__ utf8String]]
#define YQS_API_POST_PATH        @"api"
#define YQS_API_POST_BODY(__A__) @{ @"c" : __A__ }
#define YQS_API_POST_IMAGE_PATH  @"api/uploadfs"

#define WEB_DOC_XU_ZHI          @"brrow_information.html"
#define WEB_DOC_AGREEMENT       @"agreement.html"
#define WEB_DOC_CONTACT         @"contact.html"
#define WEB_DOC_REGPROTOCOL     @"user_agreement.html"

#ifdef TEST_TEST_SERVER
#define USESSL YES
#else
#define USESSL YES
#endif

#define NET_KEY_COUNT       @"count"
#define NET_KEY_SESSIONKEY  @"sessionkey"
#define NET_KEY_SOURCE      @"source"
#define NET_KEY_VERSIONKEY  @"v"
#define NET_KEY_MODEL       @"model"
#define NET_KEY_SYSTEM      @"system"
#define NET_KEY_UID         @"uid"
#define NET_KEY_REQS        @"reqs" // array
#define NET_KEY_VERSION     @"version"
#define NET_KEY_NAME        @"name"
#define NET_KEY_orgfilename @"orgfilename"
#define NET_KEY_PARAMS      @"params" // dict

#define NET_VALUE_SOURCE         @"2"   // string, iOS
#define NET_VALUE_SERVER_VERSION @"1.0" // string

#define NET_TEST_VALUE_SESSIONKEY @"abcdefghijklmnopqrstuvwxyz" // string
#define NET_TEST_VALUE_UID        4                             // int


typedef void (^NetResponseBlock)();
typedef void (^NetErrorBlock)();
typedef void (^IDBlock)(id object);
typedef void (^CardIDBlock)(NSArray *urls);


typedef void (^FlickrImagesResponseBlock)(NSMutableArray* imageURLs);

#endif
