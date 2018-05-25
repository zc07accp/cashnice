//
//  TradeHistoryTableViewCell.h
//  Cashnice
//
//  Created by a on 2017/6/26.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HeadImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


-(void)updateWithData:(NSDictionary *)data ;


@end
