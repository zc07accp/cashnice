//
//  BindVerification.h
//  Cashnice
//
//  Created by a on 2016/12/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindVerification : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) UILabel *timerLabel;

- (void)setButtonEnabeld:(BOOL)enabled;

@end
