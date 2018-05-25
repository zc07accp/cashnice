//
//  JiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "Jiekuan1Cell.h"

@implementation Jiekuan1Cell

- (void)updateJiekuanState {
    self.statebgView.backgroundColor = [UtilString bgColorJiekuanState:_state];
    self.stateLabel.text = [UtilString getJiekuanState:_state];
    
    BOOL hideInfo = _state != JieKuan_GoingNow;
    self.t1.hidden = hideInfo;
    self.t2.hidden = hideInfo;
    self.t3.hidden = hideInfo;
    self.deadline.hidden = hideInfo;
    self.remainDays.hidden = hideInfo;
}

- (void)setJiekuanState:(LoanState)state {
    _state = state;
    [self updateJiekuanState];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    
    _state = JieKuan_FinishedNow;
    
    self.biaoti.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.biaoti.font = [UtilFont systemLargeBold];
    
    self.statebgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.font = [UtilFont systemSmall];

    
    for (UILabel *l in self.ligthGray) {
        l.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
        l.font = [UtilFont systemSmall];
    }
    
    for (UILabel *l in self.gray) {
        l.textColor = ZCOLOR(COLOR_TEXT_GRAY);
        l.font = [UtilFont systemSmall];
    }
    
    for (UILabel *l in self.red) {
        l.textColor = ZCOLOR(COLOR_BUTTON_RED);
        l.font = [UtilFont systemSmall];
    }
    
    self.textview.font = [UtilFont systemSmall];
    [self.changhuan setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    self.changhuan.layer.cornerRadius = [Util getCornerRadiusLarge];

}

- (IBAction)buttonPressed:(UIButton *)sender {
    [Util toast:@"chang huan"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
