//
//  SocietyPositionViewController.h
//  Cashnice
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface SocietyPositionViewController : CustomViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIView *optionsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UILabel *promptPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptInfoLabel;

@end
