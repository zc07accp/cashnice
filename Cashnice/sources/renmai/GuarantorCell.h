//
//  GuarantorCell.h
//  Cashnice
//
//  Created by a on 2016/12/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuarantorCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet HeadImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *sepLine;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *guarantPrompt;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UIView *commView;
@property (weak, nonatomic) IBOutlet UIView *sepView;


- (void)updateCellData:(NSDictionary*)data;

@end
