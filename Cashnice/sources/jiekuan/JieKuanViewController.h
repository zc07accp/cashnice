//
//  JieKuanViewController.h
//  YQS
//
//  Created by l on 3/16/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "CustomViewController.h"
#import "JiekuanTableViewCell.h"
#import "JiekuanDetailViewController.h"


@interface JieKuanViewController : CustomViewController <UITableViewDelegate, UITableViewDataSource, JiekuanTableViewCellDelegate, JiekuanDetailViewControllerDelegate>


-(void)loadActivityView;

@end
