//
//  SelIDCell.m
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SelIDCell.h"

@implementation SelIDCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.textColor = CN_TEXT_GRAY ;
}

- (IBAction)selIDAction:(id)sender {
    
    NSInteger index = ((UIView *)sender).tag - 100;

    if (sender == _btn0) {
        self.btn1.selected = NO;
        self.btn0.selected = YES;

    }else{
        self.btn0.selected = NO;
        self.btn1.selected = YES;

    }
    
    if (self.SelID) {
        self.SelID(index);
    }
    
}

-(void)configureSelID:(NSInteger)index buttonEnabled:(BOOL)enabled{

    if (index == 0) {
        self.btn1.selected = NO;
        self.btn0.selected = YES;
        
    }else{
        self.btn0.selected = NO;
        self.btn1.selected = YES;
        
    }

    self.btn0.userInteractionEnabled = enabled;
    self.btn1.userInteractionEnabled = enabled;
    
    self.bottomLineHidden = NO;

}



@end
