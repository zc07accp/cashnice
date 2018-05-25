#import "UtilFont.h"
#import "UtilLog.h"

CGFloat largeSize = 15;
CGFloat smallSize = 13;
CGFloat middleSize = 14;
CGFloat buttonTitleSize = 20;
CGFloat amountLabelSize = 25;

@implementation UtilFont

+ (void)printAll
{
    NSArray* familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray* fontNames;
    NSInteger indFamily, indFont;
    for (indFamily = 0; indFamily < [familyNames count]; ++indFamily) {
        [UtilLog string:[familyNames objectAtIndex:indFamily] tag:@"Family name"];
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for (indFont = 0; indFont < [fontNames count]; ++indFont) {
            [UtilLog string:[fontNames objectAtIndex:indFont] tag:@"--Font name"];
        }
    }
}

+ (UIFont *)boldFont:(UIFont *)font {
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold", font.fontName] size:font.pointSize];
    return newFont;
}

+ (UIFont *)yahei:(CGFloat)size
{
    return [UIFont fontWithName:@"MicrosoftYaHei" size:[ZAPP.zdevice getDesignScale:size]];
}

+ (UIFont *)yaheiBold:(CGFloat)size {
    return [self boldFont:[self yahei:size]];
}

+ (UIFont*)porsche:(CGFloat)size
{
    return [UIFont fontWithName:@"SK_Porsche" size:[ZAPP.zdevice getDesignScale:size]];
}

+ (UIFont*)dcicon:(CGFloat)size
{
    return [UIFont fontWithName:@"icomoon" size:[ZAPP.zdevice getDesignScale:size]];
}

//+ (NSString*)dctext:(int)icon
//{
//    if ([DefIcon iconIsValidInt:icon]) {
//    return [NSString stringWithFormat:@"%C", (unsigned short)icon];
//    }
//    else {
//        return @"";
//    }
//}

+ (UIFont *)system:(CGFloat)sz {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:[ZAPP.zdevice getDesignScale:sz]];
}

+ (UIFont *)systemNormal:(CGFloat)sz {
    return [UIFont systemFontOfSize:[ZAPP.zdevice getDesignScale:sz]];
}

+ (UIFont *)systemBold:(CGFloat)sz {
    return [UIFont boldSystemFontOfSize:[ZAPP.zdevice getDesignScale:sz]];
}

+ (UIFont *)systemLargeBold {
    return [UIFont boldSystemFontOfSize:[ZAPP.zdevice getDesignScale:17]];
}

+ (UIFont *)systemLarge {
    return [self system:largeSize];
}

+ (UIFont *)systemLargeNormal {
    return [self systemNormal:largeSize];
}

+ (UIFont *)systemMiddleNormal {
    return [self systemNormal:middleSize];
}

+ (UIFont *)systemMiddle {
    return [self system:middleSize];
}

+ (UIFont *)systemSmall {
    return [self system:smallSize];
}

+ (UIFont *)systemSmallNormal {
    return [self systemNormal:smallSize];
}

+ (UIFont *)systemButtonTitle {
    return [self systemNormal:buttonTitleSize];
}

+ (UIFont *)systemAmountTitle {
    return [self systemBold:amountLabelSize];
}


@end
