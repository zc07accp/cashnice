//
//  RedMoneyCell.h
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTableViewCell.h"
#import "RMViewModel.h"

@interface RedMoneyCell : CNTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *mtLabel;

@property (weak, nonatomic) IBOutlet UILabel *rmTitleLabel; //标题
@property (weak, nonatomic) IBOutlet UILabel *rangLabel;    //有效期
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;   //使用条件
@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet UIImageView *bkImgView;
@property (weak, nonatomic) IBOutlet UIImageView *giftTag;

@property (nonatomic,strong) RMViewModel *model;


@end
