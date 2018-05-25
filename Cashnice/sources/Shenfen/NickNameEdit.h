//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "NextButtonViewController.h"
#import "StrokeButtonViewController.h"
#import "PECropViewController.h"
/**
 *  个人中心－》编辑资料－》编辑昵称
 */
@interface NickNameEdit : CustomViewController < UITableViewDataSource, UITableViewDelegate, NextButtonDelegate, UITextFieldDelegate>

@end
