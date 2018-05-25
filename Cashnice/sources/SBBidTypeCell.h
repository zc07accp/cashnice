//
//  SBBidTypeCell.h
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface SBBidTypeCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;


@property (strong,nonatomic) void (^SBTypeChaned) (BOOL btn1Seled,BOOL btn2Seled);


@property(nonatomic) BOOL btn1Sel; //
@property(nonatomic) BOOL btn2Sel; //



@end
