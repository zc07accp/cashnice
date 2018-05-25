//
//  NewBorrowViewController.h
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "NextButtonViewController.h"
#import "EditProvince.h"
#import "EditIntro.h"
#import "PECropViewController.h"

@interface EditUserProfile : CustomViewController < UITableViewDataSource, UITableViewDelegate, EditCityDelegate, EditIntroDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PECropViewControllerDelegate, UIAlertViewDelegate>

@end
