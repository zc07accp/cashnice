//
//  NextButtonViewController.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol NextButtonDelegate<NSObject>

@required
- (void)nextButtonPressed;

@end

@interface NextButtonViewController : CustomViewController
@property(strong, nonatomic) id<NextButtonDelegate> delegate;

@property (strong, nonatomic) NSString *titleString;

- (void)setTheEnabled:(BOOL)en;
- (void)setTheTitleString:(NSString *)t;
- (void)setTheGray;
- (void)setTheRed;
- (void)setTheBlue;
@end
