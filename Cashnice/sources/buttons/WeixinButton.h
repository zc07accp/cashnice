//
//  NextButtonViewController.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol WeixinButtonDelegate<NSObject>

@required
- (void)weixinButtonPressed;

@end

@interface WeixinButton : CustomViewController
@property(strong, nonatomic) id<WeixinButtonDelegate> delegate;

@property (strong, nonatomic) NSString *titleString;
@end
