//
//
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "AllMoneyTipAlertView.h"

@interface AllMoneyTipAlertView  () <AllMoneyTipAlertViewDelegate>
{
    NSString *newVersion;
    NSString *newFileSize;
    UILabel *messageLabel;
    UIView *headSeparator;
    
    NSTextAlignment msgTextAligment;
}

@end

@implementation AllMoneyTipAlertView

- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo {
    if (self = [super init]) {
        self.title = aTitle;
        self.message = messageInfo;
        [self setupUpdateContentView];
    }
    return self;
}


- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo msgTextAli:(NSTextAlignment)textalig{
    if (self = [super init]) {
        self.title = aTitle;
        self.message = messageInfo;
        msgTextAligment = textalig;
        [self setupUpdateContentView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo andInfo1:(NSString *)balanceInfo andInfo2:(NSString *)waitMoneyInfo msgTextAli:(NSTextAlignment)textalig{
    if (self = [super init]) {
        self.title = aTitle;
        self.message = messageInfo;
        self.balanceMoney = balanceInfo;
        self.waitMoney = waitMoneyInfo;
        msgTextAligment = textalig;
        [self setupUpdateContentView];
    }
    return self;
}

- (void)show
{
    self.delegate  =  self;
    
    [self setButtonTitles:@[@"我知道了"]];
    
    [super show];
    
    [self formatAlertButton];
}

- (void)setupUpdateContentView {
    CGFloat separatorPadding = IPHONE6_ORI_VALUE(15);
    CGFloat separatorHeight = 1;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self countScreenSize].width*.8, [self countScreenSize].height)];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, contentView.width, (NSInteger)([ZAPP.zdevice getDesignScale:40]))];
    
    headLable.text = self.title;
    headLable.font = [UtilFont systemSmall];
    headLable.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
    headLable.textAlignment = NSTextAlignmentCenter;
    
    [contentView addSubview:headLable];
    
    headSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, headLable.height, contentView.width, separatorHeight)];
    headSeparator.backgroundColor = self.separatorLineColor;
    
    if (self.message.length > 0) {
        [contentView addSubview:headSeparator];
    }
    //    UILabel *bundleInfo = [[UILabel alloc] initWithFrame:CGRectMake(separatorPadding, headSeparator.bottom + separatorPadding, contentView.width- 2* separatorPadding, 0)];
    //    bundleInfo.text = [NSString stringWithFormat:@"最新版本：%@\n版本大小：%@", newVersion, newFileSize];
    //    bundleInfo.font = [UtilFont systemLarge];
    //    bundleInfo.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    //    bundleInfo.numberOfLines = 2;
    //    [bundleInfo sizeToFit];
    //    [contentView addSubview:bundleInfo];
    
    UILabel *updateInfo = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)( separatorPadding), (NSInteger)(headSeparator.bottom -[ZAPP.zdevice getDesignScale:20]), (NSInteger)(contentView.width- 2* separatorPadding), 0)];
    //    updateInfo.text = self.message;
    
    if (msgTextAligment) {
        updateInfo.top =  (NSInteger)(headSeparator.bottom + separatorPadding)-30;
        updateInfo.height = 20;
        updateInfo.font = [UIFont boldSystemFontOfSize:15];
        updateInfo.textColor = ZCOLOR(COLOR_BUTTON_BLUE);
        updateInfo.textAlignment = msgTextAligment;
        updateInfo.text = self.message;
        updateInfo.numberOfLines = 0;
        
    }else{
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.message];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.message length])];
        
        [attributedString1 addAttribute:NSFontAttributeName value:[UtilFont systemSmall]  range:NSMakeRange(0, self.message.length)];
        
        [attributedString1 addAttribute:NSForegroundColorAttributeName value: ZCOLOR(COLOR_TEXT_GRAY) range:NSMakeRange(0, self.message.length)];
        
        [updateInfo setAttributedText:attributedString1];
        updateInfo.numberOfLines = 0;
        [updateInfo sizeToFit];
        
        
    }
    
    
    
    //    updateInfo.font = [UtilFont systemSmall];
    //    updateInfo.textColor = [UIColor blackColor];;
    [contentView addSubview:updateInfo];
    //    messageLabel = updateInfo;
    //
    //    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 120)];
    //    //    label.numberOfLines = 0;
    //    //    label.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    //    //    label.font = [UIFont systemFontOfSize:15.0f];
    //    //
    //    //
    //    //    [contentView addSubview:label];
    //    if (self.message.length > 1) {
    //        contentView.height = updateInfo.bottom + separatorPadding;
    //    }else{
    //        contentView.height = headSeparator.bottom;
    //    }
    
    UILabel *balanceTip = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)(separatorPadding), (NSInteger)(updateInfo.bottom-[ZAPP.zdevice getDesignScale:5]), (NSInteger)(updateInfo.width/5*2),(NSInteger)([ZAPP.zdevice getDesignScale:40]))];
    balanceTip.text = @"账户余额（元）";
    balanceTip.textColor = [UIColor blackColor];
    balanceTip.textAlignment = NSTextAlignmentCenter;
    balanceTip.font = [UtilFont systemSmall];
    [contentView addSubview:balanceTip];
    
    UILabel *jia = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)( balanceTip.right), (NSInteger)(updateInfo.bottom-[ZAPP.zdevice getDesignScale:5]), (NSInteger)(balanceTip.width/2),(NSInteger)([ZAPP.zdevice getDesignScale:60]))];
    jia.text = @"+";
    jia.textColor = [UIColor blackColor];
    jia.textAlignment = NSTextAlignmentCenter;
    jia.font = [UIFont boldSystemFontOfSize:15];
    [contentView addSubview:jia];
    
    UILabel *waitMoneyTip = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)( jia.right), (NSInteger)(updateInfo.bottom-[ZAPP.zdevice getDesignScale:5]), (NSInteger)(balanceTip.width),(NSInteger)([ZAPP.zdevice getDesignScale:40]))];
    waitMoneyTip.text = @"待回收本金";
    waitMoneyTip.textColor = [UIColor blackColor];
    waitMoneyTip.textAlignment = NSTextAlignmentCenter;
    waitMoneyTip.font = [UtilFont systemSmall];
    [contentView addSubview:waitMoneyTip];
    
    UILabel *balanceMoney = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)(separatorPadding), (NSInteger)(balanceTip.bottom-[ZAPP.zdevice getDesignScale:20]), (NSInteger)(balanceTip.width),(NSInteger)([ZAPP.zdevice getDesignScale:40]))];
    balanceMoney.text = self.balanceMoney;
    balanceMoney.textColor = [UIColor blackColor];
    balanceMoney.textAlignment = NSTextAlignmentCenter;
    balanceMoney.font = [UIFont boldSystemFontOfSize:15];
    
    [contentView addSubview:balanceMoney];
    
    UILabel *waitMoney = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)( jia.right), (NSInteger)(balanceTip.bottom-[ZAPP.zdevice getDesignScale:20]), (NSInteger)(balanceTip.width),(NSInteger)([ZAPP.zdevice getDesignScale:40]))];
    waitMoney.text = self.waitMoney;
    waitMoney.textColor = [UIColor blackColor];
    waitMoney.textAlignment = NSTextAlignmentCenter;
    waitMoney.font = [UIFont boldSystemFontOfSize:15];
    [contentView addSubview:waitMoney];
    
    messageLabel = balanceMoney;
    contentView.height = messageLabel.bottom + separatorHeight;
    [self setContainerView:contentView];
}

- (void)formatAlertButton {
    for (UIView *view in self.dialogView. subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == 0) {
                UIColor *color = ZCOLOR(COLOR_NAV_BG_RED);
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitleColor:color forState:UIControlStateHighlighted];
                button.titleLabel.font = [UtilFont systemSmall];
            }
            if (button.tag == 1) {
                UIColor *color = ZCOLOR(COLOR_NAV_BG_RED);
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitleColor:color forState:UIControlStateHighlighted];
                button.titleLabel.font = [UtilFont systemSmall];
            }
        }
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self close];
}

-(void)setMessageTextColor:(UIColor *)messageTextColor{
    
    if(messageTextColor){
        messageLabel.textColor = messageTextColor;
    }
    
}

-(void)setHideHeadline:(BOOL)hideHeadline{
    
    _hideHeadline = hideHeadline;
    headSeparator.hidden = _hideHeadline;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

