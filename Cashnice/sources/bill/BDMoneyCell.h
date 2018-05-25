//
//  BDMoneyCell.h
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface BDMoneyCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(void)config:(NSString *)title content:(NSAttributedString *)content;


@end
