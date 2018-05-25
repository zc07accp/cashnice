//
//  BankCellectionCell.m
//  YQS
//
//  Created by l on 7/29/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BankCellectionCell.h"

@implementation BankCellectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.biaoti.textColor = ZCOLOR(COLOR_TEXT_BLACK);
    self.biaoti.font = [UtilFont systemLarge];
}
@end
