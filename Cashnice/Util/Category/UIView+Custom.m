//
//  UIView+RemoveAllSubviews.m
//  YQS
//
//  Created by l on 3/7/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "UIView+Custom.h"

@implementation UIView (Custom)

- (void)addAutolayoutSubview:(UIView *)view {
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"v":view};
    NSArray *con_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[v]-0-|" options:0 metrics:nil views:views];
    NSArray *con_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:con_H];
    [self addConstraints:con_V];
}

- (void)removeAllSubviews {
    while ([[self subviews] count] > 0) {
        [[[self subviews] lastObject] removeFromSuperview];
    }
}

- (void)a {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UIView * obj in [self subviews]) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }
    
    [[self viewWithTag:0] removeFromSuperview];
}

- (void)disableMultiTouchDfs {
    [self setExclusiveTouch:YES];
    for (UIView * obj in [self subviews]) {
        [obj disableMultiTouchDfs];
    }
}

- (void)startScaleAni:(CGFloat)s {
    CGFloat f_max = MAX(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat f_min = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    BOOL width_larger_than_height = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame);

    CGFloat s_for_small = s;
    CGFloat s_for_large = 1.0 + (s - 1.0) * f_min / f_max;

    CGFloat s_for_width = width_larger_than_height ? s_for_large : s_for_small;
    CGFloat s_for_height = width_larger_than_height ? s_for_small : s_for_large;
    [UIView animateWithDuration:0.15 animations: ^{
        [self setTransform:CGAffineTransformMakeScale(s_for_width, s_for_height)];
    }];
}

- (void)endScaleAni{
    [UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionCurveLinear animations:^{[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];} completion:nil];
}

- (void)setSepLine:(BOOL)sepLine{
    self.backgroundColor = CN_SEPLINE_GRAY;
}

- (BOOL)x {
    return self.x;
}

- (BOOL)keyPath {
    return self.keyPath;
}

- (void)setX:(BOOL)x {
    self.backgroundColor = ZCOLOR(COLOR_TAB_TOP_LINE);
}

- (void)setKeyPath:(BOOL)keyPath {
    self.backgroundColor = ZCOLOR(COLOR_TAB_TOP_LINE);
}
@end
