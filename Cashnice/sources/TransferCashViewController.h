//
//  TransferCashViewController.h
//  Cashnice
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CustomViewController.h"

@interface TransferCashViewController : CustomViewController
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *daysLabelColl;

@property(nonatomic) NSInteger betId;
@end
