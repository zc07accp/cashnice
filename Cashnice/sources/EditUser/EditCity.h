//
//  RenmaiHeadTableViewController.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 


@protocol EditCityDelegate<NSObject>

@required
- (void)selecteWith:(int)province city:(int)city;

@end

@interface EditCity : CustomViewController <UITableViewDataSource, UITableViewDelegate >
@property(strong, nonatomic) id<EditCityDelegate> delegate;

@property (assign, nonatomic) NSInteger province;
@end
