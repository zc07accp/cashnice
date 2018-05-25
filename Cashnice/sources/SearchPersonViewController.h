
//
//  SearchPersonViewController.h
//  Cashnice
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface SearchPersonViewController : CustomViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noShowpersonsLabel;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@property (weak, nonatomic) IBOutlet UIView *coverView;
//@property (weak, nonatomic) IBOutlet UIView *noSearchResultStateView;

@end
