//
//  IDCardIdentifiedViewController.m
//  Cashnice
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 l. All rights reserved.
//

#import "IDCardIdentifiedViewController.h"

@interface IDCardIdentifiedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardnumLabel;

@end

@implementation IDCardIdentifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"身份证";
    [self setNavButton];
    
    self.realNameLabel.text =  [ZAPP.myuser getUserRealNamepExplictly];
    
//    NSString *idcard = [ZAPP.myuser getIdCard];
//    NSMutableString *temp = [NSMutableString string];
//    [temp appendString:@"*"];
    self.cardnumLabel.text = [ZAPP.myuser getIdCard];
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
