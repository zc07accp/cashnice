//
//  CheckingGuaranteeTableViewCell.h
//  Cashnice
//
//  Created by a on 2018/4/12.
//  Copyright © 2018年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitingGuaranteeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet HeadImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UILabel *positionLable;
@property (weak, nonatomic) IBOutlet UILabel *orgLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLableWidth;

//@property (strong, nonatomic) NSString *itemUserId;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id actionDelegate;

@end
