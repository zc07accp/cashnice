#import <Foundation/Foundation.h>
#import "Reachability.h"

#define IPHONE6_ORI_VALUE(_v_) (_v_* (MainScreenWidth == 375 ? 1:(MainScreenWidth < 375?(MainScreenWidth+15)/375:(MainScreenWidth-15)/375)))


@interface UtilDevice : NSObject
{
    DeviceType _deviceType;
    LanguageType _languageType;
    
    CGFloat _designScale;
    CGFloat _middleScale;
}

- (id)init;
- (LanguageType)getLanguageType;
- (CGFloat)getDesignScale:(CGFloat)floatValue;
- (CGSize)getDesignScaleSize:(CGSize)sz;
//新的，从iPhone6开始的
- (CGFloat)scaledValue:(CGFloat)value;

+ (BOOL)systemVersionNotLessThan:(NSString *)version;
+ (BOOL)isNetworkConnected;
+ (BOOL)realNetworkConnected;
+ (NetworkStatus)getNewWorkStatus;


+ (NSString *)getDeviceMode ;
+ (NSString *)getDeviceSystem;

+(BOOL)webViewFailCausedByNetwork:(NSError*)error;

//- (CGFloat)getNewDesignScale:(CGFloat)floatValue;

@end
