//
//  CNTitleCouponCell.m
//  Cashnice
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTitleCouponCell.h"
#import "RedPackageWrapper.h"

@interface CNTitleCouponCell()
{
    RedPackageWrapper *redPacketWraper; //红包
    
    UILabel *principalLabel;
}
@end

@implementation CNTitleCouponCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    principalLabel = [[UILabel alloc]init];
    principalLabel.textColor = [UIColor blackColor];
    principalLabel.font = [UIFont systemFontOfSize:15];
    principalLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:principalLabel];
    
    redPacketWraper = [[RedPackageWrapper alloc]initWithPackageWidth:30 packageFont:[UIFont systemFontOfSize:13] wrapperFont:[UIFont systemFontOfSize:15] value:@""];
    [self addSubview:redPacketWraper];
    
    self.showAcc = NO;
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
 
    redPacketWraper.right = self.detailTextLabel.right;
    redPacketWraper.top = (self.bounds.size.height - redPacketWraper.height)/2;
    
    principalLabel.width = 100;
    principalLabel.height= self.textLabel.height;
    principalLabel.right = redPacketWraper.left - 2;
    principalLabel.top = (self.bounds.size.height - redPacketWraper.height)/2;

}

-(void)configure:(NSString *)principalStr couponPacket:(NSString *)packet{
    
    redPacketWraper.value = packet;
    principalLabel.text = principalStr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
