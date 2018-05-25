//
//  UIImageView+Radius.h
//  SDWebImageView+Raidus
//
//  Created by zeng on 16/6/12.
//  Copyright © 2016年 HSF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Radius)



-(void)aw_setImageWithURLString:(NSString *)urlString
                    placeholder:(UIImage *)image;

/**
 *  适配SDWebImage设置圆形图片 (不带边框)
 *
 *  @param urlString       url字符串
 *  @param imageName       image名字
 */
-(void)aw_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)imageName;

/**
 *  适配SDWebImage设置圆形图片 (带边框)
 *
 *  @param urlString   url字符串
 *  @param imageName   image名字
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色 
 *  (透明效果:使用这个方法[UIColor colorWithRed:green:blue:alpha:])
 */
-(void)aw_setImageWithURLString:(NSString *)urlString placeholderImageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/**
 *  绘制成圆形图片 （不带边框）
 *
 *  @param image      image
 *  @param imageBlock 在block中返回不带边框的圆形图片
 */
-(void)radiusIcon:(UIImage *)image  iconBlock:(void (^)(UIImage * image))imageBlock;

/**
 *  绘制成圆形图片 （带边框）
 *
 *  @param image           image
 *  @param borderWidth     边框宽度
 *  @param borderColor     边框颜色
 *  @param iconBorderBlock 在block中返回带边框的圆形图片
 */
-(void)radiusIcon:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor iconBorderBlock:(void (^)(UIImage * image))iconBorderBlock;
/**
 *  画圆形图片 （不带边框）
 *
 *  @param image 图片
 *
 *  @return UIImage 画好的原型图片
 */
-(UIImage *)drawCircleWithImage:(UIImage *)image;

/**
 *  画圆形图片 (带边框)   
 *
 *  @param image       image
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return UIImage 绘制带边框的图片
 */
-(UIImage *)drawCircleWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
