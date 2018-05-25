//
//  CustomAutoCloseAlertView.h
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomIOSAlertView.h"

@protocol CustomTitledAlertViewDelegate

- (void)CustomAutoCloseAlertViewClosed: (id)alertView;
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomTitledAlertView : CustomIOSAlertView

@property (nonatomic, weak) id<CustomTitledAlertViewDelegate> titledDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIColor *messageTextColor; //中间区域文本颜色

@property (nonatomic,assign) BOOL hideHeadline; //是否隐藏头部线

- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo;

- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo msgTextAli:(NSTextAlignment)textalig;


@end
