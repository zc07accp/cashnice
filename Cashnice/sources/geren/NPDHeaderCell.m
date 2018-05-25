//
//  NPDHeaderCell.m
//  Cashnice
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "NPDHeaderCell.h"

@implementation NPDHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.vipLabel.layer.cornerRadius = 11;
    self.vipLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSex:(NSInteger)sex{
    
    switch (sex) {

        case 1: //男
            self.sexImgView.image = [UIImage imageNamed:@"men"];
            break;
            
        case 2: //女
            self.sexImgView.image = [UIImage imageNamed:@"woman"];
            break;
            
        default:
            self.sexImgView.image = nil;
            break;
    }
    
}



@end
