//
//  GPSetCell.h
//  Cashnice
//
//  Created by apple on 2016/11/16.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

typedef void (^Changed)(BOOL value);


@interface GPSetCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *setSwitch;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrImgView;

@property (strong, nonatomic) Changed changeBlock;


@end
