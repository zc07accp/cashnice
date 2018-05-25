//
//  TransferIndexCell.m
//  Cashnice
//
//  Created by a on 16/10/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferIndexCell.h"

@interface TransferIndexCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TransferIndexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = CNFont_28px;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSArray *)imageNames{
    return @[@"friend_bj.png", @"cn_bj.png"];
}

- (NSArray *)titles{
    return @[@"转给我的好友", @"转给Cashnice用户"];
}

- (void)configurateWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row > 1) {
        return;
    }
    self.leftImageView.image = [UIImage imageNamed:self.imageNames[row]];
    self.titleLabel.text = self.titles[row];
}

@end
