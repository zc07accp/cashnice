//
//  GeRenTableViewCell.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeRenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIView *sepLine;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_w;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_h;


@end
