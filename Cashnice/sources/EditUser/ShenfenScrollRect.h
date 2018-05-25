//
//  ShenfenScrollRect.h
//  YQS
//
//  Created by l on 7/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@protocol ShenfenScrollRectDelegate<NSObject>

@required
- (void)rectbuttonPressed:(int)idx;

@end

@interface ShenfenScrollRect : CustomViewController
@property(strong, nonatomic) id<ShenfenScrollRectDelegate> delegate;


@property (assign, nonatomic) int idx;
- (void)setLabelStrings:(NSString *)str;
- (void)setTheButtonDisabled:(BOOL)disabled;
@end
