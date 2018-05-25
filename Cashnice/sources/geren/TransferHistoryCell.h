//
//  TransferHistoryCell.h
//  Cashnice
//
//  Created by a on 16/10/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferHistoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *sepLine;

- (void)configurateWithHistoryItem:(NSDictionary *)historyItem;

@end
