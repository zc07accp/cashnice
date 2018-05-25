//
//  SettingTableViewCell.h
//  YQS
//
//  Created by a on 16/1/12.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *signoutLabel;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rowRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layToArrowConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layToMarginConstraint;

@end
