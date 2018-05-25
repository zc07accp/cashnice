//
//  CustomViewController+PickDate.h
//  Cashnice
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController(DatePickDate)<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, strong) UIDatePicker *cn_cvc_datePicker;
@property(nonatomic,strong,readonly) NSDate *showDate;

@property(nonatomic, strong) UIPickerView *arrayPickerView;

//开启日期选择器
-(void)openDatePicker:(NSDate*)ashowDate;

//设置日期选择器的最小日期
-(void)setMinSelDate:(NSDate *)minDate;


//取消操作，子类重写
-(void)datePickerDidCancled;

//日期确定操作，子类重写
-(void)datePickerDidSure;

//数组确定操作
-(void)arrayPickDidSelIndex:(NSInteger)index;

//开启数组选择器
-(void)openArrayPicker:(NSArray *)contentsArr
           selectIndex:(NSInteger)index;
@end
