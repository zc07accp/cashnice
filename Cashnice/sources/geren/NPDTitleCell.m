//
//  NPDTitleCell.m
//  Cashnice
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NPDTitleCell.h"

@implementation NPDTitleCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.rightLabelType = RIGHTLABEL_RIGHTSPACE_SHOWACC;
    self.bottomLineHidden = NO;
    self.leftSpace = YES;
}

-(void)setIdentified:(NSInteger)identified{
    
    _identified = identified;
    
    NSString *imgname = nil;
    switch (identified) {
        case NPD_NOT_IDENTIFY:
            imgname = @"box_no";
            break;
            
        case NPD_IDENTIFIED:
            imgname = @"box_yes";
            break;
            
            
            
        default:
            imgname = nil;
            break;
    }
    
    self.identifyImgView.image = [UIImage imageNamed:imgname];
}

@end
