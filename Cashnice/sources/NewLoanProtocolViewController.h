//
//  NewLoanProtocolViewController.h
//  Cashnice
//
//  Created by apple on 2017/7/17.
//  Copyright © 2017年 l. All rights reserved.
//

#import "WebViewController.h"

@interface NewLoanProtocolViewController : WebViewController

@property(nonatomic) NSInteger type;

@property(nonatomic) NSInteger loanId;

@property(strong, nonatomic) NSString *preferedTitle;

@property(nonatomic) NSString *addtionParmas;

@end
