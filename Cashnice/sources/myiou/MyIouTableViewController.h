//
//  MyIouListViewController.h
//  Cashnice
//
//  Created by a on 16/7/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"

typedef enum IouListPageType{
    IouListPageTypeDebter   = 1,
    IouListPageTypeCreditor = 2
} IouListPageType;

@interface MyIouTableViewController : CustomViewController

@property (nonatomic) BOOL isHistorical;
@property (nonatomic) IouListPageType iouListPageType;
@property (nonatomic) NSInteger prespecifiedCount;

@end
