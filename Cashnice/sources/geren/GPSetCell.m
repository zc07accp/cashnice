//
//  GPSetCell.m
//  Cashnice
//
//  Created by apple on 2016/11/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GPSetCell.h"

@implementation GPSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UtilFont systemLarge];    
}

- (IBAction)changed:(id)sender {
    
    if(self.changeBlock){
        self.changeBlock(self.setSwitch.on);
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
