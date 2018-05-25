//
//  CNTitleDetailArrowBlueTipCell.m
//  Cashnice
//
//  Created by apple on 2017/1/21.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTitleDetailArrowBlueTipCell.h"

@implementation CNTitleDetailArrowBlueTipCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.btn = [[UIButton alloc]init];
    [self.btn addTarget:self action:@selector(seeProtocal) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setImage:[UIImage imageNamed:@"cardholder_hint"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btn];
    
    
    self.btn.frame = CGRectMake(self.textLabel.left + 75, ([ZAPP.zdevice getDesignScale:LISTDETAIL_ROW_HEIGHT] - 16)/2, 16, 16);
    
    return self;
}


-(void)seeProtocal{
    
    if (self.tip) {
        [Util toast:self.tip];
    }
}


@end
