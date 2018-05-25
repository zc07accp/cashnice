//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "NextButtonViewController.h"

@interface SendLoanViewController : CustomViewController < NextButtonDelegate, UITextViewDelegate, TTTAttributedLabelDelegate, UIAlertViewDelegate>

- (void)refreshUILoanComplete ;

@property(nonatomic, strong)NSDictionary *loanDictRedistributed;

@end
