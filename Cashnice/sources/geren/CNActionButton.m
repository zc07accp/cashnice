//
//  CNActionButton.m
//  Cashnice
//
//  Created by a on 16/8/24.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNActionButton.h"

@implementation CNActionButton

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
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([ZAPP.zdevice scaledValue:37]);
        make.width.mas_equalTo([ZAPP.zdevice scaledValue:105]);
    }];
    
    //self.backgroundColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
    self.enabled = NO;
    
    self.titleLabel.font = [UtilFont systemButtonTitle];
    self.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5.0f];
    self.layer.masksToBounds = YES;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    self.backgroundColor = enabled ? ZCOLOR(COLOR_NAV_BG_RED) : ZCOLOR(COLOR_BUTTON_DISABLE);
}

- (void)associatedChanged{
    BOOL enable =  [self.associatedTextField.text doubleValue] > 0;
    self.enabled = enable;
}

- (void)setAssociatedTextField:(UITextField *)associatedTextField{
    _associatedTextField = associatedTextField;
    if (associatedTextField) {
        [associatedTextField addTarget:self action:@selector(associatedChanged) forControlEvents:UIControlEventEditingChanged];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
