//
//  MoneyFormatViewModel.h
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用于加工钱，产出类似190,000元 属性字符串
 */


@interface MoneyFormatViewModel : NSObject

@property (nonnull, strong, readonly) NSAttributedString *reformedMoneyStr;


@property(nonatomic,strong,nonnull) NSNumber* originalMoneyNum;
@property(nonatomic) NSInteger formatType;


/**
 *  工厂方法，产出ViewModel。1 单位（元）变小 2 
 *
 *  @param type
 *
 *  @return ViewModel
 */
+(instancetype)viewModelFrom:(NSInteger)type;


@end
