//
//  SearchCNFriendViewController.h
//  Cashnice
//
//  Created by apple on 2016/10/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface SearchCNFriendViewController : CustomViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *noSearchStateView;
@property (weak, nonatomic) IBOutlet UIView *noSearchResultStateView;

@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@end
