//
//  GuarantorSectionCell.m
//  Cashnice
//
//  Created by a on 2016/12/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import "GuarantorSectionCell.h"

@implementation GuarantorSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.font = CNLightFont(24);
    
}


- (void)updateCellData:(NSDictionary *)data{
    
    NSString *typeTitle = data[@"type"];
    //NSUInteger count = [data[@"count"] integerValue];
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@", typeTitle];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
