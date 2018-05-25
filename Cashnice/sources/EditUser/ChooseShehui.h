//
//  RenmaiHeadTableViewController.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 


@protocol ChooseShehuiDelegate<NSObject>

@required
- (void)selecteWith:(NSString *)opt;

@end

@interface ChooseShehui : CustomViewController <UITableViewDataSource, UITableViewDelegate >
@property(strong, nonatomic) id<ChooseShehuiDelegate> delegate;

@end
