//
//  SBRightSwithCell.m
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SBRightSwithCell.h"

@implementation SBRightSwithCell

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
    self.textLabel.textColor = CN_TEXT_BLACK;
}


- (IBAction)change:(id)sender {
    
    if (self.Switch) {
        self.Switch(self.rightSwitch.on);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.left = SEPERATOR_LINELEFT_OFFSET;
}


@end
