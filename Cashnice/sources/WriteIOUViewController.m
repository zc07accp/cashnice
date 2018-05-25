//
//  WriteIOUViewController.m
//  Cashnice
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "WriteIOUViewController.h"
#import "CNTitleDetailArrowCell.h"
#import "SelIDCell.h"
#import "SelFriendViewController.h"
#import "CustomViewController+PickDate.h"
#import "IOU.h"
#import "WIOU_SetMoneyCell.h"
#import "WIOU_SureCell.h"
#import "WIOU_ServeCell.h"
#import "InputTextViewController.h"
#import "PayServeMoneyViewController.h"
#import "MsgSendWayView.h"
#import "MsgSendWay.h"
//#import "CertificatePreviewViewController.h"
#import "WriteUseageViewController.h"
#import "WebViewController.h"
#import "IOUConfigure.h"
#import "WriteIOUViewController+DelAlert.h"



@interface WriteIOUViewController ()<UITableViewDelegate,UITableViewDataSource,SelFriendDelegate>
{
    
    //用最原始的数据格式来处理新建借条和修改借条的数据承载者
    
    NSInteger selId;//选中的身份
    
    CGFloat ui_loan_val;
    NSString *ui_loan_val_text;//专门用来判断是否输入东西的
    CGFloat counterfee;//手续费
    CGFloat totalFee;//总费用
    
    CGFloat lowestIOUMoney;//最低输入借款金额
    
    NSString *startDateStr;
    NSString *endDateStr;
    
    NSNumber *selRateValue;
    NSNumber *HighestYearRate;//最高年利率
    
//    CGFloat averageRate;
    
    PersonObject *selPeo;
 
    
    BOOL isPayed;
    
    BOOL selAgree;
    
    MsgSendWay *msway;
    
    NSString *create_user;//发起人userid
    
    NSInteger ui_loan_usage;//借款用途 status=1,12时必填
    NSString *iouUsage;//	借款用途标签
    
    
    NSArray *imagesArr; //新采样的借款人凭证图片数组
    
    NSInteger writeIOUPayServeSucNewIOUID;//新建借条支付成功后返回的id
    
    WriteUseageViewController *useageViewController;
    
    NSArray *uploadedArr; //图片url数组（1、新建借条--点击支付保存的 2、编辑借条--以前的）
    
}
@property (strong,nonatomic)IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSArray *typeNameArr;

@property (strong,nonatomic)NSIndexPath*selIndexPath;



@property (strong,nonatomic)NSDate *startDate;
@property (strong,nonatomic)NSDate *endDate;
@property (strong,nonatomic)NSArray *rateArr;

@end

//static CGFloat const ROW_HEIGHT_1 = 40.f;


@implementation WriteIOUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZCOLOR(@"#FFFFFF");
    self.title = self.iouid?@"编辑借条":@"写借条";

    // Do any additional setup after loading the view.
    [self setNavButton];
    [self setNavRightBtn];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self makeNewSetup];

    if (self.iouid) {
        //修改借条
        [self loadSetup];
    }
    
    [self.engine getUseageList];

    WS(weakSelf);
    [self.engine getLoanRateSuccess:^(NSArray *arr) {
        weakSelf.rateArr  = arr;
    } failure:^(NSString *error) {
        
    }];

}
     

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNavRightBtn];
}


-(void)setNavRightBtn{
    
    [super setNavRightBtn];
    
    if (self.iouid) {
        [self.rightNavBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        self.rightNavBtn.hidden=YES;
        self.rightNavBtn.userInteractionEnabled = NO;
    }
}

-(void)makeNewSetup{
    
    selId = 0;
    counterfee=99;
    self.startDate = [NSDate date];
    selRateValue = @(0);

    ui_loan_usage = 44;
    iouUsage = @"临时周转";

    lowestIOUMoney = [ZAPP.myuser getLowestIOUMoney];
    
    create_user=[ZAPP.myuser getUserID];
    selPeo = nil;
    HighestYearRate = @([ZAPP.myuser getHighestYearRate]);
}

-(void)loadSetup{

    WS(ws);
    [self.d_engine getIOUDetail:@{@"iouid":@(self.iouid)}
                        success:^(IOUDetailUnit *result) {
                            //获取借条详情
                            [ws loadSetupParams:result];
                            
                        } failure:^(NSString *error) {
                            
                        }];
}

-(void)loadSetupParams:(IOUDetailUnit *)result{
 
    if(result.ui_status != 0){
        //状态已经变了
        [Util toast:result.preset_error_message];
        POST_IOULISTFRESH_NOTI;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (result.ui_src_user_id == [[ZAPP.myuser getUserID] integerValue]) {
        //我是出借人
        selId=0;
    }else{
        selId=1;
    }
    
    ui_loan_val = result.ui_loan_val;
    counterfee = result.ui_commission;
    create_user=[ZAPP.myuser getUserID];

    self.startDate = [Util dateMDByString:result.ui_loan_start_date];
    self.endDate = [Util dateMDByString:result.ui_loan_end_date];
    selRateValue = @(result.ui_loan_rate);

    if([result.ui_dest_user_phone length] || [result.ui_dest_user_name length]){
        selPeo = [[PersonObject alloc]init];
        selPeo.phone = result.ui_dest_user_phone;
        selPeo.userrealname = result.ui_dest_user_name;
    }
    
    isPayed = YES;
    ui_loan_usage = result.ui_loan_usage;
    iouUsage = result.iouUsage;
    uploadedArr = selId==0?result.voucherLoanSrc:result.voucherLoanDest;
    totalFee = ui_loan_val+result.ui_interest_val;

    [self.tableView reloadData];

}



-(void)setStartDate:(NSDate *)startDate{
    
    _startDate = startDate;
    startDateStr = [Util stringByDateMD:_startDate];
    self.endDate = [UtilDate getLaterEndDate:_startDate orgiEndDate:_endDate];
}

-(void)setEndDate:(NSDate *)endDate{
    
    _endDate = endDate;
    endDateStr = [Util stringByDateMD:_endDate];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        _typeNameArr = [IOUConfigure writeIOUItemArray];
    }
    
    return _typeNameArr;
}

-(NSInteger)indexInRateArr{
    for (int i=0;i<_rateArr.count;i++) {
        NSInteger tmp = [[_rateArr[i] objectForKey:@"rateValue"] integerValue];
        if ([selRateValue integerValue] == tmp) {
            return i;
        }
    }
    
    return 0;
}

-(WriteIOUNetEngine *)engine{
    
    if(!_engine){
        _engine = [[WriteIOUNetEngine alloc]init];
    }
    
    return _engine;
}

-(IOUDetailEngine *)d_engine{
    
    if(!_d_engine){
        _d_engine = [[IOUDetailEngine alloc]init];
    }
    
    return _d_engine;
}


#pragma mark - UITableViewDataSource

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.typeNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == self.typeNameArr.count - 1){
        return 113;
    }
//    return IOU_TABLE_HEIGHT;
    return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_1];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNTableViewCell*cell ;
    if (indexPath.row == 0) {
        cell =  [self cellForSelID:indexPath];
    }else if(indexPath.row == 1){
        cell =  [self cellForSetMoney:indexPath];
    }else if(indexPath.row == 7){
        cell =  [self cellForServeMoney:indexPath];
    }else if(indexPath.row == self.typeNameArr.count - 1){
        cell =  [self cellForSure:indexPath];
    }else{
        cell = [self cellForText:indexPath];
    }
    
    cell.textLabel.textColor = CN_TEXT_GRAY;
    cell.leftSpace = YES;
    return cell;
 
}


-(CNTableViewCell *)cellForSelID:(NSIndexPath*)indexPath{
    
    SelIDCell *cell = [SelIDCell cellWithNib:self.tableView];
    cell.textLabel.text = self.typeNameArr[indexPath.row];
    [cell configureSelID:selId buttonEnabled:[self cellShouldUserEnabled:indexPath]];
    __weak __typeof__(self) weakSelf = self;
     cell.SelID = ^(NSInteger index){
         [weakSelf setSelID:index];
    };
    return cell;
}


//平台服务费
-(CNTableViewCell *)cellForServeMoney:(NSIndexPath*)indexPath{
    
    WIOU_ServeCell *cell = [WIOU_ServeCell cellWithTableView:self.tableView];
    cell.counterfee = counterfee;
    cell.isPayed = isPayed;
    cell.showAcc = YES;
    return cell;
}

//借款金额
-(CNTableViewCell *)cellForSetMoney:(NSIndexPath*)indexPath{
    
    WS(weakSelf);
    
    static NSString *cell_id = @"WIOU_SetMoneyCell";
    WIOU_SetMoneyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cell_id];
    cell.textLabel.text = self.typeNameArr[indexPath.row];
    cell.textField.text = (ui_loan_val_text.length>0 || ui_loan_val>0) ?[Util formatRMBWithoutUnit:@(ui_loan_val)]:@"";
    cell.textField.enabled = [self cellShouldUserEnabled:indexPath];

    cell.InputText = ^(NSString *text){
        
        [weakSelf geyInputLoanVal:text];
    };
    
    return cell;
}


-(CNTableViewCell *)cellForSure:(NSIndexPath*)indexPath{
    
    static NSString *cell_id = @"WIOU_SureCell";
    WIOU_SureCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cell_id];
    [cell configureSelAgree:selAgree fee:totalFee];
    __weak __typeof__(self) weakSelf = self;

    cell.SelAgree = ^(BOOL ag){
        [weakSelf setSelAgree:ag];
    };
    cell.WIOU_Sure = ^{
        [weakSelf selMsgWay];
    };
    cell.SeeAgree = ^{
        [weakSelf seeProtocal];
    };
    
    return cell;
}



-(CNTableViewCell *)cellForText:(NSIndexPath*)indexPath{
    
    CNTitleDetailArrowCell *cell = [CNTitleDetailArrowCell cellWithTableView:self.tableView];
    if (indexPath.row<self.typeNameArr.count) {

        if (indexPath.row == 2) {
            [cell configureTitle:self.typeNameArr[indexPath.row] detail:startDateStr showAcc:NO];
//            cell.accessoryType = UITableViewCellAccessoryNone;

        }else if (indexPath.row == 3) {
            [cell configureTitle:self.typeNameArr[indexPath.row] detail:endDateStr showAcc:NO];
//            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 4) {
            [cell configureTitleAtt:[IOUConfigure averageRate_attr]
                          detail:[NSString stringWithFormat:PLAT_YEAR_AVER_RATE, selRateValue] showAcc:NO];
//            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 5) {
            [cell configureTitle:self.typeNameArr[indexPath.row]
                          detail:(selPeo && [selPeo nameShowed].length)? [selPeo nameShowed]:@"选择联系人"
                         showAcc:YES];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 6) {
            [cell configureTitle:self.typeNameArr[indexPath.row]
                          detail:iouUsage showAcc:YES];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
        else{
            [cell configureTitle:self.typeNameArr[indexPath.row] detail:@"11" showAcc:NO];

//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate

-(BOOL)cellShouldUserEnabled:(NSIndexPath *)indexPath{
    
    //编辑借条
    if (_iouid) {
        if (indexPath.row == 1||indexPath.row ==7) {
            return NO;
        }
        
        return YES;
        
    }else{
        
        if (isPayed) {
            if (indexPath.row == 1||indexPath.row ==7) {
                return NO;
            }
        }
        
        return YES;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(![self cellShouldUserEnabled:indexPath]){
        return;
    }
        
    _selIndexPath = indexPath;
//    [self.view endEditing:YES];

    if(indexPath.row == 1){
    }else if (indexPath.row == 2) {
        [self openDatePicker:self.startDate];
    }else if (indexPath.row == 3) {
        [self openDatePicker:self.endDate];
        [self setMinSelDate:[UtilDate getLaterEndDate:self.startDate orgiEndDate:nil]];
    }else if (indexPath.row == 4) {
        [self openArrayPicker:[self makeRateArr] selectIndex:[self indexInRateArr]];
    }else if (indexPath.row == 5) {
        //选择好友
        SelFriendViewController *sfvc = ZWIOU(@"SelFriendViewController");
        sfvc.delegate = self;
        [self.navigationController pushViewController:sfvc animated:YES];
        
    }else if (indexPath.row == 6) {
        
        if (!useageViewController) {
            useageViewController = ZWIOU(@"WriteUseageViewController");
            
            //只有第一次打开用途界面的时候需要把获取到的url扔进去
            if(uploadedArr){
                useageViewController.existedUrlsArr = uploadedArr;
            }
            
            useageViewController.selReasonDic = @{@"itemname":iouUsage,@"itemvalue":@(ui_loan_usage)};
            useageViewController.deleagte = self;
        }
        useageViewController.selId = selId;
        [self.navigationController pushViewController:useageViewController animated:YES];
    }else if (indexPath.row == 7) {
        [self addNewIOUPayServe];
    }

}

//选择身份
-(void)setSelID:(NSInteger)index{
    selId = index;
    [self.tableView reloadData];
}

//选择同意
-(void)setSelAgree:(BOOL)agree{
    selAgree = agree;
    [self.tableView reloadData];

}

//确定操作，子类重写
-(void)datePickerDidSure{
    
    if (self.selIndexPath.row == 2) {
        //借款日期
        self.startDate = self.showDate;
    }else{
        //还款日期
        self.endDate = self.showDate;
    }
    
    [self.tableView reloadData];
    
    [self calculateTotalFee];
}

-(NSArray *)makeRateArr{
    
    NSMutableArray *tempArr = @[].mutableCopy;
    for (int i=0; i<self.rateArr.count; i++) {
        [tempArr addObject:
         [NSString stringWithFormat:@"%@%%", [self.rateArr[i] objectForKey:@"rateValue"] ] ];
    }

    return tempArr;
}

-(void)arrayPickDidSelIndex:(NSInteger)index{
    
    if (index<self.rateArr.count) {
        selRateValue = [self.rateArr[index] objectForKey:@"rateValue"];
        [self.tableView reloadData];
        //重新计算费用
        [self calculateTotalFee];
    }    
}

#pragma mark - WriteUseageViewControllerDelegate

-(void)didSelectedUseage:(NSDictionary *)selReasonDic
                 picsArr:(NSArray *)picsArr{
    ui_loan_usage = [selReasonDic[@"itemvalue"]integerValue];
    iouUsage = selReasonDic[@"itemname"] ;
    //从用途界面拿到的数组全部是images对象，需要重新上传
    
    //要清空
    uploadedArr = nil;

    if (picsArr.count == 0) {
        imagesArr = nil;
    }else{
        imagesArr = picsArr;

    }
    
    
    [self.tableView reloadData];
}



#pragma mark - InputTextDelegate

-(void)geyInputLoanVal:(NSString*)text{
 
    ui_loan_val_text = text;

//    NSInteger ints = [text integerValue];
    ui_loan_val = [@([text integerValue]) doubleValue];

    
    [self calculateCounterFee];
    [self calculateTotalFee];

}


#pragma mark - SelFriendDelegate
-(void)didSelFriend:(PersonObject *)object{
    
    selPeo = object;
    [self.tableView reloadData];
    [self calculateTotalFee];
    
}

-(NSMutableDictionary *)makeCommonIOUParams{
    
    NSMutableDictionary *parmas = @{}.mutableCopy;
    parmas[@"userid"]=create_user;
    parmas[@"ui_loan_val"]= @(ui_loan_val);
    parmas[@"ui_type"]= selId==0?@(1):@(0);
    parmas[@"ui_loan_rate"]= selRateValue;
    parmas[@"ui_loan_start_date"]= startDateStr;
    parmas[@"ui_loan_end_date"]= endDateStr;
    parmas[@"ui_loan_usage"]= @(ui_loan_usage);
    
    parmas[@"ui_dest_user_phone"]=selPeo.phone;
    parmas[@"ui_dest_user_name"]=[selPeo nameShowed];


    return parmas;
}


-(BOOL)checkIOUParamsAvailable{

    if (ui_loan_val == 0 && [ui_loan_val_text length] == 0) {
        [Util toast:IOUWARN_NOMONEY];
        return NO;
    }
    
    if (ui_loan_val <= lowestIOUMoney) {
        [Util toast:[NSString stringWithFormat:IOUWARN_MONEYZERO,lowestIOUMoney]
         ];
        return NO;
    }
    
    if (![UtilDate endDateAvailable:self.endDate]) {
        [Util toast:IOUWARN_DATE];
        return NO;
    }
    
    return YES;
}

#pragma mark - 新建借条


-(void)addNewIOUHttpPost:(void (^)(BOOL suc))complete{
    
    if ([self checkIOUParamsAvailable]) {
        
        progress_show

        
        NSMutableDictionary *parmas  = [self makeCommonIOUParams];
        parmas[@"ui_status"]= @(1);
        parmas[@"ui_dest_user_phone"] = selPeo.phone;
        parmas[@"ui_dest_user_name"] = selPeo.nameShowed;
        parmas[@"ui_id"] = @(writeIOUPayServeSucNewIOUID);

        //
        [self.engine updateIOU:parmas
                        images:imagesArr
                       success:^(NSInteger newId, NSArray*uploadedImagesArr){
                           complete(YES);
                           POST_IOULISTFRESH_NOTI;
                           progress_hide

        } failure:^(NSString *error) {
            progress_hide
            complete(NO);

        }];

    }else{
        complete(NO);
    }

}

#pragma mark  支付服务费

-(void)addNewIOUPayServe{
    
    if ([self checkIOUParamsAvailable]) {
        
        NSMutableDictionary *parmas  = [self makeCommonIOUParams];
        parmas[@"ui_status"]= @(0);
        parmas[@"counterfee"]=@(counterfee); //格外增加的
        
        if(selPeo){
            parmas[@"ui_dest_user_phone"] = selPeo.phone;
            parmas[@"ui_dest_user_name"] = selPeo.nameShowed;
        }
        
        [self goPayServe:parmas];
        return;
    };
}


#pragma mark  修改借条

-(void)modifyIOUHttpPost:(void (^)(BOOL suc))complete
{
    if ([self checkIOUParamsAvailable]) {
        
        progress_show

        
        NSMutableDictionary *parmas  = [self makeCommonIOUParams];
        parmas[@"ui_status"] = @(1);
        parmas[@"ui_id"] = @(self.iouid);
        parmas[@"ui_dest_user_phone"] = selPeo.phone;
        parmas[@"ui_dest_user_name"] = selPeo.nameShowed;
        
        //没新上传的图片，而且还有旧的图片
        if (!imagesArr && uploadedArr.count) {
            parmas[@"attachments"] = [IOUDetailEngine reformAttachmentsForPosting:uploadedArr];
         }
        
        [self.engine updateIOU:parmas images:imagesArr success:^(NSInteger newId,NSArray*uploadedImagesArr){
           
            POST_IOULISTFRESH_NOTI;
            progress_hide

            complete(YES);
        } failure:^(NSString *error) {
            progress_hide
            complete(NO);

        }];

        
    }else{
        complete(NO);
    }

}

-(void)selMsgWay{
    
    //判断条件
    if(![self checkIOUParamsAvailable]){
        return;
    }
    
    if (selPeo==nil) {
        [Util toast:IOUWARN_NOSELCONTACT];
        return;
    }
    
    if ([IOUConfigure inBlackIOULimited]) {
        return ;
    }
    
    //是否已经支付
    if (!isPayed) {
        [Util toast:IOUWARN_NOPAY_SERVEFEE];
        return;
    }
        
    //是否同意
    if (selAgree==NO) {
        [Util toast:IOUWARN_AGREEPROTOCAL];
        return;
    }
    
    WITHOUT_EMAIL_PUSH
    
    WS(weakSelf);

        if (_iouid) {
            [self modifyIOUHttpPost:^(BOOL suc) {
                if (suc) {
                    [weakSelf popWeixinSMSSel];
                }
            }];
        }else{
            [self addNewIOUHttpPost:^(BOOL suc) {
                if (suc) {
                    [weakSelf popWeixinSMSSel];
                }
            }];
        }

}

-(void)popWeixinSMSSel{
    WS(weakSelf);
    
    [MsgSendWayView shareInstance].phone = selPeo.phone;
    [MsgSendWayView shareInstance].weixin = [NSString stringWithFormat:IOU_WRITE_WX, @(ui_loan_val), selRateValue];
    [MsgSendWayView shareInstance].iouID = self.iouid?self.iouid:writeIOUPayServeSucNewIOUID;

    [MsgSendWayView shareInstance].Complete = ^(BOOL result){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [[MsgSendWayView shareInstance] show];
}


-(void)seeProtocal{
    
    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.urlStr = [IOUConfigure makeWriteProtocol:ui_loan_val rate:selRateValue startDate:startDateStr endDate:endDateStr type:selId==0?1:0 user_id:create_user usage:ui_loan_usage];
    wvc.atitle = @"借条协议";
    [self.navigationController pushViewController:wvc animated:YES];
    
}

-(void)goPayServe:(NSDictionary *)params{
    
    __weak __typeof__(self) weakSelf = self;

    //选择平台服务费
    PayServeMoneyViewController *vc = ZWIOU(@"PayServeMoneyViewController");
    vc.iou_params = params;
//    vc.imagesArr  = imagesArr;
    vc.PaySuccess=^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf->isPayed = YES;
        [strongSelf->_tableView reloadData];
        strongSelf->writeIOUPayServeSucNewIOUID  = vc.newID;
        //从平台界面拿回的已经是上传完的url数组
//        strongSelf->uploadedArr = vc.uploadedImagesArr;
        
        POST_IOULISTFRESH_NOTI;

    };
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 计算费用

//计算平台服务费
-(void)calculateCounterFee{
    
    __weak __typeof__(self) weakSelf = self;

    [self.engine getIOUCounterfee:@{@"mainval":@(ui_loan_val)} success:^(CGFloat fee) {
        counterfee = fee;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];

}

//计算本息合计
-(void)calculateTotalFee{
    
    if (ui_loan_val == 0) {
        totalFee = 0;
    }else if (ui_loan_val>0 && startDateStr && endDateStr && [self.endDate compare:[NSDate date]]==NSOrderedDescending) {
    
            __weak __typeof__(self) weakSelf = self;

            [self.engine getIOUTotalFee:@{
                                          @"val":@(ui_loan_val),
                                          @"iourate":selRateValue,
                                          @"ioustartdate":startDateStr,
                                          @"iouenddate":endDateStr}
                                success:^(CGFloat t,CGFloat i,CGFloat v) {
                                    totalFee = t;
                [weakSelf.tableView reloadData];
                
            } failure:^(NSString *error) {
                
            }];

            
        
    }
    
    
    
}

-(void)rightNavItemAction{
    
    [self popDelAlert];
 }

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
