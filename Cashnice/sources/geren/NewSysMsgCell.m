//
//  NewSysMsgCell.m
//  Cashnice
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NewSysMsgCell.h"

@implementation NewSysMsgCell

- (IBAction)seeDetail:(id)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bkView.layer.cornerRadius = 3;
    self.bkView.layer.masksToBounds = YES;
    
    
    self.iconView.layer.cornerRadius = 3;
    self.iconView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItemEdited:(BOOL)itemEdited{
    
    _itemEdited = itemEdited;
    
    self.tapBtn.hidden = !itemEdited;
    
//    [self.contentView setNeedsUpdateConstraints];

    if(itemEdited == YES){
        
        if (self.tapBtn.left == 10) {
            return;
        }
        
//        [UIView animateWithDuration:0.2 animations:^{
//            self.bkView.left = 60;
//        }];
        
        self.leftTapBtnConstr.constant = 10;
        
//        UIView *superview = self.contentView;
//        [self.tapBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//           make.left.equalTo(superview).mas_offset(-50);
//        }];
        
    }else{
        
//        if (self.tapBtn.left == -25) {
//            return;
//        }
        
//        [UIView animateWithDuration:0.2 animations:^{
//            self.bkView.left = 9;
//        }];
  
//        UIView *superview = self.contentView;
//        [self.tapBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(superview).mas_offset(-25);
//        }];

        self.leftTapBtnConstr.constant = -25;

        
    }
//    [self.contentView updateConstraintsIfNeeded];

//    [self.contentView setNeedsLayout];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView layoutIfNeeded];
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
 
    
}

-(void)setItemSelected:(BOOL)itemSelected{
    
    self.tapBtn.selected = itemSelected;
}

- (IBAction)tap:(id)sender {
    
    _tapBtn.selected = !_tapBtn.selected;
}

@end
