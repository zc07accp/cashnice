//
//  BindVerification.m
//  Cashnice
//
//  Created by a on 2016/12/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BindVerification.h"

@implementation BindVerification

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = CNFontNormal;
    
    //self.getCodeBtn.titleEdgeInsets =  UIEdgeInsetsMake(0,10,0,10);;
    
    self.getCodeBtn.layer.cornerRadius =3;
    //self.getCodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;//HexRGB(0xcccccc)
    self.getCodeBtn.layer.borderColor = HexRGB(0xcccccc).CGColor;
    self.getCodeBtn.titleLabel.textColor = ZCOLOR(COLOR_LIGHT_THEME);
    self.getCodeBtn.titleLabel.font = [UtilFont systemLargeNormal];
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.masksToBounds = YES;
    
    [self.getCodeBtn sizeToFit];
    
    self.timerLabel = [[UILabel alloc] init];
    [self addSubview:self.timerLabel];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getCodeBtn);
        make.left.equalTo(self.getCodeBtn);
        make.right.equalTo(self.getCodeBtn);
        make.bottom.equalTo(self.getCodeBtn);
    }];
    
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.textColor = HexRGB(0xcccccc);
    _timerLabel.font = [UtilFont systemLarge];
}

- (void)setButtonEnabeld:(BOOL)enabled{
    self.getCodeBtn.enabled = enabled;
    self.timerLabel.hidden = enabled ? YES : NO;
    if (enabled) {
        self.getCodeBtn.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        //self.getCodeBtn.titleLabel.textColor = HexRGB(0x3399ff);
        
    }else{
        self.getCodeBtn.layer.borderColor = HexRGB(0xcccccc).CGColor;
        //self.getCodeBtn.titleLabel.textColor = HexRGB(0x3399ff);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
