//
//  ProtocolCell.h
//  Cashnice
//
//  Created by a on 16/5/14.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtocolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *protocolCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *loginActionButton;
@property (weak, nonatomic) IBOutlet UILabel  *agreeLabel;

@end
