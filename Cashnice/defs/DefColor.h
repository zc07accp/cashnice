//
//  DefColor.h
//  D3I
//
//  Created by Tao on 14-7-28.
//  Copyright (c) 2014年 dc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CN_UNI_RED  HexRGB(0Xee4721) //app内统一的红色

#define COLOR_BG_WHITE          @"#FFFFFF"
#define COLOR_BG_GRAY           @"#EEEEEE"
#define COLOR_DD_GRAY           @"#DDDDDD"
#define COLOR_SEPERATOR_COLOR   @"#CCCCCC"
#define COLOR_LIGHT_THEME       @"#3399FF"

#define COLOR_TEXTFIELD_BORDER      @"#D4D4D4"
#define COLOR_TEXTFIELD_PLACEHOLDER @"#888888"

#define COLOR_TAB_TOP_LINE      @"#AFAFAF"
#define COLOR_TAB_BG            @"#FAFAFA"
#define COLOR_TAB_NAME          @"#666666"
#define COLOR_TAB_NAME_CLICK    @"#1D3781"
#define COLOR_TAB_REFRESH_HEAD  COLOR_SEPERATOR_COLOR

#define COLOR_NAV_BG_RED     @"#1D3781"
#define COLOR_NAV_BG_NEWYEAR @"#D81E07"
#define COLOR_BILL_BG_YELLOW @"#F6A305"

#define COLOR_GENERAL_BG_GRAY  @"#E3E3E3"
#define COLOR_BUTTON_DISABLE   @"#C5C5C5"

#define COLOR_BUTTON_RED        @"#1D3781"
#define COLOR_BUTTON_RED_CLICK  @"#C60D00"
#define COLOR_BUTTON_BLUE       @"#3399ff"
#define COLOR_BUTTON_BLUE_CLICK @"#1EABEF"

#define COLOR_TEXT_DARKBLACK  @"#000000"
#define COLOR_TEXT_BLACK      @"#333333"
#define COLOR_TEXT_GRAY       @"#666666"
#define COLOR_TEXT_LIGHT_GRAY @"#999999"


#define CN_COLOR_BG_GRAY HexRGB(0XEEEEEE)

#define CN_COLOR_DD_GRAY HexRGB(0XDDDDDD)

#define CN_TEXT_GRAY  HexRGB(0X666666)

#define CN_TEXT_VIEW_LIGHTGRAY HexRGB(0Xe2e2e2)

#define CN_TEXT_GRAY_9  HexRGB(0X999999)


#define CN_NAV_BKCOLOR HexRGB(0X1D3781)

#define CN_TEXT_BLACK  HexRGB(0X000000)

#define CN_TEXT_BLUE  HexRGB(0x3399ff)

#define CN_SEPLINE_GRAY  HexRGB(0xd9d9d9)

//建议用RGB和HexRGB
#define RGBA(r,g,b,a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//十六进位颜色转换
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@interface DefColor : UIColor

// color conversion
+ (BOOL)colorIsValid:(NSString *)color;
+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b alpha:(int)a;
+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b;
+ (UIColor *)colorParseString:(NSString *)string;
+ (UIColor *)colorParseInt:(int)intv;
+ (int32_t)colorIntValue:(UIColor *)color;
+ (int)colorRedIntValue:(UIColor *)color;
+ (int)colorGreenIntValue:(UIColor *)color;
+ (int)colorBlueIntValue:(UIColor *)color;
+ (NSString *)colorToString:(UIColor *)color;

+ (UIColor *)placeholderColor:(BOOL)isPurple;

//+ (UIColor *)bgWhite;
//+ (UIColor *)textBlack;
//+ (UIColor *)textGray;

+ (UIColor *)bgGreenColor;
@end
