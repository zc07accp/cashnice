//
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

#import "ShouxinCell.h"
@interface AllShouxinPeople : CustomViewController <UITableViewDataSource, UITableViewDelegate>

- (void)setLoanID:(int)loadid;
- (void)setLoanDict:(NSDictionary *)aLoanDict;
@end
