//
//  CustomAutoCloseAlertView.m
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomSaveAlertView.h"
#import "UpdateManager.h"

@interface CustomSaveAlertView  () <CustomIOSAlertViewDelegate>
{
    NSString *newVersion;
    NSString *newFileSize;
}

@end

@implementation CustomSaveAlertView

- (void)show
{
    if (! self.delegate) {
        self.delegate  =  self;
    }
    
    [super show];
    
    [self formatAlertButton];
}

- (void)createAlertViewWithMessage : (NSString *)message {
    
    
    CGFloat separatorPadding = [ZAPP.zdevice getDesignScale:10];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self countScreenSize].width*.7, 7 * separatorPadding)];
    
    
    //CGFloat separatorHeight = [ZAPP.zdevice getDesignScale:1];
    
    
    UILabel *bundleInfo = [[UILabel alloc] initWithFrame:contentView.bounds];
    bundleInfo.text = message;
    bundleInfo.font = [UtilFont systemLargeBold];
    bundleInfo.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    bundleInfo.numberOfLines = 1;
    bundleInfo.textAlignment = NSTextAlignmentCenter;
    //[bundleInfo sizeToFit];
    [contentView addSubview:bundleInfo];
    
    UILabel *updateInfo = [[UILabel alloc] initWithFrame:CGRectMake(separatorPadding, bundleInfo.bottom + separatorPadding, contentView.width- 2* separatorPadding, 0)];
    updateInfo.text = self.message;
    updateInfo.font = [UtilFont systemLarge];
    updateInfo.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    updateInfo.numberOfLines = 0;
    [updateInfo sizeToFit];
    [contentView addSubview:updateInfo];
    
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
                button.titleLabel.font = [UtilFont systemLarge];
            }
            if (button.tag == 1) {
                UIColor *color = CN_TEXT_BLUE;
                [button setTitleColor:color forState:UIControlStateNormal];
                [button setTitleColor:color forState:UIControlStateHighlighted];
                button.titleLabel.font = [UtilFont systemLarge];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
