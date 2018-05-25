//
//  SAFCell.h
//  Cashnice
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface SAFCell : CNTableViewCell

@property(nonatomic, weak) IBOutlet HeadImageView *headerImgView;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *companyLabel;
@property(nonatomic, weak) IBOutlet UILabel *occupityLabel;

@property (nonatomic,strong) NSDictionary *dic;

@end
