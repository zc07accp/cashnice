//
//  LDThreeLabelCell.m
//  Cashnice
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "LDThreeLabelCell.h"

@implementation LDThreeLabelCell

-(void)layoutSubviews{
    [super layoutSubviews];
    

    [self.centralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(@(MainScreenWidth/2));
        make.height.equalTo(@30);
    }];
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI{
    self.textLabel.textColor = CN_TEXT_GRAY_9;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK) ;
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.centralLabel = [[UILabel alloc]init];
    self.centralLabel.font = [UIFont systemFontOfSize:15];
    self.centralLabel.textColor = ZCOLOR(COLOR_TEXT_BLACK) ;
    [self.contentView addSubview:self.centralLabel];
    self.centralLabel.text = @"aaaa";
}

-(void)configureTitle:(NSString *)title detail:(NSString *)detail centralTitle:(NSString *)centralTitle{
    
    self.bottomLineHidden = YES;
    
    if (!title) {
        return;
    }
    self.textLabel.text =  title;
    self.detailTextLabel.text = detail.length?detail: @"";
    self.centralLabel.text = centralTitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
