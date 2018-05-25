
//
//  SBBidTypeCell.m
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SBBidTypeCell.h"

@implementation SBBidTypeCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = CN_TEXT_GRAY;
}

- (IBAction)agreeAction:(id)sender {

    UIButton *button = sender;
    button.selected = !button.selected;
 
    _btn1Sel = self.button1.selected;
    _btn2Sel = self.button2.selected;
    
    if(self.SBTypeChaned){
        self.SBTypeChaned(self.button1.selected,self.button2.selected);
    }
 }

-(void)setBtn1Sel:(BOOL)btn1Sel{
    
    _btn1Sel = btn1Sel;
    self.button1.selected = _btn1Sel;
    
}

-(void)setBtn2Sel:(BOOL)btn2Sel{
    
    _btn2Sel = btn2Sel;
    self.button2.selected = _btn2Sel;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.left = SEPERATOR_LINELEFT_OFFSET;
}



@end
