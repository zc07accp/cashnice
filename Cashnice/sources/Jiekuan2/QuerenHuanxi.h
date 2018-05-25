//
//  JieKuanViewController.h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "ButtonCell.h"
@protocol QuerenHuanXiDelegate<NSObject>

@required
- (void)huankuanOkDonePressed:(int)opRow;

@end
/**
 *  还款
 */
@interface QuerenHuanxi : CustomViewController <UITableViewDelegate, UITableViewDataSource,  ButtonCellDelegate>
@property(strong, nonatomic) id<QuerenHuanXiDelegate> delegate;


@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, assign) int opRowHere;
@end
