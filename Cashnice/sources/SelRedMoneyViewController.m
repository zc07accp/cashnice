//
//  SelRedMoneyViewController.m
//  Cashnice
//
//  Created by apple on 2017/2/14.
//  Copyright © 2017年 l. All rights reserved.
//

#import "SelRedMoneyViewController.h"
#import "RedMoneyCell.h"
#import "RaiseIntereCell.h"
#import "CustomTitledAlertView.h"
#import "CouponNetEngine.h"


@interface SelRedMoneyViewController (){
    NSInteger querytype;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) CouponNetEngine *c_engine;
@property (strong, nonatomic) NSArray *dataArray;


@property (weak, nonatomic) IBOutlet UIView *emptyBkView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImgView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel; //选择

@end

@implementation SelRedMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavButton];
    [self setNavRightBtn];
    
    self.view.backgroundColor = ZCOLOR(COLOR_DD_GRAY);
    //    self.tableView.rowHeight = 93;
    
    switch (self.type) {
        case REDMONEY_TYPE_CASH:
            self.title = @"选择红包";
            break;
            
        case REDMONEY_TYPE_RAISEINTEREST:
            self.title = @"选择加息券";
            break;
            
        case REDMONEY_TYPE_DECREASEINTEREST:
            self.title = @"选择优惠券";
            break;
            
        default:
            break;
    }
    
    //    self.title = self.type == REDMONEY_TYPE_CASH? @"选择红包":@"选择加息券";
    //
    //    if ( self.type == REDMONEY_TYPE_CASH) {
    //        self.tableView.rowHeight = 93;
    //    }else{
    self.tableView.estimatedRowHeight = 93;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //    }
    
    progress_show
    
    [self requestList];
    
    [Util setScrollHeader:self.tableView target:self header:@selector(requestList) dateKey:[Util getDateKey:self]];
    self.tableView.header.backgroundColor =  ZCOLOR(COLOR_DD_GRAY);
    
}


-(CouponNetEngine *)c_engine{
    
    if(!_c_engine){
        _c_engine = [[CouponNetEngine alloc]init];
    }
    
    return _c_engine;
}



-(void)setNavRightBtn{
    
    self.isRightNavBtnBorderHidden = YES;
    [super setNavRightBtn];
    [self.rightNavBtn setImage:[UIImage imageNamed:@"help_w"] forState:UIControlStateNormal];
}

-(void)rightNavItemAction{

    NSString *info = nil;
    
    if (self.type == REDMONEY_TYPE_CASH) {
        info = CNLocalizedString(@"tip.redmoney.pickpacket.tip", nil);
    }else{
        info = CNLocalizedString(self.invest ? @"tip.redmoney.raiseinterest.tip":@"tip.redmoney.decreaseinterest.tip", nil);
    }
    
//    NSString *tip = nil;

    CustomTitledAlertView *alertView = [[CustomTitledAlertView alloc] initWithTitle: @"使用说明" andInfo:info];
    alertView.tag = 0;
    [alertView show];
    [alertView formatAlertButton];
    alertView.bkColor = [UIColor whiteColor];
    alertView.messageTextColor = CN_TEXT_GRAY;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == REDMONEY_TYPE_CASH) {
        
        RedMoneyCell *cell =  [RedMoneyCell cellWithNib:tableView];
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
        
    }else{
        RaiseIntereCell *cell =  [RaiseIntereCell cellWithNib:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRedMoney:detail:)]){
        
        if(self.type == REDMONEY_TYPE_CASH){
            RMViewModel*model = self.dataArray[indexPath.row];
            if ([model.dic[@"canuse"] boolValue]) {
                [self.delegate didSelectedRedMoney:self.type detail:model.dic];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            
            RIViewModel*model = self.dataArray[indexPath.row];
            if ([model.dic[@"canuse"] boolValue]) {
                [self.delegate didSelectedRedMoney:self.type detail:model.dic];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)couponvalue{
    
    NSString *value = nil;
    
    switch (self.type) {
        case REDMONEY_TYPE_CASH:
            break;
            
        case REDMONEY_TYPE_RAISEINTEREST:
            //加息券
            value = @"0";
            break;
            
        case REDMONEY_TYPE_DECREASEINTEREST:
            //免息券
            value = @"2";
            break;
            
        default:
            break;
    }
    
    return value;
}

-(void)requestList{
    
    WS(ws);
    
    //    self.c_engine.closeAutoCache=NO;
    
    //    [self.c_engine getCouponList:querytype
    //                         redType:self.type
    //                   queryFromList:NO
    //                            page:0
    //                      coupontype:[self couponvalue]
    //                      startmoney:self.startmoney success:^(NSDictionary*totolDic, NSArray *arr) {
    //                          progress_hide
    //                          [ws endFreshing];
    //
    //                          [ws updateUI:arr total:totolDic];
    //                      } failure:^(NSString *error) {
    //                          progress_hide
    //                          [ws endFreshing];
    //
    //                      }];
    
    [self.c_engine getSelectCouponList:self.type invest:self.invest
                            startmoney:self.startmoney
                               success:^(NSDictionary*totolDic, NSArray *arr) {
                                   progress_hide
                                   [ws endFreshing];
                                   [ws updateUI:arr total:totolDic];
                               } failure:^(NSString *error) {
                                   progress_hide
                                   [ws endFreshing];
                               }];
    
}

-(void)updateUI:(NSArray *)arr total:(NSDictionary *)totalDic{
    
    self.dataArray = arr;
    
    if(arr.count){
        self.emptyBkView.hidden = YES;
        
    }else{
        self.emptyBkView.hidden = NO;
        
        NSString *tipStr = nil;
        switch (self.type) {
            case REDMONEY_TYPE_CASH:
                tipStr = @"红包";
                break;
                
            case REDMONEY_TYPE_RAISEINTEREST:
                //                self.title = @"选择加息券";
                tipStr = @"加息券";
                
                break;
                
            case REDMONEY_TYPE_DECREASEINTEREST:
                //                self.title = @"选择优惠券";
                tipStr = @"优惠券";
                
                break;
                
            default:
                break;
        }
        
        _emptyLabel.text = [NSString stringWithFormat:@"暂无“未使用”的%@",tipStr];
        //                            self.type == REDMONEY_TYPE_CASH? @"红包":@"加息券"];
        
        
        
    }
    
    
    //当前没有可用数据
    if([self allDisabled]  && self.delegate && [self.delegate respondsToSelector:@selector(redMoneyAllDisabled:)]){
        [self.delegate redMoneyAllDisabled:self.type];
    }
    
    self.emptyImgView.image = [UIImage imageNamed:self.type == REDMONEY_TYPE_CASH?@"packet_no":@"ticket_no"];
    
    
    [self.tableView reloadData];
    
    
}

-(BOOL)allDisabled{
    
    for (id mondel in self.dataArray) {
        
        if ([[mondel valueForKey:@"dic" ] [@"canuse"] boolValue]) {
            return NO;
        }
    }
    
    return YES;
}


-(void)endFreshing{
    [self.tableView.header endRefreshing];
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
