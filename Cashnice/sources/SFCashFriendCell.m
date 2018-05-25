//
//  SFCashFriendCell.m
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SFCashFriendCell.h"

@implementation SFCashFriendCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setPeople:(PersonObject *)people{
    _people = people;
    
    [self.headerImgView setHeadImgeUrlStr:people.headimg];

    if ([people.userrealname length]) {
        self.nameLabel.text = people.userrealname ;
    }else{
        self.nameLabel.text = [people.nickname length]? people.nickname:@"";
    }
    if (people.isContact && [people.phone length]) {
        self.phoneLabel.text = people.phone ;
    }else{
        self.phoneLabel.text = nil;
    }
    DLog(@"%@ %@",  self.nameLabel.text, people.headimg);
}

-(void)setSel:(BOOL)sel{
    self.selBtn.selected = sel;
}

@end
