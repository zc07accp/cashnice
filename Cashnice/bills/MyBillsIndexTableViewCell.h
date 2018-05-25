//
//  MyBillsIndexTableViewCell.h
//  YQS
//
//  Created by a on 15/9/14.
//  Copyright (c) 2015年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBillsIndexTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *sepLIne;

@end
