//
//  SBRightInputCell.h
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface SBRightInputCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *accLabel;
@property (strong, nonatomic) NSString *accText;

@property (strong,nonatomic) void (^InputText) (NSString* text);

//输入框开始弹出
@property (strong,nonatomic) void (^InputTextChanged)(NSString * text);

@end
