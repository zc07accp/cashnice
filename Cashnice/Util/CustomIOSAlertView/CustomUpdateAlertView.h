//
//  CustomAutoCloseAlertView.h
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomIOSAlertView.h"

@protocol CustomUpdateAlertViewDelegate

- (void)CustomAutoCloseAlertViewClosed: (id)alertView;
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CustomUpdateAlertView : CustomIOSAlertView

@property (nonatomic, weak) id<CustomUpdateAlertViewDelegate> updateDelegate;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) BOOL isForced;

- (id)initWithUpdateInfo:(NSDictionary *)updateInfoDict;
- (id)initWithMessage:(NSString *)message updateDelegate:(id<CustomUpdateAlertViewDelegate>)updateDelegate isForced:(BOOL)forced;

@end
