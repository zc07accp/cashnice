//
//  CustomViewController+PickDate.m
//  Cashnice
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController+PickDate.h"
#import <objc/runtime.h>

static NSInteger const CLOSE_BUTTON_TAG = 0x22;
static NSInteger const CLOSE_TIMEVIEW_TAG = 0x33;

static const void *ShowDateKey = &ShowDateKey;
static const void *DatePickerKey = &DatePickerKey;
static const void *ArrayPickerKey = &ArrayPickerKey;

static NSArray *pickContentsArr = nil;
static NSInteger pickContentsArr_index = 0;

@implementation CustomViewController(DatePickDate)
@dynamic showDate,cn_cvc_datePicker,arrayPickerView;

- (NSDate *)showDate {
    return objc_getAssociatedObject(self, ShowDateKey);
}


-(void)setShowDate:(NSDate *)showDate{
    objc_setAssociatedObject(self, ShowDateKey, showDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(UIDatePicker *)cn_cvc_datePicker{
    return objc_getAssociatedObject(self, DatePickerKey);
}

-(void)setCn_cvc_datePicker:(UIDatePicker *)datePicker{
    objc_setAssociatedObject(self, DatePickerKey, datePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(UIDatePicker *)arrayPickerView{
    return objc_getAssociatedObject(self, ArrayPickerKey);
}

-(void)setArrayPickerView:(UIPickerView *)arrayPickerView{    objc_setAssociatedObject(self, ArrayPickerKey, arrayPickerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)buildCoverView:(BOOL)buildDatePicker{
    
    UIWindow *window=[[UIApplication sharedApplication].windows firstObject];
    
    UIButton* closeTimeButton = nil;
    UIView *chooseTimeView = nil;
    
    if (!chooseTimeView) {
        
        closeTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        [closeTimeButton addTarget:self action:@selector(actionCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        closeTimeButton.backgroundColor = [UIColor blackColor];
        closeTimeButton.alpha = 0.0;
        
        closeTimeButton.tag = CLOSE_BUTTON_TAG;
        
        
        chooseTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 260)];
        chooseTimeView.backgroundColor = [UIColor whiteColor];
        chooseTimeView.tag =CLOSE_TIMEVIEW_TAG;
        
        //取消
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 6, 60, 38)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [cancelButton setTitleColor:RGB(142, 142, 147) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(actionCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [chooseTimeView addSubview:cancelButton];
        
        //完成
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 6, 60, 38)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [okButton setTitleColor:CN_TEXT_BLACK forState:UIControlStateNormal];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(actionOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [chooseTimeView addSubview:okButton];
        
        if (buildDatePicker) {
            [self addDatePickerView:chooseTimeView];
        }else{
            [self addArrayPickerView:chooseTimeView];
        }
        
    }
    
    [window addSubview:closeTimeButton];
    [window addSubview:chooseTimeView];
    
    
    CGRect chooseFrame = chooseTimeView.frame;
    chooseFrame.origin.y -= chooseFrame.size.height;
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         chooseTimeView.frame = chooseFrame;
                         closeTimeButton.alpha = 0.4;
                     }
                     completion:^(BOOL finished){
                         
                     }];

    
}


-(void)openDatePicker:(NSDate*)ashowDate
{
    if(!ashowDate)return;
    
    self.showDate = ashowDate;
    
    [self buildCoverView:YES];
}

-(void)setMinSelDate:(NSDate *)minDate{
    [self.cn_cvc_datePicker setMinimumDate:minDate];
}


-(void)openArrayPicker:(NSArray *)contentsArr
           selectIndex:(NSInteger)index{
    
    if(!contentsArr){
        return;
    }
    
    if (index<0) {
        index = 0;
    }
    
    NSAssert(index<contentsArr.count, @"index out");
    
    pickContentsArr = contentsArr;
    pickContentsArr_index = index;
    [self buildCoverView:NO];

}



-(void)pickerCancelAction{
    
    if (self.arrayPickerView) {
        [self arrayPickerDidCancled];
    }else{
        [self datePickerDidCancled];
    }
    
}

-(void)datePickerDidCancled{
    
}

-(void)arrayPickerDidCancled{
}


-(void)pickerOKAction{
    
    if (self.arrayPickerView) {
        [self arrayPickDidSelIndex:[self.arrayPickerView selectedRowInComponent:0]];
    }else{
        [self setShowDate: self.cn_cvc_datePicker.date];
        NSLog(@"%@", [self showDate]);
        
        [self datePickerDidSure];
    }
    

}

-(void)datePickerDidSure{
    
}

-(void)arrayPickDidSelIndex:(NSInteger)index{
    
}

-(void)releaseMem{
    
    [self.cn_cvc_datePicker removeFromSuperview];
    self.cn_cvc_datePicker=nil;
    
    [self.arrayPickerView removeFromSuperview];
    self.arrayPickerView = nil;
    
    pickContentsArr = nil;
}


- (void)actionCancelButtonClicked:(id)sender
{
    UIWindow *window=[[UIApplication sharedApplication].windows firstObject];
    __block UIView *chooseTimeView = [window viewWithTag:CLOSE_TIMEVIEW_TAG];
    
    CGRect chooseFrame = chooseTimeView.frame;
    chooseFrame.origin.y = MainScreenHeight;
    
    [self pickerCancelAction];
    
    __block UIButton *closeTimeButton = [window viewWithTag:CLOSE_BUTTON_TAG];
    
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         chooseTimeView.frame = chooseFrame;
                         closeTimeButton.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self releaseMem];
                         
                         [chooseTimeView removeFromSuperview];
                         chooseTimeView=nil;
                         
                         [closeTimeButton removeFromSuperview];
                         closeTimeButton=nil;
                         
                     }];
    
}

-(void)actionOKButtonClicked:(id)sender{
    
    UIWindow *window=[[UIApplication sharedApplication].windows firstObject];
    __block UIButton *closeTimeButton = [window viewWithTag:CLOSE_BUTTON_TAG];
    __block UIView *chooseTimeView = [window viewWithTag:CLOSE_TIMEVIEW_TAG];
    
    [closeTimeButton removeFromSuperview];
    closeTimeButton=nil;
    
    [self pickerOKAction];
    
    
    CGRect chooseFrame = chooseTimeView.frame;
    chooseFrame.origin.y = MainScreenHeight;
    
    [UIView animateWithDuration:0.2
                     animations:^(void){
                         chooseTimeView.frame = chooseFrame;
                         closeTimeButton.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self releaseMem];

                         [chooseTimeView removeFromSuperview];
                         chooseTimeView=nil;
                         
                         [closeTimeButton removeFromSuperview];
                         closeTimeButton=nil;
                         
                     }];
    
}

#pragma mark - 日期选择器

-(void)addDatePickerView:(UIView *)superView{
    
    static float pick_y = 50.;

    if (!self.cn_cvc_datePicker) {
        self.cn_cvc_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pick_y, MainScreenWidth, 200)];
        self.cn_cvc_datePicker.datePickerMode = UIDatePickerModeDate;
//        self.cn_cvc_datePicker.minimumDate = self.showDate ;
    }

    [self.cn_cvc_datePicker setDate:self.showDate];
    [superView addSubview:self.cn_cvc_datePicker];
}

#pragma mark - 普通选择器

-(void)addArrayPickerView:(UIView *)superView{
    
    
    static float pick_y = 50.;
    
    if (!self.arrayPickerView) {
        self.arrayPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pick_y, MainScreenWidth, 200)];
        self.arrayPickerView.delegate=self;
        self.arrayPickerView.dataSource=self;
        self.arrayPickerView.showsSelectionIndicator=YES;
        [superView addSubview: self.arrayPickerView];
        
        [self.arrayPickerView selectRow:pickContentsArr_index inComponent:0 animated:NO];
    }
    
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickContentsArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickContentsArr[row];
}


@end
