//
//  RenmaiHeadTableViewController.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
@protocol RenMaiHeaderDelegate<NSObject>

@required
- (void)renmaiheaderpressed:(int)idx;

@end

@interface RenmaiHeadTableViewController : CustomViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) id<RenMaiHeaderDelegate> delegate;

- (void)setTheDataDict:(NSDictionary *)dict;
@end
