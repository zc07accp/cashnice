#import <Foundation/Foundation.h>

extern CGFloat largeSize;
extern CGFloat smallSize;

@interface UtilFont : NSObject

//+ (void)printAll;
//+ (UIFont *)boldFont:(UIFont *)font;
//+ (UIFont *)yahei:(CGFloat)size;
//+ (UIFont *)yaheiBold:(CGFloat)size;//yahei bold doesn't exist in this ttf
//+ (UIFont *)porsche:(CGFloat)size;
//+ (UIFont *)dcicon:(CGFloat)size;
//+ (NSString *)dctext:(int)icon;

+ (UIFont *)system:(CGFloat)sz;
+ (UIFont *)systemBold:(CGFloat)sz;
+ (UIFont *)systemLargeBold;
+ (UIFont *)systemLarge;
+ (UIFont *)systemMiddle;
+ (UIFont *)systemSmall;
+ (UIFont *)systemButtonTitle;
+ (UIFont *)systemAmountTitle;

+ (UIFont *)systemMiddleNormal;
+ (UIFont *)systemLargeNormal;
+ (UIFont *)systemSmallNormal;
+ (UIFont *)systemNormal:(CGFloat)sz;
@end
    