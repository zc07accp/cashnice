//
//  ShouXinRenCell.h
//  Cashnice
//
//  Created by a on 16/2/28.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouXinRenCell : UITableViewCell


@property (weak, nonatomic) IBOutlet HeadImageView *headImgeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *guarValLabel;
@property (weak, nonatomic) IBOutlet UIView *lineSep;

@end
