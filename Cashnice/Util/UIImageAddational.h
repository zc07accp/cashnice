//
//  UIImageAddational.h
//  OGL
//
//  Created by ZengYuan on 14/12/17.
//  Copyright (c) 2014年 ZengYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Addational)
-(UIImage *)adaptiveImageNamed:(NSString *)name;
+(UIImage *)imageRedraw:(UIImage *)_image;

- (UIImage *)cropEqualScaleImageToSize:(CGSize)size;

-(UIImage *)imageFromCropRect:(CGRect)rect;

@end
