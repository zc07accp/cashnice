//
//  InvestActionView.m
//  Cashnice
//
//  Created by a on 16/2/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestActionView.h"

@interface InvestActionView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) UIView *sepView;
@end

@implementation InvestActionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    _containerView.frame = self.bounds;
    _actionButton.frame = self.bounds;
    
    //    self.backgroundColor = [UIColor grayColor];
    //    _containerView.backgroundColor = [UIColor greenColor];
    
    CGFloat labelSpacing = [ZAPP.zdevice getDesignScale:5];
    [_promptLabel sizeToFit];
    _promptImageView.top = 0;
    _promptLabel.top = _promptImageView.bottom + labelSpacing;
    _promptLabel.left = (_promptImageView.width - _promptLabel.width)/2;
    
    _containerView.width = _promptImageView.width;
    _containerView.height = _promptLabel.bottom;
    _containerView.top = 0;//(self.height - _containerView.height)/2;
    _containerView.left = (self.width - _containerView.width)/2;
    
    _sepView.height = _containerView.height * 0.8;
    _sepView.top = (_containerView.height - _sepView.height)/2;
    _sepView.width = 1;
}

- (void)action{
    if (_delegate) {
        [_delegate investAction];
    }
}

- (void)setupUI{
    _containerView = [[UIView alloc] init];
    _actionButton = [[UIButton alloc] init];
    _promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"to_invest.png"]];
    _promptImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat imageSize = [ZAPP.zdevice getDesignScale:34];
    _promptImageView.frame = CGRectMake(0, 0, imageSize, imageSize);
    _promptLabel = [[UILabel alloc] init];
    
    _promptImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_actionButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    //    _promptLabel.text = _isBet==1?@"我还投":@"投资";
    //    _promptLabel.textColor = _isBet==1?CN_TEXT_BLUE: ZCOLOR(COLOR_NAV_BG_RED);
    _promptLabel.font = [UtilFont systemLarge];
    //    [_promptLabel sizeToFit];
    
    _sepView = [[UIView alloc] init];
    _sepView.backgroundColor = ZCOLOR(@"#CCCCCC");
    [self addSubview:_sepView];
    
    [_containerView addSubview:_promptLabel];
    [_containerView addSubview:_promptImageView];
    [self addSubview:_containerView];
    
    [self addSubview:_actionButton];
}

-(void)setIsBet:(NSInteger)isBet{
    _isBet = isBet;
    _promptLabel.text = isBet==1?@"我还投":@"投资";
    _promptLabel.textColor = _isBet==1?CN_TEXT_BLUE: ZCOLOR(COLOR_NAV_BG_RED);
    [_promptLabel sizeToFit];
    _promptLabel.left = (_promptImageView.width - _promptLabel.width)/2;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
