//
//  NPDTitleCell.h
//  Cashnice
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTitleDetailArrowCell.h"

typedef NS_ENUM(NSInteger, NPD_IDENTIFY_TYPE) {
   NPD_NOT_IDENTIFY  = 0, //未认证
   NPD_IDENTIFIED ,   //已认证
    NPD_IDENTIFY_HIDDEN //不显示
    
} ;

@interface NPDTitleCell : CNTitleDetailArrowCell
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identifyImgView;

@property(nonatomic) NSInteger identified; //0未认证 1认证 2不显示认证标志

@end
