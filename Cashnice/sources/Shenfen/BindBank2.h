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

@protocol BindBank2Delegate<NSObject>

@required
- (void)resendValidationCode;

@end


@interface  BindBank2: CustomViewController < UITableViewDataSource, UITableViewDelegate, NextButtonDelegate, UITextFieldDelegate, ValidcodeCellDelegate>

@property(strong, nonatomic) id<BindBank2Delegate> delegate;
@property (strong, nonatomic) NSString * orderno;

@property (nonatomic, assign) BOOL hasId;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *card;
@end
