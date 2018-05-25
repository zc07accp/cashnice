//
//  IOUDetailTopCell.m
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailTopCell.h"

@implementation IOUDetailTopCell

-(void)setDetailUnit:(IOUDetailUnit *)detailUnit{
    
    _detailUnit = detailUnit;
 
    NSString *leftImageUrl = detailUnit.srcUser[@"head_img"];
    NSString *leftName = [IOUDetailUnit getUserRealNameOrNickName:detailUnit.srcUser];

    [self.leftImgView setHeadImgeUrlStr:leftImageUrl];
    self.leftNameL.text = leftName;
    
    NSString *rightImageUrl = detailUnit.destUser[@"head_img"];
    NSString *rightName = [IOUDetailUnit getUserRealNameOrNickName:detailUnit.destUser];

    [self.rightImgView setHeadImgeUrlStr:rightImageUrl];
    self.rightNameL.text = rightName;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bottomLineHidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
