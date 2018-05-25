//
//  JieKuanViewController.h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "QuerenTouzi.h"

#import "Jiekuan2Cell.h"
/**
 *  我的投资
 */
@interface Jiekuan2 : CustomViewController <UITableViewDelegate, UITableViewDataSource, Jiekuan2CellDelegate, QuerenTouziDelegate>

@end
