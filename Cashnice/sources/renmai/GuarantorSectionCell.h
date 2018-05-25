//
//  GuarantorSectionCell.h
//  Cashnice
//
//  Created by a on 2016/12/9.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuarantorSectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


- (void)updateCellData:(NSDictionary*)data;
@end
