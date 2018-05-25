//
//  ServiceMessageTableViewCell.m
//  YQS
//
//  Created by a on 16/1/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ServiceMessageTableViewCell.h"

@interface ServiceMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeightConstraint;

@end

const CGFloat spaceHeightConstraintConstant = 8.0f;

@implementation ServiceMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.coverView.layer.cornerRadius = 3;
    self.coverView.layer.masksToBounds = YES;
    
    self.titleLabel.font = [ServiceMessageTableViewCell titleFont];
//    self.timeLabel.font =
//    self.contentLabel.font = [UtilFont systemLargeNormal];
    
//    self.spaceHeightConstraint.constant = [ZAPP.zdevice getDesignScale:spaceHeightConstraintConstant];
}

- (IBAction)tapDetail:(id)sender {
    if (self.TapDetail) {
        self.TapDetail();
    }
}

+ (CGFloat)cellHeightOfContentText: (NSString *)contextText isSys:(BOOL)isSys{
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    width = width * (270.0/320);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    CGFloat l_h = 0 ;
    if (isSys) {
        contextText = @"Test Text";
    }
    if ([contextText isKindOfClass:[NSString class]]) {
        
        CGRect rect = [contextText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UtilFont systemLarge]} context:nil];
        
        l_h = ceilf(rect.size.height);
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    titleLabel.font = [ServiceMessageTableViewCell titleFont];
    titleLabel.text = @"Test Title";
    [titleLabel sizeToFit];
    CGFloat t_h = ceilf(titleLabel.frame.size.height);
    
    CGFloat h = l_h + t_h + ceilf([ZAPP.zdevice getDesignScale:spaceHeightConstraintConstant])*3 + 3;
    
    return h;
}

+ (UIFont *)titleFont{
    return [UtilFont systemNormal:18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setShouldShowGoDetailLabel:(BOOL)shouldShowGoDetailLabel{
    
    _shouldShowGoDetailLabel = shouldShowGoDetailLabel;
    if (_shouldShowGoDetailLabel) {
        self.rowRight.hidden = NO;
        self.goDetailTagLabel.hidden = NO;
    }else{
        self.rowRight.hidden = YES;
        self.goDetailTagLabel.hidden = YES;


    }
    
}

@end
