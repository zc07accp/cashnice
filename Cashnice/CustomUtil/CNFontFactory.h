//
//  CNFontFactory.h
//  Cashnice
//
//  Created by a on 16/9/6.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define CNFont(__px__) ([[CNFontFactory fontFactoryInstance] fontWithDesignedSize:__px__])

#define CNFont(__px__) ([[CNFontFactory fontFactoryInstance] getFontWithSaledSize:__px__])
#define CNLightFont(__px__) ([[CNFontFactory fontFactoryInstance] lightFontWithDesignedSize:__px__])

#define CNFont_18px (CNFont(18))
#define CNFont_22px (CNFont(22))
#define CNFont_24px (CNFont(24))
#define CNFont_26px (CNFont(26))
#define CNFont_28px (CNFont(27))
#define CNFont_30px (CNFont(30))
#define CNFont_32px (CNFont(32))
#define CNFont_34px (CNFont(34))
#define CNFont_36px (CNFont(36))
#define CNFont_38px (CNFont(38))
#define CNFont_40px (CNFont(40))
#define CNFont_42px (CNFont(42))
#define CNFont_44px (CNFont(44))
#define CNFont_58px (CNFont(58))
#define CNFontNormal CNFont_28px
#define CNFontSmall  CNFont_26px

@interface CNFontFactory : NSObject

@property (nonatomic, copy) CGFloat (^scaleMethod)(CGFloat designedSize);

+ (id)fontFactoryInstance;
- (UIFont *)getFontWithSaledSize:(CGFloat) saledSize;
- (UIFont *)getFontWithDesignedSize:(NSString *)designedSize;
//获得轻字体
- (UIFont *)lightFontWithDesignedSize:(CGFloat)designedSize;

@end
