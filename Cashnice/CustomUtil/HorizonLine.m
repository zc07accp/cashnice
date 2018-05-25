//
//  ThinLIne.m
//  DZbbs2
//
//  Created by zengyuan on 8/9/13.
//  Copyright (c) 2013 zengyuan. All rights reserved.
//

#import "HorizonLine.h"

@implementation HorizonLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        height=1;
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    // Drawing code
    CGContextRef _context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(_context, 0, 0);
    CGContextAddLineToPoint(_context, rect.size.width, 0);
    CGContextSetLineWidth(_context, height);
    CGContextSetRGBStrokeColor(_context,
                        [[colorRGBArray objectAtIndex:0] floatValue],
                        [[colorRGBArray objectAtIndex:1] floatValue],
                        [[colorRGBArray objectAtIndex:2] floatValue],1);
    CGContextStrokePath(_context);

}

-(void)setLineColor:(UIColor *)color{
    [self changeUIColorToRGB:color];
    [self setNeedsDisplay];
}

-(void)setLineHeight:(float)_height{
    height=_height;
    [self setNeedsDisplay];

}


//将UIColor转换为RGB值
- (void)changeUIColorToRGB:(UIColor *)color
{
    
    colorRGBArray = [[NSMutableArray alloc] init];
//    NSString *RGBStr = nil;
    NSNumber *rgbNumber=nil;
    
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    
    if ([RGBArr count] == 5) {
        //获取红色值
        float r = [[RGBArr objectAtIndex:1] floatValue];
        rgbNumber = [NSNumber numberWithFloat:r];
        [colorRGBArray addObject:rgbNumber];
        
        //获取绿色值
        float g = [[RGBArr objectAtIndex:2] floatValue];
        rgbNumber = [NSNumber numberWithFloat:g];
        [colorRGBArray addObject:rgbNumber];
        
        //获取蓝色值
        
        float b = [[RGBArr objectAtIndex:3] floatValue];
        rgbNumber = [NSNumber numberWithFloat:b];
        [colorRGBArray addObject:rgbNumber];
    }else{
//$        UIDeviceRGBColorSpace
    }
    

    
    //返回保存RGB值的数组
}



@end
