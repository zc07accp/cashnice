//
//  CustomAutoCloseAlertView.h
//  YQS
//
//  Created by a on 15/9/18.
//  Copyright © 2015年 l. All rights reserved.
//

#import "CustomIOSAlertView.h"


@interface CustomSaveAlertView : CustomIOSAlertView

@property (nonatomic, weak) id<CustomIOSAlertViewDelegate> updateDelegate;
@property (nonatomic, strong) NSString *message;
@end
