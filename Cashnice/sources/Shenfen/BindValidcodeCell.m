//
//  FabuJiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BindValidcodeCell.h"

@implementation BindValidcodeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.tf.font = [UtilFont systemLarge];
    self.tf.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    
    self.validButton.titleLabel.font = [UtilFont systemLarge];
    self.validLabel.font = [UtilFont systemLarge];
    self.validLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    [self.validButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
    [self.validButton setTitle:@"" forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)vali:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.delegate uploadIdCardPressed];
    }
    else {
        [self.delegate sendPressed];
    }
}

- (void)setUploadImageStyle {
    [self.validButton setTitleColor:ZCOLOR(COLOR_BUTTON_RED) forState:UIControlStateNormal];
    [self.validButton setTitle:@"上传身份证照" forState:UIControlStateNormal];
    self.validLabel.hidden = YES;
}

@end
