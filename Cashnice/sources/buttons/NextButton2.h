//
//  NextButtonViewController.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol NextButton2Delegate<NSObject>

@required
- (void)nextButton2Pressed;

@end

@interface NextButton2 : CustomViewController
@property(strong, nonatomic) id<NextButton2Delegate> delegate;

@property (strong, nonatomic) NSString *titleString;

- (void)setTheTitleString:(NSString *)t;
- (void)setTheEnabled:(BOOL)en ;
- (void)setTheGray;
@end
