//
//  CNNextStepButton.m
//  Cashnice
//
//  Created by a on 16/6/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNNextStepButton.h"

@implementation CNNextStepButton

static const CGFloat kCNNextStepButtonWidth  = 110.0f;
static const CGFloat kCNNextStepButtonHeight = 38.0f;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    
    [self setTintColor:[UIColor whiteColor]];
    self.titleLabel.font = [UtilFont systemButtonTitle];
    
    self.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4.0f];
    self.layer.masksToBounds = YES;
    
    [self setEnabled:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.width = [ZAPP.zdevice getDesignScale:kCNNextStepButtonWidth];
//    self.height = [ZAPP.zdevice getDesignScale:kCNNextStepButtonHeight];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    self.backgroundColor = enabled? ZCOLOR(COLOR_NAV_BG_RED) : ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
