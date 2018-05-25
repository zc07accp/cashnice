//
//  SFCashFriendCell.h
//  Cashnice
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"
#import "PersonObject.h"

@interface SFCashFriendCell : CNTableViewCell
@property (weak, nonatomic) IBOutlet HeadImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (nonatomic,strong) PersonObject *people;

@property (nonatomic) BOOL sel;
@end
