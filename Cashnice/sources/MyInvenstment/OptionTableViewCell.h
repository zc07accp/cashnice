//
//  OptionTableViewCell.h
//  YQS
//
//  Created by a on 16/5/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *optionTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *optionAccessory;
@property (weak, nonatomic) IBOutlet UIImageView *promptImageView;

@end
