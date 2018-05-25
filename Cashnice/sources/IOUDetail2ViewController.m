//
//  IOUDetail2ViewController.m
//  Cashnice
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 l. All rights reserved.
//

#import "IOUDetail2ViewController.h"
#import "IOURefuseViewController.h"
#import "CustomViewController+PickDate.h"
#import "IOURejectInstance.h"


@interface IOUDetail2ViewController ()<IOURefuseDelegate>
{
    CGFloat original_ui_loan_rate;
    
    IOURejectInstance *rejectInstance;
    
    NSArray *rejectArr;
}
@end

@implementation IOUDetail2ViewController

@synthesize typeNameArr = _typeNameArr;
@synthesize protocol = _protocol;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showBlueTip = YES;
    self.blueTip = self.type==0?@"请添加您的出借凭证":@"请添加您的收款凭证";
    bugeili_net_new
    
    progress_show
    [self getDetail];

    rejectInstance  = [IOURejectInstance shareInstance];
    [rejectInstance getRejectReasonList:self.type ==0?8:9 success:^(NSArray *arr) {
        rejectArr = arr;
    } failure:^(NSString *error) {
        
    }];
    
    WS(weakSelf);
    [self.w_engine getLoanRateSuccess:^(NSArray *arr) {
        weakSelf.rateArr  = arr;
    } failure:^(NSString *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavRightBtn];
    
    self.title = @"借条详情";

}

-(void)setNavRightBtn{
    
    [super setNavRightBtn];
    
    if ([self navRightEnabled]) {
        [self.rightNavBtn setTitle:@"驳回" forState:UIControlStateNormal];
    }else{
        self.rightNavBtn.userInteractionEnabled = NO;
    }
    
}

-(void)rightNavItemAction{
    
    
    //驳回的，本地不在判断邮箱，只判断黑名单
    
    if ([IOUConfigure inBlackIOULimited]) {
        return ;
    }
    
    IOURefuseViewController *ifvc = ZIOU(@"IOURefuseViewController");
    ifvc.refuse_arr = rejectArr;
    ifvc.delegate = self;
    [self.navigationController pushViewController:ifvc animated:YES];
    
}

-(BOOL)navRightEnabled{
    
    //借条待确认，
    if(detailUnit.ui_status == 1 && detailUnit.create_user == [[ZAPP.myuser getUserID] integerValue]){
        return NO;
    }
    
    return YES;
}


-(NSString *)protocol{
    
    if (!_protocol) {
        _protocol =[IOUConfigure makeAgreeProtol:detailUnit.ui_id rate:detailUnit.ui_loan_rate];
    }
    
    return _protocol;
}

//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@{@"hh":@[@"hh"]}];
        [tempArr addObject:@{@"bb":[IOUConfigure detail2:self.type]}];
        [tempArr addObject:@{@"btn":@[@"btn"]}];
        
        _typeNameArr = tempArr;
    }
    
    return _typeNameArr;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_0];
    } else if (indexPath.section == 1) {
        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_1];
    } else if (indexPath.section == 2) {
//        return [ZAPP.zdevice getDesignScale:ROW_HEIGHT_BTN];
        return 75;

    }
    
    return 0;
}

//子类根据情况重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self cellForTopRelation:tableView indexPath:indexPath];
    }else if (indexPath.section == 1) {
        return [self cellForDetail:tableView indexPath:indexPath];
    }else if (indexPath.section == 2) {
        return [self cellForBtn:tableView indexPath:indexPath];
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        NSDictionary*dic  = self.typeNameArr[1];
        NSArray *arr = [[dic allValues] objectAtIndex:0];
        if ([arr count]) {
            
            if ([[arr objectAtIndex:indexPath.row] isEqualToString:@"借条协议"]){
                [self openProtocal:self.protocol];
            }else if ([[arr objectAtIndex:indexPath.row] isEqualToString:@"借款用途及凭证"]){
                [self openDetailUseage];
                return;
            }else
                if ([[arr objectAtIndex:indexPath.row] rangeOfString:@"年化利率"].location != NSNotFound && self.type == 1){

                if (!original_ui_loan_rate) {
                    original_ui_loan_rate = detailUnit.ui_loan_rate;
                }
                    
                [self openArrayPicker:[self makeRateArr] selectIndex:[self indexInRateArr]];
                return;
            }
            
 
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)bottomBtnName{
    return @"确定";
}

#pragma mark - 驳回
-(void)refuseDidSelected:(NSDictionary *)reasonDic{

    //我驳回的，本地不在判断邮箱
    if ([IOUConfigure inBlackIOULimited]) {
        return ;
    }
    
    WS(ws);

    [self rejectIOU:[reasonDic[@"itemvalue"] integerValue] complete:^{
        POST_IOULISTFRESH_NOTI;
        [ws.navigationController popToRootViewControllerAnimated:YES];
    }];
}

-(void)openDetailUseage{
    
    if (self.type == 0) {
        NSDictionary *dic1 = @{@"title":@"借款人凭证",
                              @"action":@(NO)};
        
        NSDictionary *dic2 = @{@"title":@"出借人凭证",
                              @"action":@(YES)};

        [self openVoucher:@[dic1,dic2]];

    }else{
        
        NSDictionary *dic1 = @{@"title":@"出借人凭证",
                               @"action":@(NO)};
        
        NSDictionary *dic2 = @{@"title":@"借款人凭证",
                               @"action":@(YES)};

        
        [self openVoucher:@[dic1,dic2]];

    }
    
    
}

-(void)buttonAction:(id)sender{
    
    if ([IOUConfigure inBlackIOULimited]) {
        return ;
    }
    
    //同意加邮箱判断
    WITHOUT_EMAIL_PUSH
    
    //我是借款人，可以修改利率（只能增加）
    [self agreeIOU: (cpvc?cpvc.finishedImageArr:nil)];
}

#pragma mark - 选择利率

-(void)arrayPickDidSelIndex:(NSInteger)index{
    
    //我是借款人，利率只能上调不能下调
    
    CGFloat value =  [[self.rateArr[index] objectForKey:@"rateValue"] floatValue];
    if (value<= original_ui_loan_rate) {
        return;
    }
    detailUnit.ui_loan_rate = value;
    [self.tableView reloadData];
    //重新计算费用
    [self calculateTotalFee];
    
}

-(void)updateUI:(IOUDetailUnit *)unit{
    [super updateUI:unit];
    
    if (!unit.backReason||[unit.backReason length]==0) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@{@"hh":@[@"hh"]}];
        [tempArr addObject:@{@"bb":[IOUConfigure detail2:4]}];
        [tempArr addObject:@{@"btn":@[@"btn"]}];
        
        _typeNameArr = tempArr;
        [self.tableView reloadData];
        
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
