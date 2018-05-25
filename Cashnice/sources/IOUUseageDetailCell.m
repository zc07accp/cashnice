//
//  IOUUseageDetailCell.m
//  Cashnice
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUUseageDetailCell.h"

@implementation IOUUseageDetailCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UILabel *)tipLabel{
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor= [UIColor whiteColor];
        _tipLabel.text = @"请添加您的出借凭证";
        _tipLabel.font = [UtilFont systemSmall];
        _tipLabel.frame = CGRectMake(0, 15, 130, 20);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

-(UIImageView *)imgView{
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 28, 10, 10);
        UIImage *streImage = [[UIImage imageNamed:@"Prompt_box"] resizableImageWithCapInsets:insets];
        
        _imgView.image = streImage;
        
    }
    
    return _imgView;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.equalTo(self.textLabel.mas_left).offset(130);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn.mas_left).offset(-10);
        make.top.equalTo(self.btn.mas_bottom);
        make.width.equalTo(@130);
        make.height.equalTo(@44);

    }];
    

    self.imgView.hidden = YES;
    [self bringSubviewToFront:self.imgView];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.btn = [[UIButton alloc]init];
    [self.btn addTarget:self action:@selector(seeTip) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setImage:[UIImage imageNamed:@"overdue_blue"] forState:UIControlStateNormal];
    [self addSubview:self.btn];
    
    [self addSubview:self.imgView];
    [self.imgView addSubview:self.tipLabel];

    return self;
}

-(void)seeTip{
    self.imgView.hidden = !self.imgView.hidden;

}

@end
