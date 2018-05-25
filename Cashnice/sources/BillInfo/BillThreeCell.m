//
//  BillThreeCell.m
//  Cashnice
//
//  Created by apple on 2016/12/13.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillThreeCell.h"

@implementation BillThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShowTitle:(BOOL)showTitle{
    
    self.label1.text = @"担保人";
    self.label2.text = @"担保金额(元)";
    self.label3.text = @"支付担保金(元)";

    self.label1.font = self.label2.font = self.label3.font =CNFont_26px;
    self.label1.textColor = self.label2.textColor = self.label3.textColor = CN_TEXT_GRAY_9;

}

-(void)setDic:(NSDictionary *)dic{
    
    self.label1.text = EMPTYSTRING_HANDLE(dic[@"userrealname"]);
    self.label2.text = [Util formatRMBWithoutUnit :EMPTYOBJ_HANDLE(dic[@"ulwval"])] ;
    self.label3.text = [Util formatRMBWithoutUnit :EMPTYOBJ_HANDLE(dic[@"deducttotal"])];
    
    self.label1.font = self.label2.font = self.label3.font =CNFont_24px;
    self.label1.textColor = self.label2.textColor = self.label3.textColor = CN_TEXT_GRAY_9;
}


@end
