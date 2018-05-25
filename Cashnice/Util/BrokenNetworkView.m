//
//  BrokenNetworkView.m
//  Cashnice
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 l. All rights reserved.
//

#import "BrokenNetworkView.h"

@implementation BrokenNetworkView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.freshBtn.layer.cornerRadius = 3;
    self.freshBtn.layer.borderWidth = 1;
    self.freshBtn.layer.borderColor = CN_COLOR_DD_GRAY.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)fresh:(id)sender {
    DLog()
//    bugeili_net_new_withouttoast

    if(self.freshAction){
        self.freshAction();
    }
    
}
@end
