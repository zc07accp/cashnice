//
//  CustomAutoCloseAlertView.h
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomIOSAlertView.h"

@protocol CustomAutoCloseAlertViewDelegate

- (void)CustomAutoCloseAlertViewClosed: (id)alertView;
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomAutoCloseAlertView : CustomIOSAlertView

@property (nonatomic, weak) id<CustomAutoCloseAlertViewDelegate> autoClosedelegate;
@property (nonatomic) NSUInteger timeInterval;

- (id)initWithMessage:(NSString *)message closeDelegate:(id<CustomAutoCloseAlertViewDelegate>)closeDelegate timeInterval:(NSUInteger)timeInterval;

@end
