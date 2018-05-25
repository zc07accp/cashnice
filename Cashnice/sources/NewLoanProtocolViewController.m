//
//  NewLoanProtocolViewController.m
//  Cashnice
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 l. All rights reserved.
//

#import "NewLoanProtocolViewController.h"

@interface NewLoanProtocolViewController ()

@end

@implementation NewLoanProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    
    self.title = self.preferedTitle.length>0? self.preferedTitle : @"借款协议";
    
    NSString *path = [NSString stringWithFormat:@"%@/loan/index", WEB_DOC_URL_ROOT];
    path = [NSString stringWithFormat:@"%@?xt=%@", path, @([NSDate new].timeIntervalSince1970)];
    path = [NSString stringWithFormat:@"%@&type=%@&user_id=%@",path, @(self.type), [ZAPP.myuser getUserID]];
    
    if(self.loanId>0){
        path = [NSString stringWithFormat:@"%@&loanid=%@",path, @(self.loanId)];

    }
    
    if (self.addtionParmas) {
        
        NSString*trimAddtionParmas = self.addtionParmas;
        if ([[self.addtionParmas substringToIndex:1] isEqualToString:@"&"]) {
            trimAddtionParmas = [self.addtionParmas substringFromIndex:1];
        }
        
        path = [NSString stringWithFormat:@"%@&%@",path, trimAddtionParmas];

    }
    
    
    //NSLog(@"%@",path);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    [self.webVIew loadRequest:request];
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
