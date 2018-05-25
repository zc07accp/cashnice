//
//  CNTitleDetailArrowCell.h
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CNTableViewCell.h"

typedef NS_ENUM(NSUInteger, DETAILCELL_RIGHTLABEL_TYPE) {
    RIGHTLABEL_ALIGNRIGHT=0x11,    //右对齐
    RIGHTLABEL_RIGHTSPACE_SHOWACC, //右边空，有箭头
    RIGHTLABEL_RIGHTSPACE_HIDEACC, //右边空，没有箭头
};

@interface CNTitleDetailArrowCell : CNTableViewCell

@property(nonatomic) BOOL showAcc; //逐渐弃用

@property(nonatomic) DETAILCELL_RIGHTLABEL_TYPE rightLabelType;

-(void)configureTitle:(NSString *)title detail:(NSString *)detail showAcc:(BOOL)showAcc;

-(void)configureTitle:(NSString *)title detail:(NSString *)detail rightLabelType:(DETAILCELL_RIGHTLABEL_TYPE)rightLabelType;


-(void)configureTitleAtt:(NSAttributedString *)title detail:(NSString *)detail showAcc:(BOOL)showAcc;

@end
