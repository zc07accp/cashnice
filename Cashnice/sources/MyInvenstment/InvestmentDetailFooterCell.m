//
//  InvestmentDetailFooterCell.m
//  YQS
//
//  Created by a on 16/5/6.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentDetailFooterCell.h"

@implementation InvestmentDetailFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.font = [UtilFont systemLargeNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
