//
//  BindBankInfoCell.h
//  Cashnice
//
//  Created by a on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindBankInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rowImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingToArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *traliingToEdge;

- (void)setTitle:(NSString *)title content:(NSString *)content;

- (void)showArrow:(BOOL)show;

@end
