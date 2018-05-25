//
//  NSLayoutConstraint+Custom.h
//  YQS
//
//  Created by l on 3/12/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Custom)

- (void)setToOnePixel;

@property (nonatomic, assign) BOOL keyPath;
@end
