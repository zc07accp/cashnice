//
//  RedPackageWidget.m
//  Cashnice
//
//  Created by a on 2017/2/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RedPackageWidget.h"

@interface RedPackageWidget () {
    
    UIImage     *_backImage;
    UIImageView *_backImageView;
    
    UILabel     *_valueLable;
}

@end

@implementation RedPackageWidget

- (instancetype)initWithFont:(UIFont*)font{
    self = [super init];
    if (self) {
        _valueLable = [[UILabel alloc] init];
        _backImageView = [[UIImageView alloc] init];
        
        [self setupWithFont:font];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font{
    self = [super initWithFrame:frame];
    if (self) {
        _valueLable = [[UILabel alloc] initWithFrame:frame];
        _backImageView = [[UIImageView alloc] initWithFrame:frame];
        
        [self setupWithFont:font];
    }
    return self;
}

- (void)setupWithFont:(UIFont *)font{
    
    _valueLable.font = font;
    _valueLable.lineBreakMode = 0;
    
    _backImage = [UIImage imageNamed:@"packetbj.png"];
    _valueLable.textColor = [UIColor whiteColor];
    _valueLable.textAlignment = NSTextAlignmentCenter;
    
    _backImageView.image = _backImage;
    
    //_valueLable.hidden = YES;
    
    [self addSubview:_backImageView];
    [self addSubview:_valueLable];
}

- (void)setIsCoupon:(BOOL)isCoupon{
    _isCoupon = isCoupon;
    if (isCoupon) {
        _backImage = [UIImage imageNamed:@"ticketbj.png"];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.image = _backImage;
        
        CGFloat arrowOffset = self.width / 12;
        
        _valueLable.width = self.width - arrowOffset;
        //_valueLable.right = self.right;
        _valueLable.left = arrowOffset;
        
        //_valueLable.backgroundColor = [UIColor greenColor];
        
        [self setNeedsDisplay];
    }
}

- (void)setValue:(NSString *)value{
    _value = value;
    _valueLable.text = value;
    
    //[_valueLable sizeToFit];
    
    //_valueLable.backgroundColor = [UIColor cyanColor];
    
    //_valueLable.center = CGPointMake(_valueLable.center.x, self.center.y);

    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _backImageView.left = (self.width - _backImageView.width)/2;
    //_valueLable.left = (self.width - _valueLable.width)/2;
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
