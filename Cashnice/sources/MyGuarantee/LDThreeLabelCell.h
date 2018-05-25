//
//  LDThreeLabelCell.h
//  Cashnice
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "CNTitleDetailArrowCell.h"

@interface LDThreeLabelCell : CNTitleDetailArrowCell

@property(strong, nonatomic) UILabel *centralLabel;
-(void)configureTitle:(NSString *)title detail:(NSString *)detail centralTitle:(NSString *)centralTitle;

@end
