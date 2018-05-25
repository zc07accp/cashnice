//
//  .h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"

@interface BillDetail : CustomViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *billID;
@property (nonatomic, strong) NSString *headImg;
@end
