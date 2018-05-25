//
//  EmailInfoViewController.m
//  Cashnice
//
//  Created by a on 2017/1/3.
//  Copyright © 2017年 l. All rights reserved.
//

#import "EmailInfoViewController.h"

@interface EmailInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end

@implementation EmailInfoViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavButton];
    self.title = @"邮箱";
    
    self.emailLabel.font = self.promptLabel.font = CNFontNormal;
    
    
    self.emailLabel.text = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_USERemail];
    self.promptLabel.text = @"邮箱已经验证通过";
}


@end

