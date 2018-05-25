//
//  MyIouOptionTableViewDelegate.h
//  Cashnice
//
//  Created by a on 16/7/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvestmentOptionTableViewDelegate.h"
#import "MyIouTableViewController.h"

@interface MyIouOptionTableViewDelegate : InvestmentOptionTableViewDelegate

@property (nonatomic) IouListPageType iouListPageType;
@property (nonatomic) BOOL isHistorical;

@end
