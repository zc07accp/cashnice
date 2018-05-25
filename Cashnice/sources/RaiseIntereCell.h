//
//  RaiseIntereCell.h
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "RIViewModel.h"

@interface RaiseIntereCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *interestLabel; //利率


@property (weak, nonatomic) IBOutlet UILabel *rmTitleLabel; //标题
@property (weak, nonatomic) IBOutlet UILabel *rangLabel;    //有效期
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;   //使用条件
@property (weak, nonatomic) IBOutlet UILabel *useLabel;   //立即使用

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *giftTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConst;

@property (strong, nonatomic) RIViewModel *model;
@end
