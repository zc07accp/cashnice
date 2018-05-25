//
//  RepayTypeTableViewCell.m
//  Cashnice
//
//  Created by a on 16/7/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import "RepayTypeTableViewCell.h"

@implementation RepayTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUpUI];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}

- (void)setUpUI{
    
    CGFloat leftSapceWidth = [ZAPP.zdevice getDesignScale:10.0];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftSapceWidth));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(3.4*leftSapceWidth, 3.4*leftSapceWidth));
    }];
    
    [self.checkedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-leftSapceWidth);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(2.0*leftSapceWidth, 2.0*leftSapceWidth));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).mas_offset(0.5*leftSapceWidth);
        make.centerY.equalTo(self);
//        make.right.equalTo(self.checkedImageView);
    }];
    
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1));
        make.left.equalTo(@(leftSapceWidth));
        make.width.equalTo(self.mas_width).offset(-leftSapceWidth);
        make.bottom.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (! _titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UtilFont systemLarge];
        _titleLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)headImageView{
    if (! _headImageView) {
        _headImageView = [UIImageView new];
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

- (UIImageView *)checkedImageView{
    if (! _checkedImageView) {
        _checkedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
        [self.contentView addSubview:_checkedImageView];
    }
    return _checkedImageView;
}

- (UIView *)sepLineView{
    if (!_sepLineView) {
        _sepLineView = [UIView new];
        _sepLineView.backgroundColor = ZCOLOR(COLOR_SEPERATOR_COLOR);
        [self.contentView addSubview:_sepLineView];
    }
    return _sepLineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
