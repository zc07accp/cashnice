//
//  SFMoreCell.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SFMoreCell.h"

@implementation SFMoreCell

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    self.lineView.width = MainScreenWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
