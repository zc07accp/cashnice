//
//  SelRedMoneyViewController.h
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "RMViewModel.h"

//选择红包或者加息券

@protocol SelRedMoneyDelegate<NSObject>
-(void)didSelectedRedMoney:(REDMONEY_TYPE)type
                          detail:(NSDictionary *)detaildic;

//当前选择红包或者加息券界面没有可用的
-(void)redMoneyAllDisabled:(REDMONEY_TYPE)type;

@end

@interface SelRedMoneyViewController : CustomViewController

//选择红包或者优惠券（建议用这个来判断是 红包还是优惠券）
@property(nonatomic) REDMONEY_TYPE type;

//YES投资 NO借款 （针对优惠券，区分投资和借款）
@property(nonatomic) BOOL invest;


//起投金额 选择投资加息券或者红包时必填
@property (nonatomic)  CGFloat startmoney;



/*
 
 coupontype
 不传是全部的
 0：默认分类，加息券
 1：3.8节活动的转赠加息券
 2：免息券
 
 */
//@property(nonatomic) NSString *coupontype;

@property(weak, nonatomic) id<SelRedMoneyDelegate> delegate;

@end
