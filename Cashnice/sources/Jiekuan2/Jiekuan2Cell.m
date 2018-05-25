//
//  JiekuanTableViewCell.m
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "Jiekuan2Cell.h"

@implementation Jiekuan2Cell



- (void)updateJiekuanState {
	self.statebgView.backgroundColor = [UtilString bgColorJiekuanState:_state];
	self.stateLabel.text             = [UtilString getJiekuanState:_state];
	
	BOOL hideInfo = _state != JieKuan_GoingNow;
	self.t1.hidden         = hideInfo;
	self.t2.hidden         = hideInfo;
	self.t3.hidden         = hideInfo;
	self.deadline.hidden   = hideInfo;
	self.remainDays.hidden = hideInfo;
}

- (void)setJiekuanState:(LoanState)state {
	_state = state;
	[self updateJiekuanState];
}


- (void)setChoukuanQi:(BOOL)dis {
	for (UILabel *l in self.choukuanqi) {
		l.hidden = dis;
	}
	self.choukuanheight.constant = [ZAPP.zdevice getDesignScale:(dis ? 0 : 22)];
}

- (void)awakeFromNib {
    self.con_w.constant = [ZAPP.zdevice getDesignScale:390];
	self.backgroundColor = [UIColor whiteColor];
	// Initialization code
	_state = JieKuan_FinishedNow;
	
	self.biaoti.textColor = ZCOLOR(COLOR_TEXT_BLACK);
	self.biaoti.font      = [UtilFont systemLargeBold];
	
	self.statebgView.layer.cornerRadius = [ZAPP.zdevice getDesignScale:2];
	self.stateLabel.textColor           = [UIColor whiteColor];
	self.stateLabel.font                = [UtilFont systemLarge];
	
	
	for (UILabel *l in self.ligthGray) {
		l.textColor = ZCOLOR(COLOR_TEXT_LIGHT_GRAY);
		l.font      = [UtilFont systemLarge];
	}
	
	for (UIView *v in self.hiddenViews) {
		v.hidden = YES;
	}
	
	for (UILabel *l in self.gray) {
		l.textColor = ZCOLOR(COLOR_TEXT_BLACK);
		l.font      = [UtilFont systemLarge];
	}
	
	for (UILabel *l in self.red) {
		l.textColor = ZCOLOR(COLOR_BUTTON_RED);
		l.font      = [UtilFont systemLarge];
	}
	
	[self.kefuButton setBackgroundColor:[UIColor clearColor]];
	[self.kefuButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
	self.kefuButton.titleLabel.font = [UtilFont systemLarge];
	self.kefuButton.hidden          = NO;
	self.kefuButton.enabled         = NO;
	
	self.dingdanButton.titleLabel.font    = [UtilFont systemLarge];
	self.dingdanButton.layer.cornerRadius = [Util getCornerRadiusSmall];
	[self.dingdanButton setBackgroundColor:ZCOLOR(COLOR_BUTTON_BLUE)];
	
	self.name.textColor =ZCOLOR(COLOR_BUTTON_BLUE);
    [super awakeFromNib];

}

- (IBAction)chaKanXiangQing:(UIButton *)sender {
	[self.delegate detailPressed:self.rowIndex];
}

- (IBAction)kefuDianHua:(UIButton *)sender {
	[Util toast:@"ke fu dian hua"];
}

- (void)setNameButtonDisabled:(BOOL)dis {
	dis                    = NO;
	self.nameButton.hidden = dis;
	self.name.textColor    = ZCOLOR(dis ? COLOR_TEXT_LIGHT_GRAY : COLOR_BUTTON_BLUE);
}

- (void)setDingdanButtonDisabled:(BOOL)dis {
	self.dingdanButton.enabled         =!dis;
	self.dingdanButton.backgroundColor = ZCOLOR(dis ? COLOR_TEXT_LIGHT_GRAY : COLOR_BUTTON_BLUE);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (IBAction)namebuttonpressed:(UIButton *)sender {
	[self.delegate namePressed:self.rowIndex];
}

@end
