//
//  IOUDetailViewController.m
//  Cashnice
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetailViewController.h"
#import "IOURefuseViewController.h"
#import "WebViewController.h"
#import "IOUUseageDetailCell.h"

@interface IOUDetailViewController ()<UITableViewDelegate, UITableViewDataSource,CertificateViewDelegate>{
    MsgSendWay *msway;
}

@end


@implementation IOUDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    
    [self setNavButton];
    
    [self.view addSubview:self.tableView];
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        
    }];

}



-(BOOL)showBlankWithSection{
    return NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"借条详情"];
//    self.title = self.iou_title?self.iou_title : @"借条详情";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"借条详情"];
}

-(WriteIOUNetEngine *)w_engine{
    
    if(!_w_engine){
        _w_engine = [[WriteIOUNetEngine alloc]init];
    }
    
    return _w_engine;
}


-(NSString *)protocol{
    
    if (!_protocol) {
        _protocol = @"make your self";
    }
    
    return _protocol;
}

//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        _typeNameArr = [NSArray arrayWithObjects:
                        
                        @{@"aaa":
                              @[@"111",@"222"]
                          }
                        ,
                        
                        @{@"bbb":
                              @[@"555",@"222"]
                          }
                        ,
                        
                        @{@"ccc":
                              @[@"666",@"222"]
                          }
                        ,
                        
                        nil];
    }
    
    return _typeNameArr;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

-(IOUDetailEngine *)engine{
    
    if(!_engine){
        _engine = [[IOUDetailEngine alloc]init];
    }
    
    return _engine;
}


-(void)rightNavItemAction{
    DLog();
    
    IOURefuseViewController *irvc = ZIOU(@"IOURefuseViewController");
    [self.navigationController pushViewController:irvc animated:YES];
}

#pragma mark - 关于详情的各种网络请求

-(void)getDetail{
    
    WS(ws);
    [self.engine getIOUDetail:@{@"iouid":@(self.iouid)}
                      success:^(IOUDetailUnit *result) {
                          //获取借条详情
                          [ws updateUI:result];
                          progress_hide

                          
    } failure:^(NSString *error) {
        progress_hide

    }];
}

-(void)popDelAlert{
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:IOU_DEL_ALERT delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    [alertview show];
    alertview.tag=300;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 300 && buttonIndex==0) {
        
        [self deleteIOU];
    }
}

-(void)deleteIOU{
    
    WS(ws);
    
    NSDictionary *dic = @{@"ui_id":@(self.iouid),
                          @"userid":[ZAPP.myuser getUserID],
                          @"action":@(0),
                          };
    progress_show

    [self.engine actionIOU:dic
                      success:^() {
                          
                          progress_hide
                          //返回借条列表
                          POST_IOULISTFRESH_NOTI;
                          [ws.navigationController popViewControllerAnimated:YES];
                          
                      } failure:^(NSString *error) {
                          progress_hide

                      }];

    
}

-(void)rejectIOU:(NSInteger)ui_back_reason
        complete:(void (^)())complete{

    NSDictionary *dic = @{@"ui_id":@(self.iouid),
                          @"userid":[ZAPP.myuser getUserID],
                          @"ui_back_reason":@(ui_back_reason),
                          @"action":@(1)
                          };
    progress_show
    
    [self.engine actionIOU:dic
                   success:^() {
                       
                       progress_hide
                       complete();
                       //获取借条详情
                   } failure:^(NSString *error) {
                       progress_hide
                       
                   }];

    
}

//同意借条
-(void)agreeIOU:(NSArray *)attachments{
    
    WS(ws);

    NSMutableDictionary *dic =@{@"ui_id":@(self.iouid),
                          @"userid":[ZAPP.myuser getUserID],
                          @"ui_loan_rate":@(detailUnit.ui_loan_rate),
                          @"action":@(2)
                          }.mutableCopy;
    
    progress_show_cn
    
    [self.engine actionIOU:dic
                 images:attachments
                   success:^() {
                       
                       progress_hide
                       POST_IOULISTFRESH_NOTI;
                       [ws.navigationController popViewControllerAnimated:YES];
//                       [ws popMsgSend];

                       //获取借条详情
                   } failure:^(NSString *error) {
                       progress_hide
                       
                   }];

    
}

-(void)sendAgain:(void (^)(BOOL suc))complete
{
    progress_show

    NSDictionary *dic = @{@"ui_id":@(self.iouid),
                          @"userid":[ZAPP.myuser getUserID],
                          };
   
    //发送推送
    [self.w_engine sendIOUAgain:dic Success:^{
        progress_hide

        complete(YES);
    } failure:^(NSString *error) {
        progress_hide

        complete(NO);
    }];
    
}

#pragma mark - 选择方式
-(void)popMsgSend{

    WS(weakSelf);
    
    [MsgSendWayView shareInstance].phone = detailUnit.ui_dest_user_phone;
    [MsgSendWayView shareInstance].iouID = self.iouid;
    [MsgSendWayView shareInstance].weixin = [NSString stringWithFormat:IOU_WRITE_WX, @(detailUnit.ui_loan_val), @(detailUnit.ui_loan_rate)];
    [MsgSendWayView shareInstance].Complete = ^(BOOL result){
        
//        typeof(self) __strong strongSelf = weakSelf;
//
//        NSDictionary *dic = @{@"ui_id":@(self.iouid),
//                              @"userid":[ZAPP.myuser getUserID],
//                              };
//        //发送推送
//        [strongSelf.w_engine sendIOUAgain:dic Success:^{
            POST_IOULISTFRESH_NOTI;
            [weakSelf.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSString *error) {
//            
//        }];
        

    };
    [[MsgSendWayView shareInstance] show];
}
 
-(void)buttonAction:(id)sender{
    
}

-(void)updateUI:(IOUDetailUnit *)unit{
    detailUnit = unit;
    self.title = detailUnit.ui_orderno;
    [self.tableView reloadData];

    if(self.listPassedStatus && [self.listPassedStatus integerValue]!= unit.ui_status){

        [Util toast:detailUnit.preset_error_message];
        POST_IOULISTFRESH_NOTI;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.typeNameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section < self.typeNameArr.count) {
        NSDictionary *dic = self.typeNameArr[section];
        NSArray *arr = [[dic allValues] firstObject];
        return  [arr count]+(self.showBlankWithSection? 1 : 0);
    }
    
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return ROW_HEIGHT_HEADER;
//    [ZAPP.zdevice getDesignScale:ROW_HEIGHT_HEADER];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {

    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, ROW_HEIGHT_HEADER)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *_headerLabel = [[UILabel alloc]initWithFrame:CGRectMake([ZAPP.zdevice getDesignScale:10], 0, MainScreenWidth, ROW_HEIGHT_HEADER)];
    _headerLabel.font = [UIFont systemFontOfSize:15];
//    [UtilFont systemSmall];
    _headerLabel.textColor = ZCOLOR(COLOR_TEXT_GRAY) ;

    [_headerView addSubview:_headerLabel];

    UIView*lineview = [[UIView alloc]initWithFrame:CGRectMake(SEPERATOR_LINELEFT_OFFSET, _headerView.frame.size.height-1, _headerLabel.frame.size.width, 1)];
    [lineview setBackgroundColor:CN_COLOR_DD_GRAY];
    [_headerView addSubview:lineview];

    NSDictionary *dic = self.typeNameArr[section];
    _headerLabel.text = [[dic allKeys] firstObject];
    
    return _headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    NSDictionary *dic = self.typeNameArr[indexPath.section];
    NSArray *arr = [[dic allValues] firstObject];
    
    if (indexPath.row < arr.count) {
        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_1];
    }else{
        return 10;
    }

    
}

//子类根据情况重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [self cellForDetail:tableView indexPath:indexPath];
}

-(UITableViewCell *)cellForTopRelation:(UITableView *)tw  indexPath:(NSIndexPath *)indexPath{
    
    IOUDetailTopCell *cell = [IOUDetailTopCell cellWithNib:tw];
    cell.detailUnit= detailUnit;
    return cell;
    
}

-(UITableViewCell *)cellForBtn:(UITableView *)tw  indexPath:(NSIndexPath *)indexPath{
    
    IOUDetailBtnCell *cell = [IOUDetailBtnCell cellWithNib:tw];
    [cell configureTitle:[self bottomBtnName]];
    WS(ws);
    cell.ButtonAction = ^(UIButton *bn){
        [ws buttonAction:bn];
    };
    return cell;
    
}


- (UITableViewCell *)cellForBlank:(UITableView *)tableView {
    
    NSString *const cellForBlank_ID= @"cellForBlank";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellForBlank_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellForBlank_ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;

}

-(NSString *)bottomBtnName{
    return @"";
}

//默认的协议全部加箭头
-(BOOL)cellShowAcc:(NSIndexPath *)indexPath title:(NSString *)title{
    if ([title isEqualToString:@"借款用途及凭证"]) {
        return YES;
    }
    
    else if ([title isEqualToString:@"借条协议"]) {
        return YES;
    }
    
    return NO;
}

-(UITableViewCell *)cellForDetail:(UITableView *)tw indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section<self.typeNameArr.count) {

        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            NSString*title =arr[indexPath.row];
            
            CNTitleDetailArrowCell *cell = nil;

            if(self.showBlueTip &&[title isEqualToString:@"借款用途及凭证"]){
                cell = [IOUUseageDetailCell cellWithTableView:tw];
                    ((IOUUseageDetailCell *)cell).tipLabel.text = self.blueTip;
            }else{
                cell = [CNTitleDetailArrowCell cellWithTableView:tw];
            }
            
            if([title rangeOfString:@"年化利率"].location != NSNotFound){
                [cell configureTitleAtt:[IOUConfigure averageRate_attr]
                                 detail:[self cellDetail:indexPath title:title] showAcc:NO];
            }else{
                [cell configureTitle:title
                              detail:[self cellDetail:indexPath title:title]
                             showAcc:[self cellShowAcc:indexPath title:title]
                 ];
            }
            
    
            cell.leftSpace = YES;
            cell.textLabel.textColor = CN_TEXT_GRAY;
            return cell;
            
        }else{
            return [self cellForBlank:tw];
        }

    }
    
    return nil;
    
}

-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title{
    
    if([title isEqualToString:@"状态"]){
        return @"等待对方确认";
    }
    
    return  [IOUConfigure strValueFromDetail:detailUnit Key:title];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 打开协议

-(void)openProtocal:(NSString *)url{
 
    WebViewController *wvc = [[WebViewController alloc]init];
    wvc.urlStr = url;
    wvc.atitle = @"借条协议";
    [self.navigationController pushViewController:wvc animated:YES];
}

#pragma mark  打开凭证
-(void)openVoucher:(NSArray *)models{
    
    if (!cpvc) {
        cpvc = [[CertificatePreviewViewController alloc]init];
    }
    
    cpvc.models = models;
    cpvc.detailUnit = detailUnit;
    [self.navigationController pushViewController:cpvc animated:YES];
}

-(NSArray *)makeRateArr{
    
    NSMutableArray *tempArr = @[].mutableCopy;
    for (int i=0; i<self.rateArr.count; i++) {
        [tempArr addObject:
         [NSString stringWithFormat:@"%@%%", [self.rateArr[i] objectForKey:@"rateValue"] ] ];
    }
    
    return tempArr;
}


-(NSInteger)indexInRateArr{
    for (int i=0;i<_rateArr.count;i++) {
        NSInteger tmp = [[_rateArr[i] objectForKey:@"rateValue"] integerValue];
        if (detailUnit.ui_loan_rate == tmp) {
            return i;
        }
    }
    
    return 0;
}





//计算本息合计
-(void)calculateTotalFee{
    
    if (detailUnit.ui_loan_val>0 && detailUnit.ui_loan_start_date && detailUnit.ui_loan_end_date) {
        
        __weak __typeof__(self) weakSelf = self;
        
        [self.w_engine getIOUTotalFee:@{
                                        @"val":@(detailUnit.ui_loan_val),
                                        @"iourate":@(detailUnit.ui_loan_rate),
                                        @"ioustartdate":detailUnit.ui_loan_start_date,
                                        @"iouenddate":detailUnit.ui_loan_end_date}
                              success:^(CGFloat t,CGFloat i,CGFloat v) {
                                  //                                totalFee = fee;
                                  detailUnit.ui_interest_val = i;
                                  [weakSelf.tableView reloadData];
                                  
                              } failure:^(NSString *error) {
                                  
                              }];
        
        
        
    }
    
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
