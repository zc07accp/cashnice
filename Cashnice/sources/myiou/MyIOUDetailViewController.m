//
//  MyIOUDetailViewController.m
//  Cashnice
//
//  Created by a on 16/7/27.
//  Copyright © 2016年 l. All rights reserved.
//

#import "MyIOUDetailViewController.h"
#import "CertificatePreviewViewController.h"

@interface MyIOUDetailViewController ()

@property (nonatomic) IouSatusType iouStatus;
@property (nonatomic) BOOL isOverDue;
@property (nonatomic, strong) NSDictionary *mappedIouValues;

@end

@implementation MyIOUDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDetail];
    
    self.title = @"详情";
}

-(NSArray *)typeNameArr{
        return [NSArray arrayWithObjects:
                            @{@"交易信息":[self transactionNames]},
                            @{@"基本信息":[self primaryNames]},
                            //@{@"交易凭证":[self certificateNames]},
                            nil];
}


-(BOOL)showBlankWithSection{
    return YES;
}

-(void)updateUI:(IOUDetailUnit *)unit{
    [super updateUI:unit];
    
    self.title = @"详情";
}

- (NSArray *)transactionNames {
    
    if (self.preoccupiedTransactionNames) {
        return self.preoccupiedTransactionNames;
    }
    
    NSArray *namesArray = nil;
    if ([self iouStatus] == IOU_STATUS_REPAY_CONFIRM) {
        //历史
        if (self.isOverDue) {
            //逾期
            if (self.iouListPageType == IouListPageTypeCreditor) {
                //我的出借
                namesArray = @[@"出借人", @"借款人", @"出借日", @"收回日", @"本金", @"年利率", @"应收利息", @"应收逾期利息", @"应收回", @"实际收回", @"平台服务费", @"还款方式"];
            }else{
                //我的借款
                namesArray = @[@"出借人", @"借款人", @"借入日", @"还款日", @"本金", @"年利率", @"应付利息", @"逾期利息", @"应还款", @"已还款", @"平台服务费", @"还款方式"];
            }
        }else{
            //未逾期
            if (self.iouListPageType == IouListPageTypeCreditor) {
                //我的出借
                namesArray = @[@"出借人", @"借款人", @"出借日", @"收回日", @"本金", @"年利率", @"应收利息", @"应收回", @"实际收回", @"平台服务费", @"还款方式"];
            }else{
                //我的借款
                namesArray = @[@"出借人", @"借款人", @"借入日", @"还款日", @"本金", @"年利率", @"应付利息", @"应还款", @"已还款", @"平台服务费", @"还款方式"];
            }
        }
    }else{
        //逾期
        if (self.isOverDue) {
            if (self.iouListPageType == IouListPageTypeCreditor) {
                namesArray = @[@"出借人", @"借款人", @"出借日", @"收回日", @"本金", @"年利率", @"应收利息", @"应收逾期利息", @"应收回", @"平台服务费"];
            }else{
                namesArray = @[@"出借人", @"借款人", @"借入日", @"还款日", @"本金", @"年利率", @"应付利息", @"逾期利息", @"应还款", @"平台服务费"];
            }
        }else{
            //进行中
            if (self.iouListPageType == IouListPageTypeCreditor) {
                namesArray = @[@"出借人", @"借款人", @"出借日", @"收回日", @"本金", @"年利率", @"应收利息", @"应收回", @"平台服务费"];
            }else{
                namesArray = @[@"出借人", @"借款人", @"借入日", @"还款日", @"本金", @"年利率", @"应付利息", @"应还款", @"平台服务费"];
            }
        }
    }
    return namesArray;
}

- (NSArray *)primaryNames {
    return @[@"交易编号", @"借款用途", @"借条协议", @"交易凭证"];
}

-(BOOL)cellShowAcc:(NSIndexPath *)indexPath title:(NSString *)title{
    if ([title isEqualToString:@"借条协议"] ||
        [title isEqualToString:@"交易凭证"]) {
        return YES;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForDetail:tableView indexPath:indexPath];
    cell.textLabel.textColor = ZCOLOR(COLOR_TEXT_DARKBLACK);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1) {
        NSDictionary*dic  = self.typeNameArr[1];
        NSArray *arr = [[dic allValues] objectAtIndex:0];
        if ([arr count]) {
            
            if ([[arr objectAtIndex:indexPath.row] isEqualToString:@"交易凭证"]){
                [self pushCertificateView];
            }else if ([[arr objectAtIndex:indexPath.row] isEqualToString:@"借条协议"]){
                [self openProtocal:[IOUConfigure makeNOEditProtol:detailUnit.ui_id]];
            }
        }
    }
}

- (void) pushCertificateView {
    CertificatePreviewViewController *cer = [[CertificatePreviewViewController alloc] init];
    cer.detailUnit = detailUnit;
    cer.specialTitle = @"凭证";
    cer.certificateOnly = YES;
    NSArray *models = @[
                        @{@"title":@"借款人凭证",@"action":@(NO)},
                        @{@"title":@"出借人凭证",@"action":@(NO)}
                        ];
    cer.models = models;
    [self.navigationController pushViewController:cer animated:YES];
}

//
//- (NSArray *)certificateNames {
//    return @[@"出借人", @"借款人"];
//}

//-(NSString *)contentForIndexPath:(NSIndexPath *)path{
//    if (path.section == 2) {
//        return nil;
//    }
//    NSString *title = [self titleOfIndexPaht:path];
//    NSString *value = self.mappedIouValues[title];
//    return value;
//}
//
//- (NSDictionary *)mappedIouValues{
//    if (! _mappedIouValues) {
//        NSMutableDictionary *restoreValues = [[NSMutableDictionary alloc] init];
//        //出借人
//        NSDictionary *srcUser = self.iouDetailDict[@"srcUser"];
//        if (srcUser) {
//            [restoreValues setObject:srcUser[@"user_real_name"] forKey:@"出借人"];
//        }
//        //借款人
//        NSDictionary *destUser = self.iouDetailDict[@"destUser"];
//        if (destUser) {
//            [restoreValues setObject:destUser[@"user_real_name"] forKey:@"借款人"];
//        }
//        //借入日 & 出借日
//        [restoreValues setObject:self.iouDetailDict[@"ui_loan_start_date"] forKey:@"借入日"];
//        [restoreValues setObject:self.iouDetailDict[@"ui_loan_start_date"] forKey:@"出借日"];
//        
//        //还款日 & 收回日
//        if (self.iouStatus != IOU_STATUS_REPAY_CONFIRM) {
//            [restoreValues setObject:self.iouDetailDict[@"ui_loan_end_date"] forKey:@"还款日"];
//            [restoreValues setObject:self.iouDetailDict[@"ui_loan_end_date"] forKey:@"收回日"];
//        }else{
//            [restoreValues setObject:self.iouDetailDict[@"format_repay_confirm_time"] forKey:@"还款日"];
//            [restoreValues setObject:self.iouDetailDict[@"format_repay_confirm_time"] forKey:@"收回日"];
//        }
//        //本金
//        double ui_loan_val = [self.iouDetailDict[@"ui_loan_val"] doubleValue];
//        [restoreValues setObject:[Util formatRMB:@(ui_loan_val)] forKey:@"本金"];
//        //年利率
//        double ui_loan_rate = [self.iouDetailDict[@"ui_loan_rate"] doubleValue];
//        [restoreValues setObject:[NSString stringWithFormat:@"%@%%", @(ui_loan_rate)] forKey:@"年利率"];
//        
//        //应付利息 & 应收利息
//        double ui_interest_val = [self.iouDetailDict[@"ui_interest_val"] doubleValue];
//        [restoreValues setObject:[Util formatRMB:@(ui_interest_val)] forKey:@"应付利息"];
//        [restoreValues setObject:[Util formatRMB:@(ui_interest_val)] forKey:@"应收利息"];
//        
//        //逾期利息 & 应收逾期利息
//        double ui_overdue_interest_val = [self.iouDetailDict[@"ui_overdue_interest_val"] doubleValue];
//        [restoreValues setObject:[Util formatRMB:@(ui_overdue_interest_val)] forKey:@"逾期利息"];
//        [restoreValues setObject:[Util formatRMB:@(ui_overdue_interest_val)] forKey:@"应收逾期利息"];
//        
//        //应还款 & 应收回
//        double total_amount = [self.iouDetailDict[@"total_amount"] doubleValue];
//        [restoreValues setObject:[Util formatRMB:@(total_amount)] forKey:@"应还款"];
//        [restoreValues setObject:[Util formatRMB:@(total_amount)] forKey:@"应收回"];
//        
//        //已还款 & 实际收回
//        double ui_repay_amount = [self.iouDetailDict[@"ui_repay_amount"] doubleValue];
//        [restoreValues setObject:[Util formatRMB:@(ui_repay_amount)] forKey:@"已还款"];
//        [restoreValues setObject:[Util formatRMB:@(ui_repay_amount)] forKey:@"实际收回"];
//        
//        //交易编号
//        [restoreValues setObject:self.iouDetailDict[@"ui_orderno"] forKey:@"交易编号"];
//        
//        //借款用途
//        [restoreValues setObject:self.iouDetailDict[@"iouUsage"] forKey:@"借款用途"];
//        
//        _mappedIouValues = [restoreValues copy];
//        
//    }
//    return _mappedIouValues;
//}
//
//- (NSString *)titleOfIndexPaht:(NSIndexPath *)path{
//    if (path.section < self.typeNameArr.count) {
//        NSArray *currentSection = [[self.typeNameArr[path.section] allValues] firstObject];
//        if (path.row < currentSection.count) {
//            return currentSection[path.row];
//        }
//    }
//    return nil;
//}

- (IouSatusType)iouStatus{
    IouSatusType iouStatus = detailUnit.ui_status;//[self.iouDetailDict [@"ui_status"] intValue];
    return iouStatus;
}

- (BOOL)isOverDue{
    //return  [self.iouDetailDict[@"isOverDue"] integerValue] == 1;
    return detailUnit.isOverDue;
}

@end
