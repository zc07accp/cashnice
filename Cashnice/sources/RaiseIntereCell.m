//
//  RaiseIntereCell.m
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RaiseIntereCell.h"

@implementation RaiseIntereCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.bottomLineHidden = YES;
    
    if (ScreenWidth320) {
        self.widthConst.constant  = 70;
    }
    
}

-(void)setModel:(RIViewModel *)model{
    
    _imgView.image = model.bkImage;

    _rmTitleLabel.text = model.title;
    _rangLabel.text = model.range;
    _limitLabel.text = model.limit;

    _useLabel.text = model.use;
    
    _interestLabel.attributedText = model.interest;
    
    _rmTitleLabel.textColor = _useLabel.textColor = model.titleColor;
    
    _rangLabel.textColor = _limitLabel.textColor = model.detailColor;

    self.giftTag.image = [UIImage imageNamed:model.giveImage];
    
    NSLog(@"model.giveImage=%@",model.giveImage);
}

@end
