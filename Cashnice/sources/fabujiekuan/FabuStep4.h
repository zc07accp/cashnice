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
#import "AttachmentTableViewCell.h"

@interface FabuStep4 : CustomViewController < NextButtonDelegate, StrokeButtonDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate, AttachmentCellDelegate>

@end
