//
//  NSLayoutConstraint+Custom.m
//  YQS
//
//  Created by l on 3/12/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "NSLayoutConstraint+Custom.h"

@implementation NSLayoutConstraint (Custom)

- (void)setToOnePixel {
    self.constant = 1.0 / ZAPP.window.screen.scale;
}

- (void)setKeyPath:(BOOL)keyPath {
    self.constant = 1.0 / ZAPP.window.screen.scale;
    self.constant = 10;
}

- (void)awakeFromNib {
}

- (BOOL)keyPath {
    return self.keyPath;
}

@end
