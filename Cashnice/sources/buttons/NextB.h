//
//  NextButtonViewController.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

/**
 *  The final button, other buttons will be removed
 *
 */

#import "CustomViewController.h"
@protocol NextBDelegate<NSObject>

@required
- (void)nextBPressed:(int)idx;

@end

@interface NextB : CustomViewController
@property(strong, nonatomic) id<NextBDelegate> delegate;


/**
 *  can be called before viewDidLoad
 *
 *  @param idx , if more than one NextB exist
 */
- (void)setTheButtonIndex:(int)idx;
- (void)setTheTitleString:(NSString *)str;

/**
 *  should be called after viewDidLoad
    self.view, self.button won't be intialized util viewDidLoad
 *
 *  @param enabled
 */
- (void)setTheButtonEnabled:(BOOL)enabled;
- (void)setTheBgRed;
- (void)setTheBgGray;
- (void)setTheBgBlue;
- (void)setHidden : (BOOL)hidden ;
@end
