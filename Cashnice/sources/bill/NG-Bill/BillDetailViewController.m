//
//  BillDetailViewController.m
//  Cashnice
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillDetailViewController.h"
#import "BDMoneyCell.h"
#import "BDDetailCell.h"
#import "BillDetailConfig.h"
#import "BillNetEngine.h"
#import "BillProgressCell.h"
#import "BDMoneyViewModel.h"
#import "HeaderNamePersonCell.h"

@interface BillDetailViewController ()
{
}
@property (strong,nonatomic) NSArray *typeNameArr;//控制列表下部分的显示
@property (strong,nonatomic) NSArray *headArr; //控制列表上半部分的显示

@property (strong,nonatomic) NSString *accrual;
@property (strong,nonatomic) NSString *order_flag;


@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSDictionary *billDetailUnit;
@property (strong,nonatomic) BillNetEngine *engine;
@property (nonatomic) BOOL getDataByList; //对于某些收益类的，详情接口拿不到，只能靠列表取

@property (strong,nonatomic) BDMoneyViewModel *moneyViewModel;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = CN_COLOR_DD_GRAY;
    self.title = @"账单详情";
    [self setNavButton];
    
 
    //从推送跳转过来的
    if(self.source_type == BILLDETAIL_SOURCETYPE_NOTIFICATION){
        [self requestDetailFromNoti];
    } else if(self.source_type == BILLDETAIL_SOURCETYPE_FROMSERVICEMSG_CHONGZHITIXIAN){
        [self requestDetailFromServeMSGCHONGZHITIXIAN];
    }
    
    else{
        //
        self.accrual = self.dic[@"accrual"];
        
        self.order_flag = self.dic[@"order_flag"];

        //orderno为0的，走list
        if ([EMPTYSTRING_HANDLE(self.dic[@"orderno"]) length]==0 ||
            [EMPTYSTRING_HANDLE(self.dic[@"orderno"]) isEqualToString:@"0"]) {
            self.getDataByList = YES;
        }
        
        if (!self.getDataByList) {
            [self requestDetail];
        }

    }

}

-(void)dealloc{
    NSLog(@"************dealloc");
}

-(void)setAccrual:(NSString *)accrual{
    _accrual = accrual;
    self.moneyViewModel = [BDMoneyViewModel viewModelFrom:_accrual];
}

-(void)setOrder_flag:(NSString *)order_flag{
    _order_flag = order_flag;
    
    _typeNameArr = nil;
    [self typeNameArr];
    
    _headArr = nil;
    [self headArr];
}



-(BillNetEngine *)engine{
    
    if(!_engine){
        _engine = [[BillNetEngine alloc]init];
    }
    
    return _engine;
}

-(NSArray *)typeNameArr{
    //类型不在config列表中的，走list

    if (!_typeNameArr) {
        _typeNameArr = [BillDetailConfig configTitleArr:self.order_flag];
        if (!_typeNameArr) {
            _typeNameArr = @[self.moneyViewModel.isComing? @"到账账户":@"转出账户",@"创建时间"];
            self.getDataByList = YES;
        }else{
            self.getDataByList = NO;
        }
        
    }
    
    return _typeNameArr;
    
}

-(NSArray *)headArr{
    
    if (!_headArr) {
        _headArr = [BillDetailConfig configHeadArr:self.order_flag];
    }
    
    return _headArr;
    
}

-(void)requestDetailFromNoti{
    
    progress_show
    
    NSDictionary *dic = @{@"noticeid":@(self.noticeid)};
    WS(ws);
    
    [self.engine getBillDetailFromNoti:dic success:^(NSDictionary *detail) {
        
        progress_hide
        
        if (detail) {
            [ws updateUIFromNoti:detail];
        }else{
            //resp为空，走list
            DDLogError(@"detail nil");
            [ws updateUIFromNoti:self.dic];
        }
        
        
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];

    
}


-(void)requestDetailFromServeMSGCHONGZHITIXIAN{
    
    progress_show
    
    NSDictionary *dic = @{@"noticeid":@(self.noticeid)};
    WS(ws);
    
    [self.engine getBillDetailFromServeMsgChongzhiTixian:dic success:^(NSDictionary *detail) {
        
        progress_hide
        
        if (detail) {
            [ws updateUIFromNoti:detail];
        }else{
            //resp为空，走list
            DDLogError(@"detail nil");
            [ws updateUIFromNoti:self.dic];
        }
        
        
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];
    
    
}

-(void)requestDetail{
    
    progress_show
    
    NSDictionary *dic = @{@"ubi_orderno":self.dic[@"orderno"],
                          @"order_flag":self.order_flag};
    WS(ws);
    
    [self.engine getBillDetail:dic success:^(NSDictionary *detail) {
        
        progress_hide
        
        if (detail) {
            [ws updateUI:detail];
        }else{
            //resp为空，走list
            DDLogError(@"detail nil");
            [ws updateUI:self.dic];
        }
        
        
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];
}


-(void)updateUIFromNoti:(NSDictionary *)result{
    
    self.billDetailUnit = result;
    
    self.accrual = self.billDetailUnit[@"accrual"];
    self.order_flag = self.billDetailUnit[@"order_flag"];
    
    if([self.order_flag isEqualToString:@"W"] && [self.billDetailUnit[@"status"] integerValue] == 0){
        self.moneyViewModel.title = @"交易进行中";
    }
    
    
    [self.tableView reloadData];
}


-(void)updateUI:(NSDictionary *)result{
    
    self.billDetailUnit = result;
    
    if([self.order_flag isEqualToString:@"W"] && [self.billDetailUnit[@"status"] integerValue] == 0){
        self.moneyViewModel.title = @"交易进行中";
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.headArr.count;
    }
    
    return self.typeNameArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return IPHONE6_ORI_VALUE(123);
        }else{
            return [ZAPP.zdevice getDesignScale:56];
        }
    }
    
    NSString *type_title = self.typeNameArr[indexPath.row];
    if ([type_title isEqualToString:@"progress"]) {
        return 87;
    }
    
    return [ZAPP.zdevice getDesignScale:58];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    UIView *_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 10)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    return _headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BDMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BDMoneyCell_id"];
            [cell config:self.moneyViewModel.title content:self.moneyViewModel.detail];
            
            cell.leftSpace = YES;
            
            if(indexPath.row == self.headArr.count - 1){
                cell.bottomLineHidden = YES;
            }else{
                cell.bottomLineHidden = NO;
            }
            
            return cell;
        }else{
            HeaderNamePersonCell *cell = [HeaderNamePersonCell cellWithNib:tableView];
            [cell.headImgView setHeadImgeUrlStr:EMPTYOBJ_HANDLE(self.billDetailUnit[@"headimg"])];
            cell.nameLabel.text=EMPTYSTRING_HANDLE(self.billDetailUnit[@"userrealname"]);

            return cell;
        }

    }else{
        CNTableViewCell *cell = nil;
        if (indexPath.row<self.typeNameArr.count) {
            
            NSString *type_title = self.typeNameArr[indexPath.row];
            if ([type_title isEqualToString:@"progress"]) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"BillProgressCell_ID"];
                [(BillProgressCell *)cell setContinuing:[self.billDetailUnit[@"status"] integerValue] == 1 ?NO:YES];
                [(BillProgressCell *)cell setResultDic:self.billDetailUnit];
                
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"BDDetailCell_id"];
                
                [(BDDetailCell *)cell config:type_title
                                     content: [self value:type_title flag:self.order_flag]
                                contentColor:[BillDetailConfig contentColor:self.order_flag title:type_title]
                 ];
                
            }
            
            cell.leftSpace = YES;
        }
        
        if(indexPath.row == self.typeNameArr.count - 1){
            cell.bottomLineHidden = YES;
        }else{
            cell.bottomLineHidden = NO;
        }
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.typeNameArr.count) {
        
        NSString *type_title = self.typeNameArr[indexPath.row];
        NSInteger loanid = [self.billDetailUnit[@"loanid"] integerValue];
        NSInteger bet_id = [self.billDetailUnit[@"bet_id"] integerValue];
        
        
        if ([BillDetailConfig shouldTapToOpen:self.order_flag title:type_title]) {
            
            NSString *flag = self.order_flag;
            
            UIViewController*vc = [BillDetailConfig dispathTapOpenViewController:flag loadid:loanid betid:bet_id];
            [self.navigationController pushViewController:vc animated:YES];

        }
    
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)value:(NSString *)_title  flag:(NSString *)_aorder_flag {
    
    if (self.getDataByList) {
        //收益的数据需要从列表传进来的dic取
        return [BillDetailConfig value:_title listDic:self.dic];
        
    }else{
        return  [BillDetailConfig value:_aorder_flag
                                keyName:_title detailDic:self.billDetailUnit];
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
