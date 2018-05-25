//
//  UIImageAddational.m
//  OGL
//
//  Created by ZengYuan on 14/12/17.
//  Copyright (c) 2014年 ZengYuan. All rights reserved.
//

#import "UIImageAddational.h"

@implementation UIImage(Addational)
-(UIImage *)adaptiveImageNamed:(NSString *)name{
    return  [UIImage imageNamed:name];
}


+(UIImage *)imageRedraw:(UIImage *)_image{
    
    NSLog(@"w=%.2f, h=%.2f", _image.size.width,_image.size.height);
    
    if (_image.size.height < 640 && _image.size.width < 640) {
        return _image;
    }
    
    
    CGRect rect;
    float scale=_image.size.width/_image.size.height;
    
    //横屏
    if (scale > 1) {
        rect=CGRectMake(0, 0, 640, 640/scale);
        
    }else{
        rect=CGRectMake(0, 0,  640*scale, 640);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [_image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)cropEqualScaleImageToSize:(CGSize)size {
    CGFloat scale =  [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGSize aspectFitSize = CGSizeZero;
    if (self.size.width != 0 && self.size.height != 0) {
        CGFloat rateWidth = size.width / self.size.width;
        CGFloat rateHeight = size.height / self.size.height;
        
        CGFloat rate = MIN(rateHeight, rateWidth);
        aspectFitSize = CGSizeMake(self.size.width * rate, self.size.height * rate);
    }
    
    [self drawInRect:CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)imageFromCropRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

@end
