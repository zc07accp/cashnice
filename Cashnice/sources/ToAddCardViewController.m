//
//  ToAddCardViewController.m
//  YQS
//
//  Created by a on 16/4/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "ToAddCardViewController.h"

@interface ToAddCardViewController ()

@property (weak, nonatomic) IBOutlet UITextField *showingLabel;

@end

@implementation ToAddCardViewController

BLOCK_NAV_BACK_BUTTON

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [self connectToServer];
}

- (IBAction)toAddAction:(id)sender {
    [self.navigationController pushViewController:[MeRouter UserBindBankViewController] animated:YES];
}


- (void)setupView {
    self.title = @"银行卡";
    [self setNavButton];
    
    self.showingLabel.font = [UtilFont systemLarge];
}

- (void)connectToServer {
    bugeili_net
    [ZAPP.netEngine api2_getBankcardListWithComplete:^{
    } error:^{
    }];
}

@end
