//
//  RedPackageWidget.h
//  Cashnice
//
//  Created by a on 2017/2/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPackageWidget : UIView

- (instancetype)initWithFont:(UIFont*)font;
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font;

//显示文本值
@property (nonatomic, strong) NSString *value;

//设置显示加息券样式
@property (nonatomic) BOOL isCoupon;

//文本颜色
//@property (nonatomic, strong) UIColor *textColor;

@end
