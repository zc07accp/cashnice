//
//  InvesHisCell.h
//  Cashnice
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface InvesHisCell : CNTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong,nonatomic) NSDictionary *dic;

@end
