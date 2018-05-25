//
//  CheckingGuaranteeTableViewCell.h
//  Cashnice
//
//  Created by a on 2018/4/12.
//  Copyright © 2018年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckingGuaranteeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet HeadImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLable;
@property (weak, nonatomic) IBOutlet UILabel *positionLable;
@property (weak, nonatomic) IBOutlet UILabel *orgLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLableWidth;
@property (weak, nonatomic) IBOutlet UILabel *guarLabel;

@property (strong, nonatomic) NSString *itemUserId;
@property (weak, nonatomic) id actionDelegate;

@end
