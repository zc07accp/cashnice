//
//  UIImageView+Radius.m
//  SDWebImageView+Raidus
//
//  Created by zeng on 16/6/12.
//  Copyright © 2016年 HSF. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+Radius.h"

@implementation UIImageView (Radius)

- (void)aw_setImageWithURLString:(NSString *)urlString
            placeholderImageName:(NSString *)imageName {
    return [self aw_setImageWithURLString:urlString placeholderImageName:imageName borderWidth:0 borderColor:nil];
    
}

-(void)aw_setImageWithURLString:(NSString *)urlString
                    placeholder:(UIImage *)image{
    [self AW_CG_SetImageWithUrl:[NSURL URLWithString:urlString] placeholderImage:image borderWidth:0 borderColor:nil];
    
}

- (void)aw_setImageWithURLString:(NSString *)urlString
            placeholderImageName:(NSString *)imageName
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor {
    [self AW_CG_SetImageWithUrl:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:imageName] borderWidth:borderWidth borderColor:borderColor];
}

- (void)radiusIcon:(UIImage *)image
         iconBlock:(void (^)(UIImage *image))imageBlock {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_queue_create("com.UIImage.AWExpand.NoBorder",
                                         DISPATCH_QUEUE_SERIAL),
                   ^{
                       UIImage *icon = [weakself drawCircleWithImage:image];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (imageBlock) {
                               imageBlock(icon);
                           }
                       });
                   });
}

- (void)radiusIcon:(UIImage *)image
       borderWidth:(CGFloat)borderWidth
       borderColor:(UIColor *)borderColor
   iconBorderBlock:(void (^)(UIImage *))iconBorderBlock {
    __weak typeof(self) weakself = self;
    if ((borderWidth > 0) && (borderColor != nil)) {
        dispatch_async(dispatch_queue_create("com.UIImage.AWExpand.Border",
                                             DISPATCH_QUEUE_SERIAL),
                       ^{
                           UIImage *icon = [weakself drawCircleWithImage:image
                                                             borderWidth:borderWidth
                                                             borderColor:borderColor];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if (iconBorderBlock) {
                                   iconBorderBlock(icon);
                               }
                           });
                       });
    }else{
        [self radiusIcon:image iconBlock:iconBorderBlock]
        ;
    }
    
}

/**
 *  画圆形图片
 *
 *  @param image 图片
 *
 *  @return UIImage 画好的原型图片
 */
- (UIImage *)drawCircleWithImage:(UIImage *)image {

    WS(weakSelf)
    CGFloat graphicsWidthOrHeight = weakSelf.frame.size.width;
    CGSize graphicsSize =
    CGSizeMake(graphicsWidthOrHeight, graphicsWidthOrHeight);
    UIGraphicsBeginImageContextWithOptions(graphicsSize, NO, 0);
    CGContextRef circleContext = UIGraphicsGetCurrentContext();
    if (nil == circleContext) {
        return nil;
    }
    CGContextAddEllipseInRect(
                              circleContext,
                              CGRectMake(0, 0, graphicsWidthOrHeight, graphicsWidthOrHeight));
    CGContextClip(circleContext);
    [image drawInRect:CGRectMake(0, 0, graphicsWidthOrHeight,
                                 graphicsWidthOrHeight)];
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return icon;
}

/**
 *  绘制带边框的图片
 *
 *  @param image       image
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return UIImage 绘制带边框的图片
 */
- (UIImage *)drawCircleWithImage:(UIImage *)image
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor {
    
    CGFloat graphicsWidthOrHeight = self.frame.size.width;
    CGSize graphicsSize =
    CGSizeMake(graphicsWidthOrHeight, graphicsWidthOrHeight);
    
    UIGraphicsBeginImageContextWithOptions(graphicsSize, NO, 0);
    CGContextRef circleContext = UIGraphicsGetCurrentContext();
    if (nil == circleContext) {
        return nil;
    }
    
    CGContextAddEllipseInRect(
                              circleContext,
                              CGRectMake(0, 0, graphicsWidthOrHeight, graphicsWidthOrHeight));
    
    CGContextClip(circleContext);
    
    UIImage *bgImage = [self imageWithColor:borderColor];
    [bgImage drawInRect:CGRectMake(0, 0, graphicsWidthOrHeight,
                                   graphicsWidthOrHeight)];
    
    CGFloat iconXOrY = borderWidth;
    CGFloat iconWOrH = graphicsWidthOrHeight - borderWidth * 2;
    CGContextAddEllipseInRect(circleContext,
                              CGRectMake(iconXOrY, iconXOrY, iconWOrH, iconWOrH));
    CGContextClip(circleContext);
    [image drawInRect:CGRectMake(iconXOrY, iconXOrY, iconWOrH, iconWOrH)];
    
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return icon;
}
/**
 *  根据颜色创建一个image
 *
 *  @param color 颜色
 *
 *  @return 创建好的image
 */
- (UIImage *)imageWithColor:(UIColor *)color {
    
    if (!color) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

/**
 *  设置图片
 *
 *  @param url            图片地址
 *  @param placeholder    占位符
 *  @param options        操作
 *  @param borderWidth    边框宽度
 *  @param borderColor    边框颜色
 */
- (void)AW_CG_SetImageWithUrl:(NSURL *)url
             placeholderImage:(UIImage *)placeholder
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor{
    if (!self.image) {
        self.image = placeholder;
    }
    if (url) {
        __weak __typeof(self) wself = self;
        [SDWebImageManager.sharedManager
         downloadImageWithURL:url
         options:0
         progress:nil
         completed:^(UIImage *image, NSError *error,
                     SDImageCacheType cacheType, BOOL finished,
                     NSURL *imageURL) {
             if (!wself) return;
             
             if (error) {
                 DLog(@"%@", error);
             }
             
             dispatch_main_sync_safe(^{
                 if (!wself) return;
                 if (image) {
                     [wself radiusIcon:image
                           borderWidth:borderWidth
                           borderColor:borderColor
                       iconBorderBlock:^(UIImage *image) {
                           wself.image = image;
                           [wself setNeedsLayout];
                       }];
                 }
                 else{
                     wself.image = placeholder;
                 }
                 
             });
         }];
    }
}

@end
