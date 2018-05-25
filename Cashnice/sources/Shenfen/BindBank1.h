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
#import "BindBank2.h"

@interface BindBank1: CustomViewController < UITableViewDataSource, UITableViewDelegate, NextButtonDelegate, EditCityDelegate, BindBank2Delegate>

@property (nonatomic, assign) BOOL hasId;

@end
