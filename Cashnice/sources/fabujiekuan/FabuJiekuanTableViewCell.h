//
//  FabuJiekuanTableViewCell.h
//  YQS
//
//  Created by l on 3/25/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabuJiekuanTableViewCell : UITableViewCell

@property (nonatomic) BOOL  roundoutDetailImage;

@property (weak, nonatomic) IBOutlet UIImageView *txtImg;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImg;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *sepLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightRow;
@property (weak, nonatomic) IBOutlet HeadImageView *detailImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* con_content_width;

@end
