//
//  PayServeMoneyAboutViewController.m
//  Cashnice
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "PayServeMoneyAboutViewController.h"

@interface PayServeMoneyAboutViewController ()

@end

@implementation PayServeMoneyAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"平台服务费";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
