
//
//  IOUDetailBtnCell.m
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailBtnCell.h"
#import "IOU.h"

@implementation IOUDetailBtnCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configureTitle:(NSString *)title{
    [self.sureBtn setTitle:title forState:UIControlStateNormal];
}

- (IBAction)action:(id)sender {
    
    if (self.ButtonAction) {
        self.ButtonAction(self.sureBtn);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bottomLineHidden = YES;
    
    
    self.sureBtn.left = self.width - 19 - BLUESURE_WIDTH;

}

@end
