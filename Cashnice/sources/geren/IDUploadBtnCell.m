//
//  IDUploadBtnCell.m
//  Cashnice
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IDUploadBtnCell.h"

@implementation IDUploadBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn.layer.cornerRadius = 3;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAvailable:(BOOL)available{
    
    self.btn.backgroundColor = available?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_BUTTON_DISABLE);

    NSString*text = @"请上传身份证";
    [self.btn setTitle:text forState:UIControlStateNormal];
    self.btn.userInteractionEnabled = available;
    
}

- (IBAction)action:(id)sender {
    
    if (self.uploadIDCardAction) {
        self.uploadIDCardAction();
    }
}

@end
