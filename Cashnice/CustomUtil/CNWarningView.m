//
//  CNWarningView.m
//  Cashnice
//
//  Created by a on 16/11/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNWarningView.h"

@interface CNWarningView (){
    CGFloat _leftPadding;
    CNServiceWarningViewType _type;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation CNWarningView

- (instancetype)initWithType:(CNServiceWarningViewType)type{
    if (self = [super init]) {
        _type = type;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andType:(CNServiceWarningViewType)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setExternelTitle:(NSString *)externelTitle{
    _externelTitle = externelTitle;
    
    
    [self setup];
}

- (NSString *)title{
    if (self.externelTitle) {
        return self.externelTitle;
    }
    switch (_type) {
        case CNServiceWarningViewTypeNetwork:
            return @"系统正在升级维护中，稍后恢复服务，请耐心等待。";
            break;
        case CNServiceWarningViewTypeLoanReject:
            return nil; //来自于externalTitle
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (NSString *)imageName{
    switch (_type) {
        case CNServiceWarningViewTypeNetwork:
            return @"notice.png";
            break;
        case CNServiceWarningViewTypeLoanReject:
            return @"prompt_yellow.png";
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (void)setup{
    
    _leftPadding = [ZAPP.zdevice scaledValue:15.0f];
    
    self.backgroundColor = HexRGB(0xf0ead2);
    self.titleView.text = [self title];
    
    //[self addSubview:self.titleView];
    //[self addSubview:self.imageView];
}

- (void)warningViewAction{
    
    if (self.delegate) {
        [self.delegate warningViewAction];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imageSize = _type == CNServiceWarningViewTypeNetwork ? 18 : 24;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([ZAPP.zdevice scaledValue:imageSize]);
        make.height.mas_equalTo([ZAPP.zdevice scaledValue:imageSize]);
        make.left.mas_equalTo(_leftPadding);
        make.centerY.equalTo(self);
    }];
    
    CGFloat offset = _type == CNServiceWarningViewTypeNetwork ? 6 : 10;
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).mas_offset([ZAPP.zdevice scaledValue:offset]);
        make.centerY.equalTo(self);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self);
    }];
}

- (UIImageView *)imageView{
    if (! _imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self imageName]]];
        [_imageView sizeToFit];
        [self addSubview:_imageView];
    }
    return  _imageView;
}

- (UILabel *)titleView{
    if (! _titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.textColor = CN_UNI_RED;
        _titleView.font = CNLightFont(24);
        [self addSubview:_titleView];
    }
    return _titleView;
}

- (UIButton *)button{
    if (! _button) {
        _button = [[UIButton alloc] init];
        [_button addTarget:self action:@selector(warningViewAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
