//
//  .h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

#import "ShouxinCell.h"
#import "QuerenShouxin.h"
@interface ShouxinList : CustomViewController <UITableViewDataSource, UITableViewDelegate,  ShouxinCellDelegate, UIAlertViewDelegate, QuerenShouxinDelegate>

- (void)setShowXintype:(ShouXinType)ty;
@end
