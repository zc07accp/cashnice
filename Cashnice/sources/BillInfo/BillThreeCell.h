//
//  BillThreeCell.h
//  Cashnice
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface BillThreeCell : CNTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property(nonatomic) BOOL showTitle;
@property(nonatomic) NSDictionary *dic;

@end
