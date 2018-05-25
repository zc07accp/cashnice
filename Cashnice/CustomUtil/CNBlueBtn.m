//
//  CNBlueBtn.m
//  Cashnice
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNBlueBtn.h"


@implementation CNBlueBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = self.enabled ? ZCOLOR(COLOR_NAV_BG_RED) : ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds= YES;
    
    
    CGRect rec = self.frame;
    rec.size.width = [ZAPP.zdevice getDesignScale:110];
    rec.size.height = [ZAPP.zdevice getDesignScale:38];
    self.frame = rec;
}


-(void)setEnabled:(BOOL)enabled{

    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
    }else{
        self.backgroundColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    }
}


@end
