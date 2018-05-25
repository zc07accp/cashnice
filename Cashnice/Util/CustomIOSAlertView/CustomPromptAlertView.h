//
//  CustomAutoCloseAlertView.h
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomIOSAlertView.h"


@interface CustomPromptAlertView : CustomIOSAlertView

@property (nonatomic, weak) id<CustomIOSAlertViewDelegate> titledDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

- (id)initWithTitle:(NSString *)aTitle andInfo:(NSString *)messageInfo;

@end
