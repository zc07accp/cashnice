//
//  MRMC2Cell.m
//  Cashnice
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MRMC2Cell.h"

@implementation MRMC2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)action1:(id)sender {
    
    if(self.TAP){
        self.TAP(0);
    }
    
}

- (IBAction)action2:(id)sender {
    if(self.TAP){
        self.TAP(1);
    }
}


@end
