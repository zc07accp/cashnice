#import "UtilDevice.h"
#import "UtilLog.h"
#import "RealReachability.h"
#import <sys/utsname.h>

@implementation UtilDevice

- (id)init {
    self = [super init];
    if (self != nil) {
        [self initAll];
    }
    return self;
}

#pragma mark - init

- (void)initAll {
    [self initLanguageType];
    [self initDeviceType];
    _designScale = CGRectGetWidth([ZAPP window].frame)<414?(CGRectGetWidth([ZAPP window].frame)+20)/414:1;
    _middleScale = (MainScreenWidth == 375 ? 1:(MainScreenWidth < 375?(MainScreenWidth+15)/375:(MainScreenWidth-15)/375));
}

- (void)initLanguageType {
    _languageType = Language_En;
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    if ([languages count] > 0) {
        NSString* preferredLang = [languages objectAtIndex:0];
        if ([preferredLang isEqualToString:@"zh-Hans"]) {
            _languageType = Language_Cn;
        }
    }
}

- (void)initDeviceType {
    //6plus, 414
    //6    , 375
    //5    , 320, 568
    //4    , 320, 480, deprecated
    CGFloat w = CGRectGetWidth([ZAPP window].frame);
    //CGFloat h = CGRectGetHeight([ZAPP window].frame);
    
    if (w < 350) {
        _deviceType = Device_5_320;
    }
    else if (w < 400) {
        _deviceType = Device_6_375;
    }
    else {
        _deviceType = Device_6plus_414;
    }
}

#pragma mark - get

- (LanguageType)getLanguageType {
    return _languageType;
}

- (CGFloat)getDesignScale:(CGFloat)floatValue {
    return _designScale * floatValue;
}

- (CGFloat)scaledValue:(CGFloat)value {
    return _middleScale * value;
}
//
//- (CGFloat)getNewDesignScale:(CGFloat)floatValue {
//    return _designScale * floatValue;
//}

- (CGSize)getDesignScaleSize:(CGSize)sz {
    return CGSizeMake(sz.width * _designScale, sz.height * _designScale);
}

+ (BOOL)systemVersionNotLessThan:(NSString*)version
{
    BOOL res = NO;
    if ([version notEmpty]) {
        NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:[version trimmed] options:NSNumericSearch] != NSOrderedAscending) {
            res = YES;
        }
    }
    return res;
}

+ (BOOL)realNetworkConnected
{
    BOOL __block res = NO;
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        if (status != RealStatusNotReachable) {
            res = YES;
        }
    }];
    return res;
}

+ (BOOL)isNetworkConnected
{
    BOOL res = NO;
    switch ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
    case NotReachable:
        break;
    case ReachableViaWiFi:
        res = YES;
        break;
    case ReachableViaWWAN:
        res = YES;
        break;
    default:
        break;
    }
    return res;
}

+(BOOL)webViewFailCausedByNetwork:(NSError*)error{
    
    //-1001 timeout
    //-1005 connection lost
    //-1009 offline
    
    if (error.code == -1005 || error.code == -1009 || error.code == -1001) {
        return YES;
    }

    return NO;
}

+ (NetworkStatus)getNewWorkStatus
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}


+(NSString *)getDeviceMode {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machine = [NSString stringWithCString:systemInfo.machine
                                           encoding:NSUTF8StringEncoding];
    return machine ;
}

+ (NSString *)getDeviceSystem {
    return [NSString stringWithFormat:@"%@,%@",[[UIDevice currentDevice]systemName], [[UIDevice currentDevice]systemVersion]];
}

@end
