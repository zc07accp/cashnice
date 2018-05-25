//
//  IDUploadTipCell.m
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IDUploadTipCell.h"

@implementation IDUploadTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.cornerRadius = 3;
    self.borderView.layer.borderColor = CN_SEPLINE_GRAY.CGColor;

    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
