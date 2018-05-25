//
//  RedPackageWrapper.m
//  Cashnice
//
//  Created by a on 2017/2/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RedPackageWrapper.h"
#import "RedPackageWidget.h"

@interface RedPackageWrapper () {
    
    UILabel *_plushLable;
    UILabel *_yuanLable;
    RedPackageWidget *_widget;
    
    CGFloat _packagewidth;
    CGFloat _packageHight;
}

@end

@implementation RedPackageWrapper


- (instancetype)initWithPackageWidth:(CGFloat)width packageFont:(UIFont *)packageFont wrapperFont:(UIFont *)wrapperFont value:(NSString *)value x:(CGFloat)x y:(CGFloat)y{
    
    CGFloat packageHight = width * 48 / 88 ;
    
    _packagewidth = width;
    _packageHight = packageHight;
    
    
    self = [super initWithFrame:CGRectMake(x, y, 0, packageHight)];
    if (self) {
        _plushLable = [[UILabel alloc] init];
        _plushLable.textColor = [UIColor blackColor];
        _plushLable.text  =  @"+";
        _plushLable.font = wrapperFont;
        [self addSubview:_plushLable];
        
        _yuanLable = [[UILabel alloc] init];
        _yuanLable.textColor = [UIColor blackColor];
        _yuanLable.text  =  @"元";
        _yuanLable.font = wrapperFont;
        [self addSubview:_yuanLable];
        
        //rame:CGRectMake(0, 3, 50, 28) f
        _widget = [[RedPackageWidget alloc] initWithFrame:CGRectMake(0, 0, width, packageHight) font:packageFont];
        _widget.value = value;
        [self addSubview:_widget];
        
        //self.backgroundColor = [UIColor orangeColor];
    }
    
    return self;
}


- (instancetype)initWithPackageWidth:(CGFloat)width packageFont:(UIFont *)packageFont wrapperFont:(UIFont *)wrapperFont value:(NSString *)value{
    
    self = [self initWithPackageWidth:width packageFont:packageFont wrapperFont:wrapperFont value:value x:0 y:0];
    
    return self;
}

- (void)setValue:(NSString *)value{
    _value = value;
    _widget.value = _value;
}

- (void)setTextColor:(UIColor *)textColor{
    _yuanLable.textColor = textColor;
    _plushLable.textColor = textColor;
}

- (void)layoutSubviews{
    
    //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_plushLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_widget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_plushLable.mas_right).mas_offset([ZAPP.zdevice scaledValue:3]);
        make.right.equalTo(_yuanLable.mas_left).mas_offset([ZAPP.zdevice scaledValue:-3]);
        
        make.width.mas_equalTo(_packagewidth);
        make.height.mas_equalTo(_packageHight);
        
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [_yuanLable mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(2);
        //make.left.equalTo(_plushLable).mas_offset(50);
    }];
    
    [_plushLable sizeToFit];
    [_yuanLable sizeToFit];
    
    self.width = _packagewidth + _plushLable.width + _yuanLable.width + 4;

    //self.backgroundColor = [UIColor greenColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
