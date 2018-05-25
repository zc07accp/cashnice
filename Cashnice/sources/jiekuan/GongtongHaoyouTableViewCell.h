//
//  MightKnownTableViewCell.h
//  YQS
//
//  Created by l on 3/24/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GongtongHaoyouTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet HeadImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;
@end
