//
//  RepayTypeTableViewCell.h
//  Cashnice
//
//  Created by a on 16/7/29.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepayTypeTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView    *headImageView;
@property (strong, nonatomic) UILabel        *titleLabel;
@property (strong, nonatomic) UIImageView    *checkedImageView;
@property (strong, nonatomic) UIView         *sepLineView;

@property (nonatomic) BOOL isSelected;

@end
