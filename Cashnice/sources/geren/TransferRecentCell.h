//
//  TransferRecentCell.h
//  Cashnice
//
//  Created by a on 16/10/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferRecentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sepLine;

- (void)configurateWithIndexPath:(NSDictionary *)dictData;

@end
