//
//  BDMoneyCell.m
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BDMoneyCell.h"

@implementation BDMoneyCell


-(void)config:(NSString *)title content:(NSAttributedString *)content{
    self.titleLabel.text = title;
    self.contentLabel.attributedText = content;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
