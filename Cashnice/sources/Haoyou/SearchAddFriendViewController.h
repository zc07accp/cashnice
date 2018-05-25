//
//  SearchAddFriendViewController.h
//  Cashnice
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface SearchAddFriendViewController : CustomViewController

//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *noSearchStateView;
@property (weak, nonatomic) IBOutlet UIView *noSearchResultStateView;

@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@property(strong, nonatomic) UISearchController *searchController;


@end
