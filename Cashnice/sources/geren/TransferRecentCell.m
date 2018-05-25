//
//  TransferRecentCell.m
//  Cashnice
//
//  Created by a on 16/10/17.
//  Copyright © 2016年 l. All rights reserved.
//

#import "TransferRecentCell.h"

@interface TransferRecentCell ()

@property (weak, nonatomic) IBOutlet HeadImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TransferRecentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = CNFont_28px;
    
//    self.leftImageView.layer.cornerRadius = [ZAPP.zdevice scaledValue:60/2];
//    self.leftImageView.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configurateWithIndexPath:(NSDictionary *)dictData{
    self.titleLabel.text = dictData[@"userrealname"];
//    [self.leftImageView setImageFromURL:[NSURL URLWithString:dictData[@"headimg"]] placeHolderImage:[Util imagePlaceholderPortrait]];
    [self.leftImageView setHeadImgeUrlStr:dictData[@"headimg"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
