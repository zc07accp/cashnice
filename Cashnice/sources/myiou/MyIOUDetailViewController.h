//
//  MyIOUDetailViewController.h
//  Cashnice
//
//  Created by a on 16/7/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailViewController.h"
#import "MyIouTableViewController.h"

@interface MyIOUDetailViewController : IOUDetailViewController

@property (nonatomic) IouListPageType iouListPageType;
/**
 *  供调用使用，传入交易信息名称
 */
@property (nonatomic, strong) NSArray *preoccupiedTransactionNames;

@end
