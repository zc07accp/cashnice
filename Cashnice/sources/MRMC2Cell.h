//
//  MRMC2Cell.h
//  Cashnice
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRMC2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property(strong, nonatomic) void(^TAP)(NSInteger index);

@end
