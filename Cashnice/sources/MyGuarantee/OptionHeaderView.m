//
//  OptionHeaderView.m
//  YQS
//
//  Created by a on 16/5/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "OptionHeaderView.h"

@interface OptionHeaderView ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) UIView *sepLine;

@end

@implementation OptionHeaderView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //背景白色
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat spaceSize = [ZAPP.zdevice getDesignScale:10];
    self.contentView.frame = CGRectMake(spaceSize, 0, CGRectGetWidth(self.bounds)-2*spaceSize, CGRectGetHeight(self.bounds));
    
    self.promotImage.center = self.contentView.center;
    self.promotImage.left = 0;
    
    self.titleLabel.width = self.contentView.width;
    self.titleLabel.height = self.contentView.height;
    self.titleLabel.left = self.promotImage.right + 10;
    
    self.arrowView.top = (self.height - self.arrowView.height)/2;
    self.arrowView.right = self.contentView.width;
    
    self.sepLine.frame = CGRectMake(0, self.height-1 , self.width, 1);
    
    self.actionButton.frame = self.bounds;
}

- (void)didTouchedAction : (id) sender {
    
    self.isActive = !self.isActive;
    
    if ([self.delegate respondsToSelector:@selector(optionHeaderDidTouched:active:)]) {
        [self.delegate optionHeaderDidTouched:self active:self.isActive];
    }
}

-(void)setIsActive:(BOOL)isActive{
    _isActive = isActive;
    
    // 旋转箭头
    float angle = self.isActive ? M_PI : 0;
    [UIView animateWithDuration:0.2f animations:^{
        self.arrowView.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (UIView *)contentView{
    if (! _contentView) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (! _titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        _titleLabel.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
        _titleLabel.font = [UtilFont systemLargeNormal];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)actionButton {
    if (! _actionButton) {
        _actionButton = [[UIButton alloc] init];
        [self.contentView addSubview:_actionButton];
        [_actionButton addTarget:self action:@selector(didTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (UIImageView *)arrowView {
    if (! _arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_bottom"]];
        [self.contentView addSubview:_arrowView];
    }
    return _arrowView;
}

- (UIView *)sepLine{
    if (! _sepLine) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = ZCOLOR(@"#DDDDDD");
        [self addSubview:_sepLine];
    }
    return _sepLine;
}

- (UIImageView *)promotImage{
    if (! _promotImage) {
        _promotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _promotImage.contentMode = UIViewContentModeCenter;
        _promotImage.image = [UIImage imageNamed:@"date_yj.png"];
        [self.contentView addSubview:_promotImage];
    }
    return _promotImage;
}
@end
