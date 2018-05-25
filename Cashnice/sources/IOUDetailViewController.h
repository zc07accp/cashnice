//
//  IOUDetailViewController.h
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "CustomViewController.h"
#import "IOU.h"
#import "IOUDetailTopCell.h"
#import "CNTitleDetailArrowCell.h"
#import "IOUConfigure.h"
#import "IOUDetailEngine.h"
#import "IOUDetailBtnCell.h"
#import "MsgSendWayView.h"
#import "MsgSendWay.h"
#import "WriteIOUNetEngine.h"
#import "CertificatePreviewViewController.h"

/**
 *  表示列表形式展现的借条详情类,子类重写，不要直接用父类
 */

@interface IOUDetailViewController : CustomViewController
{
    IOUDetailUnit *detailUnit;
    CertificatePreviewViewController * cpvc;

}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *typeNameArr;
@property (strong,nonatomic) IOUDetailEngine *engine;
@property (strong,nonatomic) NSString *protocol;
@property (strong,nonatomic) WriteIOUNetEngine *w_engine;

@property (strong,nonatomic)NSArray *rateArr;

@property (nonatomic) BOOL showBlueTip;
@property (strong, nonatomic) NSString *blueTip;


//借条id
@property (nonatomic) NSInteger iouid;

@property (strong,nonatomic) NSNumber *listPassedStatus;
/**
 *  section 之间显示空行
 */
@property (nonatomic) BOOL showBlankWithSection;

//头像单元格
-(UITableViewCell *)cellForTopRelation:(UITableView *)tw  indexPath:(NSIndexPath *)indexPath;

//内容单元格
-(UITableViewCell *)cellForDetail:(UITableView *)tw indexPath:(NSIndexPath *)indexPath;

-(UITableViewCell *)cellForBtn:(UITableView *)tw  indexPath:(NSIndexPath *)indexPath;

//更新界面
-(void)updateUI:(IOUDetailUnit *)unit;

/**
 *  底下按钮的事件响应
 *
 *  @param sender 按钮
 */
-(void)buttonAction:(id)sender;

-(void)popMsgSend;



//每个单元格具体的显示内容
-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title;

//是否显示箭头
-(BOOL)cellShowAcc:(NSIndexPath *)indexPath title:(NSString *)title;


//配置底部按钮的标题
-(NSString *)bottomBtnName;

//***********************借条相关动作

//获取借条详情
-(void)getDetail;

-(void)popDelAlert;

//删除借条
-(void)deleteIOU;


/**
 *  同意借条
 *
 *  @param attachments 附件 非必须
 */
-(void)agreeIOU:(NSArray *)attachments;

-(void)sendAgain:(void (^)(BOOL suc))complete;


/**
 *  驳回借条
 *
 *  @param ui_back_reason 理由id
 *  @param complete 结束回调
 */
-(void)rejectIOU:(NSInteger)ui_back_reason complete:(void (^)())complete;

//打开借款协议
-(void)openProtocal:(NSString *)url;

-(void)openVoucher:(NSArray *)models;

-(NSArray *)makeRateArr;
-(NSInteger)indexInRateArr;

//重新计算费用，并刷新界面
-(void)calculateTotalFee;

@end
