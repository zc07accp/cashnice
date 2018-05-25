//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "NextButtonViewController.h"
#import "ValidcodeCell.h"

/**
 *  新版登录界面, 第2步
 */
@interface NewReg2 : CustomViewController <UITableViewDataSource, UITableViewDelegate, NextButtonDelegate, UITextFieldDelegate, ValidcodeCellDelegate >

@end
