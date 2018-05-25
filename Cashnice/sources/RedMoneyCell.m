//
//  RedMoneyCell.m
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "RedMoneyCell.h"

@implementation RedMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bkView.layer.masksToBounds = YES;
    self.bkView.layer.cornerRadius  = 3;
    self.bkView.layer.borderWidth = 0.5;
    
    self.bottomLineHidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(RMViewModel *)model{
    
    self.numLabel.textColor = self.useLabel.textColor = self.mtLabel.textColor = model.leftColor;
    
    self.rmTitleLabel.textColor = model.rightTopColor;
    self.rangLabel.textColor = self.limitLabel.textColor = model.rightBottomColor;
    
    self.numLabel.text = model.money;
    self.useLabel.text = model.use;
 
    self.rmTitleLabel.text = model.title;
    self.rangLabel.text = model.range;
    self.limitLabel.text = model.limit;
    
    self.bkView.layer.borderColor = model.borderColor.CGColor;
    self.bkImgView.image = model.bkImage;
    
    self.giftTag.image = [UIImage imageNamed:model.giveImage];
}

@end
