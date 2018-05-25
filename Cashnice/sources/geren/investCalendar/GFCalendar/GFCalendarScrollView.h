//
//  GFCalendarScrollView.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);
typedef void (^DidSelectMonthHandler)(NSInteger, NSInteger);

@interface GFCalendarScrollView : UIScrollView


@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler;    // 日期点击回调
@property (nonatomic, copy) DidSelectDayHandler didDisSelectDayHandler; // 日期点击回调
@property (nonatomic, copy) DidSelectMonthHandler didSelectMonthHandler;  // 日期点击回调

- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份
- (void)setMonthHightPoint:(NSArray *)dateArray;

@end
