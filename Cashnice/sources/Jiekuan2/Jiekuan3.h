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
#import "JiekuanDetailViewController.h"
/**
 *  我的借款
 */
@interface Jiekuan3 : CustomViewController <UITableViewDelegate, UITableViewDataSource, JiekuanTableViewCellDelegate, UIAlertViewDelegate, QuerenHuanXiDelegate, JiekuanDetailViewControllerDelegate>


@end
