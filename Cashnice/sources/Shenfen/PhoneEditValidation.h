//
//  PhoneEditValidation.h
//  Cashnice
//
//  Created by a on 2016/12/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface PhoneEditValidation : CustomViewController

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmActionBtn;
@property (weak, nonatomic) IBOutlet UIView *sperateLineView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet UIView *bkView;


- (IBAction)getCode:(id)sender;
- (IBAction)sureAction:(id)sender;

@end
