//
//  RepaymentViewController.h
//  YQS
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

typedef enum RepaymentViewType{
    RepaymentViewTypeLoan       = 1,
    RepaymentViewTypeGuarantee  = 2
} RepaymentViewType;

@interface RepaymentViewController : CustomViewController

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) RepaymentViewType repaymentType;

@end
