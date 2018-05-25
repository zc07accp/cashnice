//
//  UILabel+Custom.m
//  YangLinDemo
//
//  Created by l on 3/14/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

- (NSString *)fontName {
    return self.font.fontName;
}

- (NSString *)fontName1 {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:@"MicrosoftYaHei" size:self.font.pointSize];
//    self.textColor = self.tag == 0 ? [DefColor bgWhite] : (self.tag == -1 ? [DefColor textBlack] : [DefColor textGray]);
}

- (void)setFontName1:(NSString *)fontName {
    self.font = [UIFont fontWithName:@"MicrosoftYaHei" size:self.font.pointSize];
}

@end
