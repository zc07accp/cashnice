//
//  UIView+RemoveAllSubviews.h
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Custom)

- (void)addAutolayoutSubview:(UIView *)view;
- (void)removeAllSubviews;
- (void)disableMultiTouchDfs;

//- (void)startScaleAni:(CGFloat)s;
//- (void)endScaleAni;
@property (nonatomic, assign) BOOL x;
@property (nonatomic, assign) BOOL keyPath;
@property (nonatomic, assign) BOOL sepLine;
@end
