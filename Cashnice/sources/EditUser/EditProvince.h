//
//  RenmaiHeadTableViewController.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "EditCity.h"


@interface EditProvince : CustomViewController <UITableViewDataSource, UITableViewDelegate,  EditCityDelegate>
@property(strong, nonatomic) id<EditCityDelegate> delegate;
@end
