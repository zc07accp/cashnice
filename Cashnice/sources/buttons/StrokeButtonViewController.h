//
//  NextButtonViewController.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol StrokeButtonDelegate<NSObject>

@required
- (void)strokeButtonPressed;

@end

@interface StrokeButtonViewController : CustomViewController
@property(strong, nonatomic) id<StrokeButtonDelegate> delegate;

@property (strong, nonatomic) NSString *titleString;

- (void)setTheEnabled:(BOOL)en;
@end
