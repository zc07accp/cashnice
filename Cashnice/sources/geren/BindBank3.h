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


@protocol BindBank3Delegate<NSObject>

@required
- (void)resendValidationCode;

@end


@interface BindBank3 : CustomViewController < NextButtonDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ValidcodeCellDelegate>


@property (nonatomic, assign) BOOL hasId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *card;

@property (nonatomic, weak) id<BindBank3Delegate> delegate;
@end
