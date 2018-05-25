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

@interface Chongzhi : CustomViewController < NextButtonDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ValidcodeCellDelegate>


@property (nonatomic, assign) int level;

@end
