//
//  SearchAddFriendNewControllerViewController.h
//  Cashnice
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface SearchAddFriendNewControllerViewController : CustomViewController

@property (weak, nonatomic) IBOutlet UIView *noSearchStateView;
@property (weak, nonatomic) IBOutlet UIView *noSearchResultStateView;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
