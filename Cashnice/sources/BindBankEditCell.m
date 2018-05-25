//
//  BindBankEditCell.m
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BindBankEditCell.h"

@implementation BindBankEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = self.textField.font = CNFontNormal;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title andPlaceholder:(NSString *)placeholder {
    self.titleLabel.text = title;
    self.textField.placeholder = placeholder;
}

- (IBAction)textFiledValueChanged:(id)sender {
    if (self.delegate) {
        [self.delegate textFiledValueChanged:sender];
    }
}

@end
