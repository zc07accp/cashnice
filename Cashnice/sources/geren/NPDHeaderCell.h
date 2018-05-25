//
//  NPDHeaderCell.h
//  Cashnice
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPDHeaderCrediView.h"

@interface NPDHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NPDHeaderCrediView *creView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet HeadImageView *headerImgView;
@property (assign, nonatomic) NSInteger sex;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@end
