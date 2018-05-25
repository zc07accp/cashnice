//
//  FilterBillViewController.h
//  Cashnice
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@protocol FilterBillViewControllerDelegate<NSObject>
-(void)filterBillDidSelected:(NSString *)fiterTitle tag:(NSInteger)tag;
-(void)filterBillDidTapClose;
@end

@interface FilterBillViewController : CustomViewController

@property(weak,nonatomic) id<FilterBillViewControllerDelegate> delegate;

-(void)show;


@end
