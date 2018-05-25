//
//  InvesDetailListViewController.m
//  Cashnice
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "InvesDetailListViewController.h"
#import "InvesDetailConfig.h"
#import "ListDetailDataReformer.h"
#import "CNTitleDetailArrowBlueTipCell.h"
#import "CNTitleCouponCell.h"
#import "CNTitleCouponInterestCell.h"
#import "NewLoanProtocolViewController.h"

@interface InvesDetailListViewController (){
    NSString* mayturninfo;//可转让提现本息说明
}
@end

@implementation InvesDetailListViewController
@synthesize typeNameArr = _typeNameArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//子类重写
-(NSArray *)typeNameArr{
    
    if (!_typeNameArr) {
        _typeNameArr = @[].mutableCopy;
    }
    
    return _typeNameArr;
}


-(void)getDetail{
    
    progress_show
    
    WS(ws);
    [self.engine getListDetail:self.loanId typeid:@"B" betid:self.betId success:^(NSDictionary *detail) {
        progress_hide
        
        [ws updateUI:detail];
        
        
    } failure:^(NSString *error) {
        progress_hide
        
    }];
}


-(void)updateUI:(NSDictionary *)dic{
    self.detailDic = dic;
    
    
    mayturninfo = [EMPTYSTRING_HANDLE( dic[@"mayturninfo"]) length]?EMPTYSTRING_HANDLE( dic[@"mayturninfo"]):@"转让后利息扣减10%管理费";
    
    self.title = EMPTYSTRING_HANDLE([self.detailDic objectForKey:@"loantitle"]);
    
    [self.typeNameArr removeAllObjects];
    
    [self.typeNameArr addObjectsFromArray:[InvesDetailConfig baseArr:self.detailDic]];
    [self.tableView reloadData];
    
    WS(ws);

    [self.engine getWaterFlowDetail:self.loanId typeid:@"B"
     betid:self.betId
                success:^(NSArray *list) {

                                [ws updateWaterFlow:list];
                    
                            } failure:^(NSString *error) {
                                
                            }];
}



-(void)updateWaterFlow:(NSArray *)list{
    
    if ([ListDetailDataReformer showWaterFlowTip:self.detailDic type:@"B" list:list]) {

        [self.typeNameArr addObject:@{@"交易明细":list?list:@[]}];
        [self.tableView reloadData];
    }
    
}

-(NSString *)cellDetail:(NSIndexPath *)indexPath title:(NSString *)title{
    return [ListDetailDataReformer valueForList:self.detailDic title:title type:@"B"];
}

-(BOOL)showBlueTip:(NSIndexPath*)indexPath{
    
//    NSInteger isoverdue = [self.detailDic[@"isoverdue"] integerValue];
//    NSInteger loanstatus = [self.detailDic[@"loanstatus"] integerValue];
    
    NSInteger ub_turn = [self.detailDic[@"ub_turn"] integerValue];
    
//    if (isoverdue!=1 && (loanstatus==2 || loanstatus == 3) && ub_turn== 1 && indexPath.section == 0) {
    
    if (ub_turn == 1 && indexPath.section == 0) {
        if (indexPath.section<self.typeNameArr.count) {
            NSDictionary *dic = self.typeNameArr[indexPath.section];
            NSArray *arr = [[dic allValues] firstObject];
            
            if (indexPath.row < arr.count) {
                NSString*title =arr[indexPath.row];
                if ([title isEqualToString:@"应收利息"]) {
                    return YES;
                }
            }
        }
    }
    

    
    return NO;
}

-(UITableViewCell *)cellForDetail:(UITableView *)tw indexPath:(NSIndexPath *)indexPath{
    

    //显示带有蓝色问号的cell
    if ([self showBlueTip:indexPath] ) {
        
        if (indexPath.section<self.typeNameArr.count) {

        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
            if (indexPath.row < arr.count) {
                NSString*title =arr[indexPath.row];
                CNTitleDetailArrowBlueTipCell *cell = [CNTitleDetailArrowBlueTipCell cellWithTableView:tw];
                cell.tip = mayturninfo;
                [cell configureTitle:title detail:[self cellDetail:indexPath title:title]
                      rightLabelType:[self cellRightType:indexPath title:title]];
                return cell;

            }
        }

    }
    
    //显示红包和加息券专属样式的cell
    if([self showCouponPacket:indexPath]){
        return [self cellForCoupon:indexPath];
    }
    
    //显示加息券专属样式的cell
    if([self showCouponInterest:indexPath]){
        return [self cellForInterest:indexPath];
    }
    
    //正常cell
    return [super cellForDetail:tw indexPath:indexPath];

}

-(BOOL) showCouponPacket:(NSIndexPath*)indexPath{
    
    if([EMPTYOBJ_HANDLE(self.detailDic[@"coupon"]) integerValue]<=0){
        return NO;
    }
    
    if (indexPath.section<self.typeNameArr.count) {
        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            NSString*title =arr[indexPath.row];
            if ([title isEqualToString:@"本金"]) {
                return YES;
            }
            
            
            
        }
    }

    return NO;
}


-(BOOL) showCouponInterest:(NSIndexPath*)indexPath{
    
    
    if([EMPTYOBJ_HANDLE(self.detailDic[@"interestcoupon"]) integerValue]<=0){
        return NO;
    }
    
    if (indexPath.section<self.typeNameArr.count) {
        NSDictionary *dic = self.typeNameArr[indexPath.section];
        NSArray *arr = [[dic allValues] firstObject];
        
        if (indexPath.row < arr.count) {
            NSString*title =arr[indexPath.row];
            if ([title isEqualToString:@"年利率"]) {
                return YES;
            }
            
            
            
        }
    }
    
    return NO;
}


-(UITableViewCell *)cellForCoupon:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.typeNameArr[indexPath.section];
    NSArray *arr = [[dic allValues] firstObject];
    if (indexPath.row < arr.count) {
        NSString*title =arr[indexPath.row];
        
        CNTitleCouponCell *cell = [CNTitleCouponCell cellWithTableView:self.tableView];
        [cell configureTitle:title detail:@"" showAcc:NO];
        [cell configure:[self cellDetail:indexPath title:title] couponPacket:[ListDetailDataReformer couponPacket:self.detailDic]];
        return cell;
    }
    

    return nil;
}


-(UITableViewCell *)cellForInterest:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.typeNameArr[indexPath.section];
    NSArray *arr = [[dic allValues] firstObject];
    if (indexPath.row < arr.count) {
        NSString*title =arr[indexPath.row];
        
        CNTitleCouponInterestCell *cell = [CNTitleCouponInterestCell cellWithTableView:self.tableView];
        [cell configureTitle:title detail:@"" showAcc:NO];
        [cell configure:[self cellDetail:indexPath title:title] couponPacket:[ListDetailDataReformer couponInterest:self.detailDic]];
        return cell;
    }
    
    
    return nil;
}


-(void)openWebProtocol{
    NewLoanProtocolViewController *vc = [[NewLoanProtocolViewController alloc]init];
    vc.type = 3;
//    vc.loanId = self.loanId;
    vc.addtionParmas = [NSString stringWithFormat:@"loanid=%@&betid=%@",@(self.loanId),@(self.betId)];
    [self.navigationController pushViewController:vc animated:YES];
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
