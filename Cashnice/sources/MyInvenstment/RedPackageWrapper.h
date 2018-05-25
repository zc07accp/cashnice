//
//  RedPackageWrapper.h
//  Cashnice
//
//  Created by a on 2017/2/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPackageWrapper : UIView


@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UIColor  *textColor;

- (instancetype)initWithPackageWidth:(CGFloat)width packageFont:(UIFont *)packageFont wrapperFont:(UIFont *)wrapperFont value:(NSString *)value x:(CGFloat)x y:(CGFloat)y;

- (instancetype)initWithPackageWidth:(CGFloat)width packageFont:(UIFont *)packageFont wrapperFont:(UIFont *)wrapperFont value:(NSString *)value;

@end
