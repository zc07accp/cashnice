//
//  AmountOfMoneyView.m
//  Cashnice
//
//  Created by a on 16/2/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "AmountOfMoneyView.h"

@interface AmountOfMoneyView()
@property (nonatomic, strong) UILabel *amountLable;
@property (nonatomic, strong) UILabel *unitLable;

@property (nonatomic, strong) UIColor *backColor;
@end

@implementation AmountOfMoneyView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    [self.amountLable sizeToFit];
    CGRect frame = self.amountLable.frame;
    frame.origin.x = frame.origin.y = 0;
    frame.size.height = self.height;
    self.amountLable.frame = frame;
    
    frame = self.unitLable.frame;
    frame.origin.x = self.amountLable.right;
    frame.origin.y = 0;
    frame.size.width = self.width - self.amountLable.width;
    frame.size.height = self.height;
    self.unitLable.frame = frame;
    
    self.amountLable.textColor = self.unitLable.textColor = self.backColor;
}

- (void)setupUI{
    [self addSubview:self.amountLable];
    [self addSubview:self.unitLable];
}

- (void)setIsLight:(BOOL)isLight{
    _isLight = isLight;
    [self setNeedsLayout];
}

- (void)setAmount:(NSString *)amount{
    _amount = amount;
    self.amountLable.text = amount;
    [self setNeedsLayout];
}

- (UIColor *)backColor{
    return self.isLight?ZCOLOR(@"#3399ff"):ZCOLOR(COLOR_NAV_BG_RED);
}

- (UILabel *)amountLable{
    if (! _amountLable) {
        _amountLable = [[UILabel alloc]init];
        _amountLable.font = [UtilFont systemAmountTitle];
    }
    return _amountLable;
}
- (UILabel *)unitLable{
    if (! _unitLable) {
        _unitLable = [[UILabel alloc]init];
        _unitLable.text = @"元";
        _unitLable.font = [UtilFont system:25];
    }
    return _unitLable;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
