//
//  GFCalendarCell.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "GFCalendarCell.h"

@implementation GFCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        [self addSubview:self.SelectedCircle];
        [self addSubview:self.todayCircle];
        [self addSubview:self.todayLabel];
        
        [self addSubview:self.underPoint];
        
        //self.SelectedCircle.hidden = YES;
    }
    
    return self;
}

- (UIView *)todayCircle {
    if (_todayCircle == nil) {
        _todayCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.8 * self.bounds.size.height, 0.8 * self.bounds.size.height)];
        _todayCircle.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _todayCircle.layer.cornerRadius = 0.5 * _todayCircle.frame.size.width;
        _todayCircle.layer.borderWidth = [ZAPP.zdevice getDesignScale:3];
        _todayCircle.layer.borderColor = CN_TEXT_BLUE.CGColor;
        _todayCircle.backgroundColor = [UIColor clearColor];
        
    }
    return _todayCircle;
}

- (UILabel *)todayLabel {
    if (_todayLabel == nil) {
        _todayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.font = CNFont_28px;
        _todayLabel.backgroundColor = [UIColor clearColor];
    }
    return _todayLabel;
}

- (UIView *)SelectedCircle {
    if (_SelectedCircle == nil) {
        _SelectedCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.8 * self.bounds.size.height, 0.8 * self.bounds.size.height)];
        _SelectedCircle.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _SelectedCircle.layer.cornerRadius = 0.5 * _SelectedCircle.frame.size.width;
        _SelectedCircle.backgroundColor = HexRGB(0x99cdff);
    }
    return _SelectedCircle;
}

- (UIView *)underPoint{
    if (_underPoint == nil) {
        CGFloat size = [ZAPP.zdevice getDesignScale:6];
        _underPoint = [[UIView alloc] initWithFrame:CGRectMake((self.width - size)/2, self.height - size*3 + 2, size, size)];
        _underPoint.layer.cornerRadius = 0.5 * size;
        _underPoint.backgroundColor = CN_UNI_RED;
    }
    return _underPoint;
}

@end
