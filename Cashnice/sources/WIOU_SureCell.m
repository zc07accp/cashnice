//
//  WIOU_SureCell.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WIOU_SureCell.h"
#import "WebViewController.h"
#import "IOU.h"

@implementation WIOU_SureCell

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bottomLineHidden = YES;
    
//    CGFloat WIDTH =  self.sureButton.width;
    
    self.sureButton.left = self.width - 19 - BLUESURE_WIDTH;
    
}

- (IBAction)agreeAction:(id)sender {
    
    _agreeButton.selected =!_agreeButton.selected;
    
    if (_SelAgree) {
        self.SelAgree(_agreeButton.selected);
    }
}

- (IBAction)seeAgree:(id)sender {

    if (self.SeeAgree) {
        self.SeeAgree();
    }
}

- (IBAction)send:(id)sender {
    if (self.WIOU_Sure) {
        self.WIOU_Sure();
    }
}

-(void)configureSelAgree:(BOOL)agree fee:(CGFloat)fee{
    _agreeButton.selected = agree;
    _feeLabel.text = [NSString stringWithFormat:@"到期本息合计约为%@元",[Util formatRMBWithoutUnit:@(fee)]
                      ];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
