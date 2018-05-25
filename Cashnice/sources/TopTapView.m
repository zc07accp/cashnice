//
//  TopTapView.m
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TopTapView.h"

@implementation TopTapView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    DLog();
    
    self.redDot1.layer.cornerRadius = 8;
    self.redDot1.layer.masksToBounds = YES;
    
    self.redDot2.layer.cornerRadius = 8;
    self.redDot2.layer.masksToBounds = YES;

    self.yuanLabel2.font =
    self.yuanLabel1.font = [UtilFont systemSmallNormal];
    
    self.detailLabel1.font =
    self.detailLabel2.font = [UtilFont systemNormal:[ZAPP.zdevice getDesignScale:25]];
    
    self.topLabel1.font =
    self.topLabel2.font = [UtilFont systemNormal:[ZAPP.zdevice getDesignScale:18 ]];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)tap:(id)sender {
    
    NSInteger index = ((UIView *)sender).tag - 100;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topTap:)]) {
        
        [self.delegate topTap:index];
    }
    
    
}

-(void)setRed1Count:(NSInteger)count{
    if(count>0){
        self.redDot1.hidden=NO;
    }else{
        self.redDot1.hidden=YES;
        
    }
    
    self.arrow1.hidden = NO;
//    self.redDot1.hidden;

    
    self.redDot1.text = [NSString stringWithFormat:@"%@",@(count)];
}

-(void)setRed2Count:(NSInteger)count{
    if(count>0){
        self.redDot2.hidden=NO;
    }else{
        self.redDot2.hidden=YES;
    }
    
    self.arrow2.hidden = NO;
//    self.arrow2.hidden = self.redDot2.hidden;

    
    self.redDot2.text = [NSString stringWithFormat:@"%@",@(count)];

}
@end
