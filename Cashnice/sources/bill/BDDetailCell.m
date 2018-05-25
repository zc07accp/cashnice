//
//  BDDetailCell.m
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BDDetailCell.h"

@implementation BDDetailCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)config:(NSString *)title content:(NSString *)content{
//    self.titleLabel.text = title;
//    self.contentLabel.text = content;
    [self config:title content:content contentColor:ZCOLOR(COLOR_NAV_BG_RED)];
}

-(void)config:(NSString *)title content:(NSString *)content contentColor:(UIColor *)color{
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    
    if (color) {
        self.contentLabel.textColor = color;
    }
    
}



@end
