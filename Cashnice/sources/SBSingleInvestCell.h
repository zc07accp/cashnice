//
//  SBSingleInvestCell.h
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface SBSingleInvestCell : CNTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;

//单笔投资总额  最小金额 最大金额
@property (strong,nonatomic) void (^SingleInvestInputTextEditDone) (NSString* minMoneyCount,
                NSString *maxMoneyCount);

//输入框开始弹出
@property (strong,nonatomic) void (^SingleInvestInputTextEditBegin) ();


//单笔投资总额发生数值变化
@property (strong,nonatomic) void (^SingleInvestInputChanged)
        (NSString* minMoneyCount, NSString *maxMoneyCount);

-(void)configureField1Placeholder:(NSString *)ph1 field2:(NSString *)ph2;


@end
