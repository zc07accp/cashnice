//
//  TransferIndexCell.h
//  Cashnice
//
//  Created by a on 16/10/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferIndexCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sepLine;

- (void)configurateWithIndexPath:(NSIndexPath *)indexPath;

@end
