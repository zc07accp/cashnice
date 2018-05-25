//
//  MsgSendWayWindow.h
//  Cashnice
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 l. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MsgSendWayView : UIView<UITableViewDelegate,UITableViewDataSource>

//用于发短信
@property(strong,nonatomic) NSString *phone;

//用于分享微信，短信的链接
@property(strong,nonatomic) NSString *weixin;

//借条id
@property(nonatomic) NSInteger iouID;

@property (strong,nonatomic) void (^Complete) (BOOL suc);


+(MsgSendWayView *)shareInstance;
-(void)show;

@end
