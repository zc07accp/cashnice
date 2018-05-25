//
//  IOUCell.m
//  Cashnice
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUCell.h"
#import "IOU.h"
@implementation IOUCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    self.headerView.left = [ZAPP.zdevice getDesignScale:24];
//    self.nameLabel.left = self.headerView.right+10;
//    
//    self.directionImgView.left =  self.frame.size.width - [ZAPP.zdevice getDesignScale:24] - self.directionImgView.width;
//    self.directionTipLabel.left = self.frame.size.width - [ZAPP.zdevice getDesignScale:24]-self.directionTipLabel.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic{
 
//    NSInteger ui_src_user_id = [dic[@"ui_src_user_id"] integerValue];
    
    NSString *name;
    NSString *headurl;
 
    
    if(!ISNSNULL(dic[@"ui_dest_user_name"]) && [dic[@"ui_dest_user_name"] length]>0){
        name = dic[@"ui_dest_user_name"];
        headurl= dic[@"ui_dest_user_header_img"];
    }else{
        name =  [Util getUserRealNameOrNickName:[ZAPP.myuser gerenInfoDict]];
        headurl= [[ZAPP.myuser gerenInfoDict] objectForKey:NET_KEY_HEADIMG];
    }
    

    [self setName:name];
    [self setHeadUrl:headurl];
    
    
    CGFloat ui_loan_val = [dic[@"ui_loan_val"] integerValue];
    NSString *money =  [Util formatRMB:@(ui_loan_val)];

    NSLog(@"name=%@ heaurl=%@ money=%@", name, headurl,money);

    
    CGFloat ui_loan_rate = [dic[@"ui_loan_rate"] floatValue];
    NSString *detail = [NSString stringWithFormat:@"%@\n年化%@%%", money, @(ui_loan_rate)];
    self.detailLabel.text = detail;
    
    //没有发送成功
    if ([dic[@"ui_status"] integerValue] == IOU_STATUS_NO_SEND) {
        self.directionImgView.image = [UIImage imageNamed:@"sent"];
    }else{
        //该由我操作的
        if(!ISNSNULL(dic[@"iou_direction"]) && [dic[@"iou_direction"] isEqualToString:@"in"]){
            self.directionImgView.image = [UIImage imageNamed:@"received"];
        }else{
            self.directionImgView.image = [UIImage imageNamed:@"send_out"];
        }
    }

    self.directionTipLabel.text = dic[@"iou_label"];
    

}

-(void)setStatus{
}


-(void)setName:(NSString *)name{
    self.nameLabel.text = name;
}

-(void)setHeadUrl:(NSString *)headUrl{
    [self.headerView setHeadImgeUrlStr:headUrl];

}

@end
