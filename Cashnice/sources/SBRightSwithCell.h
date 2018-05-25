//
//  SBRightSwithCell.h
//  Cashnice
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 l. All rights reserved.
//

#import "CNTableViewCell.h"

@interface SBRightSwithCell : CNTableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;

@property (strong,nonatomic) void (^Switch) (BOOL open);

@end
