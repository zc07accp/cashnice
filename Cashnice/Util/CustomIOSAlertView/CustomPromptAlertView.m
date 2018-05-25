//
//  CustomAutoCloseAlertView.m
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomPromptAlertView.h"

@interface CustomPromptAlertView  () <CustomIOSAlertViewDelegate>
{
    NSString *newVersion;
    NSString *newFileSize;
}

@end

@implementation CustomPromptAlertView


- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo {
    if (self = [super init]) {
        self.title = aTitle;
        self.message = messageInfo;
        [self setupUpdateContentView];
    }
    return self;
}

- (void)show
{
    if (! self.delegate) {
        self.delegate  =   self;
    }
    
    [self setButtonTitles:@[@"我知道了"]];
    
    [super show];
    
    [self formatAlertButton];
}

- (void)setupUpdateContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self countScreenSize].width*.6, [self countScreenSize].width*.7*.9)];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, [ZAPP.zdevice getDesignScale:40])];
    headLable.text = self.title;
    headLable.font = [UtilFont systemLargeBold];
    headLable.textColor = [UIColor blackColor];
    headLable.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:headLable];
    
    CGFloat separatorPadding = [ZAPP.zdevice getDesignScale:10];
    CGFloat separatorHeight = [ZAPP.zdevice getDesignScale:1];
    
    UIView *headSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, headLable.height, contentView.width, separatorHeight)];
    headSeparator.backgroundColor = self.separatorLineColor;
    
//    if (self.message.length > 0) {
//        [contentView addSubview:headSeparator];
//    }
    
    
    UILabel *updateInfo = [[UILabel alloc] initWithFrame:CGRectMake(separatorPadding, headSeparator.bottom, contentView.width- 2* separatorPadding, 0)];
    updateInfo.text = self.message;
    updateInfo.font = [UtilFont systemLargeNormal];
    updateInfo.textColor = [UIColor blackColor];;
    updateInfo.numberOfLines = 0;
    updateInfo.textAlignment = NSTextAlignmentCenter;
    [updateInfo sizeToFit];
    [contentView addSubview:updateInfo];
    
    [updateInfo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headLable.mas_bottom).mas_offset(0);
        make.centerX.equalTo(contentView);
    }];
    
    //contentView.backgroundColor = [UIColor cyanColor];
    //updateInfo.backgroundColor = [UIColor redColor];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 120)];
//    label.numberOfLines = 0;
//    label.textColor = ZCOLOR(COLOR_TEXT_GRAY);
//    label.font = [UIFont systemFontOfSize:15.0f];
//    
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.message];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:8];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.message length])];
//    [label setAttributedText:attributedString1];
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
                button.titleLabel.font = [UtilFont systemLargeNormal];
            }
            if (button.tag == 1) {
                UIColor *color = ZCOLOR(COLOR_NAV_BG_RED);
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitleColor:color forState:UIControlStateHighlighted];
                button.titleLabel.font = [UtilFont systemLargeNormal];
            }
        }
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self close];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
