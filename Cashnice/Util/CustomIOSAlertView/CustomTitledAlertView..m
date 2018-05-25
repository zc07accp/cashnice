//
//  CustomAutoCloseAlertView.m
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomTitledAlertView.h"

@interface CustomTitledAlertView  () <CustomTitledAlertViewDelegate>
{
    NSString *newVersion;
    NSString *newFileSize;
    UILabel *messageLabel;
    UIView *headSeparator;
    
    NSTextAlignment msgTextAligment;
}

@end

@implementation CustomTitledAlertView

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

- (void)show
{
    self.delegate  =  self;
    
    [self setButtonTitles:@[@"我知道了"]];
    
    [super show];
    
    [self formatAlertButton];
}

- (void)setupUpdateContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self countScreenSize].width*.8, [self countScreenSize].height)];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, (NSInteger)([ZAPP.zdevice getDesignScale:40]))];

    headLable.text = self.title;
    headLable.font = [UtilFont systemLarge];
    headLable.textColor = [UIColor blackColor];
    headLable.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:headLable];
    
    CGFloat separatorPadding = IPHONE6_ORI_VALUE(15);
    CGFloat separatorHeight = 1;
    
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
    
    UILabel *updateInfo = [[UILabel alloc] initWithFrame:CGRectMake((NSInteger)( separatorPadding), (NSInteger)(headSeparator.bottom + separatorPadding), (NSInteger)(contentView.width- 2* separatorPadding), 0)];
//    updateInfo.text = self.message;
    
    if (msgTextAligment) {
        updateInfo.top =  (NSInteger)(headSeparator.bottom + separatorPadding)-30;
        updateInfo.height = 20;
        updateInfo.font = [UtilFont systemSmall];
        updateInfo.textColor = ZCOLOR(COLOR_TEXT_GRAY);
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
        messageLabel = updateInfo;
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 120)];
//    label.numberOfLines = 0;
//    label.textColor = ZCOLOR(COLOR_TEXT_GRAY);
//    label.font = [UIFont systemFontOfSize:15.0f];
//    
//
//    [contentView addSubview:label];
    if (self.message.length > 1) {
        contentView.height = updateInfo.bottom + separatorPadding;
    }else{
        contentView.height = headSeparator.bottom;
    }
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
