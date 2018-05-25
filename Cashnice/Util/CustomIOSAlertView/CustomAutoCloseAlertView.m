//
//  CustomAutoCloseAlertView.m
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomAutoCloseAlertView.h"

@interface CustomAutoCloseAlertView  () <CustomIOSAlertViewDelegate>
{
    NSTimer            *autoCloseAlertTimer;
    NSUInteger         autoCloseAlertInterval;
}

@end

@implementation CustomAutoCloseAlertView

- (id)initWithMessage:(NSString *)message closeDelegate:(id<CustomAutoCloseAlertViewDelegate>)closeDelegate timeInterval:(NSUInteger)timeInterval {

    if (self = [super init]) {
        [self createAlertViewWithMessage:message];
        self.timeInterval = timeInterval;
        self.autoClosedelegate = closeDelegate;
    }
    return self;
}

- (void)show
{
    self.delegate  =  self;
    [super formatAlertButton];
    autoCloseAlertTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertViewTimerAction) userInfo:nil repeats:YES];
    autoCloseAlertInterval = self.timeInterval > 0 ? self.timeInterval : 3;
    [super show];
}

- (void)closeTimeout {
    [self close];
    [autoCloseAlertTimer invalidate];
    autoCloseAlertTimer = nil;
    autoCloseAlertInterval = 0;
    
    if (self.autoClosedelegate) {
        [self.autoClosedelegate CustomAutoCloseAlertViewClosed:self] ;
    }
}

- (void)alertViewTimerAction {
    NSUInteger interval = --autoCloseAlertInterval;
    if (interval > 0) {
        for (UIView *view in self.dialogView. subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag == 0) {
                    [button setTitle:[NSString stringWithFormat:@"%d秒后自动关闭", interval] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%d秒后自动关闭", interval] forState:UIControlStateHighlighted];
                }
            }
        }
    }else{
        [self closeTimeout];
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self closeTimeout];
}

- (void)setTimeInterval:(NSUInteger)timeInterval {
    _timeInterval = timeInterval;
    [self setButtonTitles:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d秒后自动关闭", _timeInterval], nil]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
