//
//  NewSysMsgCell.h
//  Cashnice
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTableViewCell.h"

@interface NewSysMsgCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UIView *bkView;
 
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;

@property (nonatomic) BOOL itemEdited;
@property (nonatomic) BOOL itemSelected;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTapBtnConstr;
@end
