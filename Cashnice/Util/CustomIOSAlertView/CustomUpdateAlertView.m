//
//  CustomAutoCloseAlertView.m
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomUpdateAlertView.h"
#import "UpdateManager.h"

@interface CustomUpdateAlertView  () <CustomIOSAlertViewDelegate>
{
    NSString *newVersion;
    NSString *newFileSize;
}

@end

@implementation CustomUpdateAlertView

- (id)initWithUpdateInfo:(NSDictionary *)updateInfoDict {
    if (self = [super init]) {
        newVersion = updateInfoDict[@"version"];
        newFileSize = updateInfoDict[@"update_filesize"];
        self.isForced = [updateInfoDict[@"updatetype"] boolValue];
        //NSInteger filesize = [updateInfoDict[@"update_filesize"] integerValue];
        self.message = updateInfoDict[@"updatemessage"];
        
        [self setupUpdateContentView];
    }
    return self;
}

- (id)initWithMessage:(NSString *)message updateDelegate:(id<CustomUpdateAlertViewDelegate>)updateDelegate isForced:(BOOL)forced {

    if (self = [super init]) {
        self.message = message;
        self.updateDelegate = updateDelegate;
        self.isForced = forced;
        [self setupUpdateContentView];
        
    }
    return self;
}

- (void)show
{
    self.delegate  =  self;
    
    if (! self.isForced) {
        [self setButtonTitles:@[@"以后再说", @"立即更新"]];
    }else{
        [self setButtonTitles:@[@"立即更新"]];
    }
    
    [super show];
    
    [self formatAlertButton];
}


- (void)setupUpdateContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, floor([self countScreenSize].width*.8), [self countScreenSize].height)];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(0, -50, contentView.width, (contentView.width * 324.0 / 584.0));
    headImageView.image = [UIImage imageNamed:@"new-version_bg.png"];
    headImageView.contentMode = UIViewContentModeScaleToFill;
    [contentView addSubview:headImageView];
    
    UILabel *headLable = [[UILabel alloc] init]; //WithFrame:CGRectMake([ZAPP.zdevice getDesignScale:0], 0, contentView.width, [ZAPP.zdevice getDesignScale:40])
    headLable.text = @"发现新版本";
    headLable.font = CNFont_42px;
    headLable.textColor = [UIColor whiteColor];
    headLable.textAlignment = NSTextAlignmentLeft;
    [headLable sizeToFit];
    headLable.left = [ZAPP.zdevice getDesignScale:42];
    headLable.top = [ZAPP.zdevice getDesignScale:26];
    [contentView addSubview:headLable];
    
    
    CGFloat separatorPadding = [ZAPP.zdevice getDesignScale:10];
    CGFloat separatorHeight = [ZAPP.zdevice getDesignScale:1];
    /*
    UIView *headSeparator = [[UIView alloc]initWithFrame:CGRectMake(separatorPadding, headLable.height, contentView.width - 2* separatorPadding, separatorHeight)];
    headSeparator.backgroundColor = self.separatorLineColor;
    [contentView addSubview:headSeparator];
    */
    
    UILabel *bundleInfo = [[UILabel alloc] initWithFrame:CGRectMake(separatorPadding, headImageView.bottom, contentView.width- 2* separatorPadding, 0)];
    bundleInfo.text = [NSString stringWithFormat:@"这个版本(%@)我们为您做了这些：", newVersion];
    bundleInfo.font = CNFont_28px;
    bundleInfo.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    bundleInfo.numberOfLines = 1;
    [bundleInfo sizeToFit];
    [contentView addSubview:bundleInfo];
    
    UILabel *updateInfo = [[UILabel alloc] initWithFrame:CGRectMake(separatorPadding, bundleInfo.bottom + separatorPadding, contentView.width- 2* separatorPadding, 0)];
    updateInfo.text = self.message; //@"1.更新通知\n2.更新通知更新通知\n3.更新通知更新通知更新通知"
    updateInfo.font = CNFont_28px;
    updateInfo.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    updateInfo.numberOfLines = 0;
    [updateInfo sizeToFit];
    [contentView addSubview:updateInfo];
    
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
    
    contentView.height = updateInfo.bottom + separatorPadding;
    
    contentView.backgroundColor = [UIColor whiteColor];
    [self setContainerView:contentView];
}

- (void)formatAlertButton {
    for (UIView *view in self.dialogView. subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == 0) {
                UIColor *color = CN_TEXT_BLUE;
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitleColor:color forState:UIControlStateHighlighted];
                button.titleLabel.font = CNFont_28px;
            }
            if (button.tag == 1) {
                UIColor *color = CN_TEXT_BLUE;
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitleColor:color forState:UIControlStateHighlighted];
                button.titleLabel.font = CNFont_28px;
            }
        }
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (self.buttonTitles.count > buttonIndex) {
        NSString *btnTitle = self.buttonTitles[buttonIndex];
        if ([@"立即更新" isEqualToString:btnTitle]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
        }else{
            [self cancel];
        }
    }else{
        [self cancel];
    }
}

- (void)cancel{
    [UpdateManager ignoreOnce];
    [self close];
    SharedTrigger
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affectsg performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
