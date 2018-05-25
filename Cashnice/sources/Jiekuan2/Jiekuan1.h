//
//  JieKuanViewController.h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
 
#import "JiekuanTableViewCell.h"
#import "QuerenHuanxi.h"
/**
 *  我授信的借款
 */
@interface Jiekuan1 : CustomViewController <UITableViewDelegate, UITableViewDataSource,  JiekuanTableViewCellDelegate, QuerenHuanXiDelegate>

@end
