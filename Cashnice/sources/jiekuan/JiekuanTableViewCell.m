//
//  JiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "JiekuanTableViewCell.h"

@implementation JiekuanTableViewCell



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
    self.con_content_w.constant = [ZAPP.zdevice getDesignScale:390];
        self.backgroundColor = [UIColor whiteColor];
    
    _state = JieKuan_FinishedNow;
    
    self.biaoti.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.biaoti.font = [UtilFont systemLargeBold];
    
    self.statebgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.font = [UtilFont systemLarge];

    
    for (UILabel *l in self.ligthGray) {
        l.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
        l.font = [UtilFont systemLarge];
    }
    
    for (UILabel *l in self.gray) {
        l.textColor = ZCOLOR(COLOR_TEXT_BLACK);
        l.font = [UtilFont systemLarge];
    }
    
    for (UILabel *l in self.red) {
        l.textColor = ZCOLOR(COLOR_BUTTON_RED);
        l.font = [UtilFont systemLarge];
    }

    self.name.textColor =ZCOLOR(COLOR_BUTTON_BLUE);
    
    self.desc1.hidden = YES;
    self.desc2.hidden = YES;
    
    self.lll1.hidden = YES;
    self.lll2.hidden = YES;
    self.lll3.hidden = YES;
    self.lll4.hidden = YES;
    self.lll5.hidden = YES;
    self.lll6.hidden = YES;
    self.lll7.hidden = YES;
    self.huanKuanButton.hidden = YES;
    
    self.huanKuanButton.titleLabel.font = [UtilFont systemLarge];
    self.huanKuanButton.layer.cornerRadius = [Util getCornerRadiusSmall];
    [self.huanKuanButton setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    
    self.touziButton.layer.cornerRadius = [Util getCornerRadiusSmall];
    [self.touziButton setBackgroundColor:ZCOLOR(COLOR_BUTTON_RED)];
    [self.touziButton setTitle:@" 我要投资 " forState:UIControlStateNormal];
    [self.touziButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.touziButton.titleLabel.font = [UtilFont systemLarge];
    self.touziButton.hidden = YES;
    
    self.lll4.textColor = [DefColor bgGreenColor];
    self.topSpaceHeight.constant = [ZAPP.zdevice getDesignScale:10];
    
    self.reFabu.hidden = YES;
    self.reFabuButton.layer.cornerRadius = [Util getCornerRadiusSmall];
    self.reFabuButton.backgroundColor = ZCOLOR(COLOR_BUTTON_BLUE);
    self.reFabuButton.titleLabel.font = [UtilFont systemLarge];
    
    self.repayButton.hidden = YES;
    self.repayButton.layer.cornerRadius = [Util getCornerRadiusLarge];
    self.repayButton.backgroundColor = ZCOLOR(COLOR_BUTTON_RED);
    self.repayButton.titleLabel.font = [UtilFont systemLarge];
    self.con_button_height.constant = 0;
    
    self.con_desc2_height.constant = [ZAPP.zdevice getDesignScale:0];
    
    self.desc_my_loan.hidden = YES;
    self.lefttitlelabelsview.hidden = YES;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    if (self)
//    {
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    }
//    return self;
//}

- (void)setNameButtonDisabled:(BOOL)dis {
    dis = NO;
    self.name.textColor = ZCOLOR(dis ? COLOR_TEXT_LIGHT_GRAY : COLOR_BUTTON_BLUE);
}

- (void)setDesc2Disabled:(BOOL)dis {
    self.desc2.hidden = dis;
    self.con_desc2_height.constant = [ZAPP.zdevice getDesignScale:dis ? 0 : 30];
}

- (void)setRepaybuttonDisabled:(BOOL)dis {
    self.repayButton.hidden = dis;
    self.con_button_height.constant = [ZAPP.zdevice getDesignScale:dis ? 0 : 60];
}

- (void)setChoukuanQi:(BOOL)dis {
    for (UILabel *l in self.choukuanqi) {
        l.hidden = dis;
    }
    self.choukuanheight.constant = [ZAPP.zdevice getDesignScale:(dis ? 0 : 22)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touziPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(touziPressed:)]) {
    [self.delegate touziPressed:(int)sender.tag];
    }
}

- (IBAction)namebuttonpressed:(UIButton *)sender {
    [self.delegate nameButtonPressedWithIndex:(int)sender.tag];
}
- (IBAction)repaybuttonpressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(repayPressed:)]) {
        [self.delegate repayPressed:(int)sender.tag];
        
    }
}
- (IBAction)huankuanbuttonpressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(huanKuanPressed:)]) {
    [self.delegate huanKuanPressed:(int)sender.tag];
        
    }
}
- (IBAction)refabuPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(refabuPressed:)]) {
    [self.delegate refabuPressed:(int)sender.tag];
    }
}
@end
