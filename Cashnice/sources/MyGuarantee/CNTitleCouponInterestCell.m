//
//  CNTitleCouponInterestCell.m
//  Cashnice
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTitleCouponInterestCell.h"
#import "RedPackageWidget.h"

@interface CNTitleCouponInterestCell()
{
    RedPackageWidget *widget; //加息券
    
    UILabel *rateLabel;
}
@end

@implementation CNTitleCouponInterestCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    rateLabel = [[UILabel alloc]init];
    rateLabel.textColor = [UIColor blackColor];
    rateLabel.font = [UIFont systemFontOfSize:15];
    rateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:rateLabel];
    
    widget = [[RedPackageWidget alloc]initWithFrame:CGRectMake(0, 0, 55, 55.0/120*40) font: [UIFont systemFontOfSize:13]];
    widget.isCoupon = YES;
    [self addSubview:widget];
    
    self.showAcc = NO;
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    widget.right = self.detailTextLabel.right;
    widget.top = (self.bounds.size.height - widget.height)/2;
    
    rateLabel.width = 100;
    rateLabel.height= self.textLabel.height;
    rateLabel.right = widget.left - 2;
    rateLabel.top = (self.bounds.size.height - rateLabel.height)/2;
    
}

-(void)configure:(NSString *)rateStr couponPacket:(NSString *)packet{
    
    widget.value = packet;
    rateLabel.text = rateStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
