//
//  LabelsView.h
//  YQS
//
//  Created by l on 4/2/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  show texts in Uitableview Header or footer
 */
@interface LabelsView : UIView

- (void)setAllColor:(UIColor *)color font:(UIFont *)font;
- (void)setIndexColor:(UIColor *)color index:(NSArray *)array;
- (void)setTexts:(NSArray *)strArray;
- (void)setText:(NSString *)str atIndex:(NSInteger)idx;
- (void)setColor:(UIColor *)color atIndex:(NSInteger)idx;
@end
