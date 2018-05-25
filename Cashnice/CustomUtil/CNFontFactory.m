//
//  CNFontFactory.m
//  Cashnice
//
//  Created by a on 16/9/6.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNFontFactory.h"

@interface CNFontFactory() {
}

@property (nonatomic, strong)NSMutableDictionary *globalFontDictonary;

@end

@implementation CNFontFactory

static CGFloat _normalFontPointSize = 15.0f;

+ (id)fontFactoryInstance{
    static CNFontFactory *sharedFontFactoryInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedFontFactoryInstance = [[self alloc] init];
    });
    return sharedFontFactoryInstance;
}

- (UIFont *)getFontWithSaledSize:(CGFloat) saledSize{
    NSString *key = [NSString stringWithFormat:@"%@", @(saledSize)];
    id cachedFont = self.globalFontDictonary[key];
    if (cachedFont) {
        return cachedFont;
    }else{
        UIFont *font = [self fontWithDesignedSize:saledSize];
        [self.globalFontDictonary setObject:font forKey:key];
        return font;
    }
}

- (UIFont *)getFontWithDesignedSize:(NSString *)designedSize {
    CGFloat designedSizeValue = [self parseFloatFrom:designedSize];
    designedSizeValue = designedSizeValue < 1 ? _normalFontPointSize : designedSizeValue;
    CGFloat saledSize = [self scaleMethod](designedSizeValue);
    return [self getFontWithSaledSize:saledSize];
}

- (UIFont *)fontWithDesignedSize:(CGFloat)designedSize{
    
    CGFloat saledSize = [self scaleMethod](designedSize);
    
    UIFont *font = [UIFont systemFontOfSize:saledSize];
    
    return font;
}

//获得轻字体
- (UIFont *)lightFontWithDesignedSize:(CGFloat)designedSize{
    
    CGFloat saledSize = [self scaleMethod](designedSize);
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:saledSize];
    //[UIFont systemFontOfSize:saledSize];
    
    return font;
}

- (UIFont *)fontWithDesignedFont:(NSString *) designedFont{
    
    //[designedFont floatValue];
    CGFloat designedSize = [self parseFloatFrom:designedFont];
    
    designedSize = designedSize < 1 ? _normalFontPointSize : designedSize;
    
    return [self fontWithDesignedSize:designedSize];
}

- (CGFloat (^)(CGFloat))scaleMethod{
    if (! _scaleMethod) {
        
        return ^CGFloat(CGFloat size){
            
            CGFloat offset = size - 28;
            size = _normalFontPointSize + offset/2;
            
            return size * MIDDLE_SCALE;
        };
    }else{
        return _scaleMethod;
    }
}

- (CGFloat)parseFloatFrom:(NSString *)string{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[string stringByTrimmingCharactersInSet:nonDigits] floatValue];
}

- (NSMutableDictionary *)globalFontDictonary{
    if (! _globalFontDictonary) {
        _globalFontDictonary = [[NSMutableDictionary alloc] init];
    }
    return _globalFontDictonary;
}

@end
