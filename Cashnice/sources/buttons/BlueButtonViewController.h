//
//  NextButtonViewController.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol BlueButtonDelegate<NSObject>

@required
- (void)blueButtonPressed;

@end

@interface BlueButtonViewController : CustomViewController
@property(strong, nonatomic) id<BlueButtonDelegate> delegate;
@property (strong, nonatomic) NSString *titleString;

@end
