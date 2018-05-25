//
//  DefColor.m
//  D3I
//
//  Created by Tao on 14-7-28.
//  Copyright (c) 2014年 dc. All rights reserved.
//

#import "DefColor.h"
#import "Util.h"

@implementation DefColor

#pragma mark - Color Conversion

+ (BOOL)colorIsValid:(NSString *)color {
    return ZCHECKSTR(color);
}

+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b {
  return [UIColor colorWithRed:((float)r / 255.0f)
                         green:((float)g / 255.0f)
                          blue:((float)b / 255.0f)
                         alpha:1.0f];
}

+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b alpha:(int)a {
  return [UIColor colorWithRed:((float)r / 255.0f)
                         green:((float)g / 255.0f)
                          blue:((float)b / 255.0f)
                         alpha:((float)a / 255.0f)];
}

+ (UIColor *)colorParseString:(NSString *)string {
  UIColor *res = [UIColor blackColor];
  if ([self colorIsValid:string]) {
    if (string.length == 7) {
      unsigned int r, g, b;
      NSRange range;
      range.length = 2;
      range.location = 1;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&r];
      range.location = 3;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&g];
      range.location = 5;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&b];
      res = [self colorWithRed:r green:g blue:b];
    } else if (string.length == 9) {
      unsigned int r, g, b, a;
      NSRange range;
      range.length = 2;
      range.location = 1;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&a];
      range.location = 3;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&r];
      range.location = 5;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&g];
      range.location = 7;
      [[NSScanner scannerWithString:[string substringWithRange:range]]
          scanHexInt:&b];
      res = [self colorWithRed:r green:g blue:b alpha:a];
    }
  }
  return res;
}

+ (UIColor *)colorParseInt:(int)intv {
    int32_t color = intv & 0xffffffff;//a, r, g, b
    int a = (color>>24) & 0x000000ff;
    int r = (color>>16) & 0x000000ff;
    int g = (color>>8) & 0x000000ff;
    int b = color & 0x000000ff;
    return [self colorWithRed:r green:g blue:b alpha:a];
}

+ (int32_t)colorIntValue:(UIColor *)color {
    if (color == nil) {
        return 0;
    }
    CGFloat r = 0.0f, g = 0.0f, b = 0.0f, a = 0.0f;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    int intr = (int)roundf(r * 255.0f);
    int intg = (int)roundf(g * 255.0f);
    int intb = (int)roundf(b * 255.0f);
    int inta = (int)roundf(a * 255.0f);
    
    int32_t res = inta * 256 * 256 * 256 + intr * 256 * 256 + intg * 256 + intb;
    return res;
}

+ (int)colorRedIntValue:(UIColor *)color {
    if (color == nil) {
        return 0;
    }
    CGFloat r = 0.0f, g = 0.0f, b = 0.0f, a = 0.0f;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    int intv = (int)roundf(r * 255.0f);
    
    return intv;
}

+ (int)colorGreenIntValue:(UIColor *)color {
    if (color == nil) {
        return 0;
    }
    CGFloat r = 0.0f, g = 0.0f, b = 0.0f, a = 0.0f;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    int intv = (int)roundf(g * 255.0f);
    
    return intv;
}

+ (int)colorBlueIntValue:(UIColor *)color {
    if (color == nil) {
        return 0;
    }
    CGFloat r = 0.0f, g = 0.0f, b = 0.0f, a = 0.0f;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    int intv = (int)roundf(b * 255.0f);
    
    return intv;
}

+ (NSString *)colorToString:(UIColor *)color {
    return  [NSString stringWithFormat:@"#%06X", [self colorIntValue:color] & 0x00ffffff];
}

+ (UIColor *)placeholderColor:(BOOL)isPurple {
    return isPurple ? [UIColor purpleColor] : [UIColor magentaColor];
}

//+ (UIColor *)bgWhite {
//    return nil;
//}
//+ (UIColor *)textBlack {
//    return nil;
//}
//+ (UIColor *)textGray {
//    return nil;
//}
+ (UIColor *)bgGreenColor {
    return [self colorWithRed:101 green:167 blue:31];
}
@end
