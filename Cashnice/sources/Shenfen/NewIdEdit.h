//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "NextButtonViewController.h"
#import "PECropViewController.h"
#import "ValidcodeCell.h"

@interface NewIdEdit : CustomViewController < UITableViewDataSource, UITableViewDelegate, NextButtonDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate, UIAlertViewDelegate, ValidcodeCellDelegate>

@property (assign, nonatomic) BOOL authUserType;

@end
