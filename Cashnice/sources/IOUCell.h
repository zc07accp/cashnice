//
//  IOUCell.h
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTableViewCell.h"

@interface IOUCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet HeadImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *directionImgView;
@property (weak, nonatomic) IBOutlet UILabel *directionTipLabel;

@property (nonatomic) NSDictionary *dic;
@end
