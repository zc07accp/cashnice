//
//  ThinLIne.h
//  DZbbs2
//
//  Created by zengyuan on 8/9/13.
//  Copyright (c) 2013 zengyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonLine : UIView
{
    float height;
    NSMutableArray *colorRGBArray; //存储颜色的RGB
}
-(void)setLineHeight:(float)height;
-(void)setLineColor:(UIColor *)color;
@end
