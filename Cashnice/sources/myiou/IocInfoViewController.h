//
//  IocInfoViewController.h
//  Cashnice
//
//  Created by a on 16/7/23.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "MyIouTableViewController.h"

@interface IocInfoViewController : CustomViewController

@property (nonatomic) NSInteger iouId;
@property (nonatomic, copy) NSString *ui_orderno;
@property (nonatomic) IouListPageType iouListPageType;

@end
