//
//  BDMoneyViewModel.h
//  Cashnice
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDMoneyViewModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *detail;

@property (nonatomic) BOOL isComing; //是否是到账账户

+(instancetype)viewModelFrom:(NSString *)accrual;

@end
