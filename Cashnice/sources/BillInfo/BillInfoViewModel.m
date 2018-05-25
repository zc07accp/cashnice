//
//  BillInfoViewModel.m
//  Cashnice
//
//  Created by a on 16/9/19.
//  Copyright © 2016年 l. All rights reserved.
//

#import "BillInfoViewModel.h"
#import "BillInfoViewController.h"
#import "LoanDetailEngine.h"
#import "BillViewController.h"

@interface BillInfoViewModel (){
    NSUInteger _loanId;
    NSUInteger _betId;
    LoanBillType _billType;
    NSDictionary *_model;
}
@end

@implementation BillInfoViewModel

- (instancetype)initWithLoanId:(NSUInteger)loanid billType:(LoanBillType)billType{
    return [self initWithLoanId:loanid betid:-1 billType:billType];
}

- (instancetype)initWithLoanId:(NSUInteger)loanid betid:(NSUInteger)betid billType:(LoanBillType)billType{
    if (self = [super init]) {
        _loanId = loanid;
        _billType = billType;
        _betId = betid;
        
        return self;
    }
    return nil;
}

- (UIImage *)headImage{
    return [UIImage imageNamed:@"duihao.png"];
}
- (NSString *)headImageName{
    return nil;
}
- (NSAttributedString *)accountPromptString{
    return nil;
}
- (NSString *)title4PromptString{
    return @"";
}
- (NSString *)viewTitle{
    return [self model][@"loantitle"] ;
}

- (NSNumber *)accountNumber{
    return @([[self model][@"title2"] doubleValue]);
}
- (NSString *)accountString{
    return [Util formatRMBWithoutUnit:[self accountNumber]]; //@([[self model][@"money"] doubleValue]);
}
- (NSString *)appreciationPromptString{
    return [self model][@"title3"];
}
- (NSNumber *)mainvalNumber{
    return @([[self model][@"loanmainval"] doubleValue]);
}
- (NSNumber *)rateNumber{
    return @([[self model][@"loanrate"] doubleValue]);
}
- (NSString *)startDate{
    return [self model][@"datetime1"];
}
- (NSString *)endDate{
    return [self model][@"datetime2"];
}
- (BOOL)showProtection{
    return NO;
}

- (NSArray *)actions{
    return @[];
}

- (NSDictionary *)model {
    return _model;
}

- (BOOL)isOverdue{
    return [_model[@"isoverdue"] boolValue];
}

- (BOOL)isGrace{
    return ([self isOverdue] && [_model[@"isgrace"] boolValue]);
}

- (NSString *)loanuserheadimg{
    return _model[@"loanuserheadimg"];
}

- (NSString *)loanusername{
    return _model[@"loanusername"];
}

- (NSUInteger)latedays{
    return [_model[@"latedays"] integerValue];
}

-(NSArray *)warrantyRepayment{
    return EMPTYOBJ_HANDLE(_model[@"warrantyRepayment"]);
}

-(NSInteger)loantype{
    
    if (_model) {
        return [EMPTYOBJ_HANDLE(_model[@"loantype"]) integerValue];
    }
    
    return 2;
}


- (BOOL)alreadyToUse{
    return ![_model isKindOfClass:[NSNull class]];
}

- (NSUInteger)betid{
    return _betId;
}

- (LoanState)loanState{
    return [_model[@"loanstatus"] intValue];
}

- (NSUInteger)packageValue{
    return [_model[@"coupon"] integerValue];
}

- (double)couponValue{
    return [_model[@"interestcoupon"] doubleValue];
}

//今日到期
- (BOOL)islastday{
    return [_model[@"islastday"] boolValue];
}

//是否可转让
- (BOOL)isTransferable{
    return NO;
}

//是否有转让功能
- (BOOL)isTransferEnabled{
    return NO;
}

- (TRANSFER_OPERATION_PROGRESS)transferOperationProgress{
    return TRANSFER_OPERATION_PROGRESS_NON;
}

- (void)pushDetailView{
}

- (void)setVc:(BillInfoViewController *)vc{
    _vc = vc;
    [self connectToServer];
}

- (void)showBillView{
    //我的账单
    /*
    NSArray *vcs = self.vc.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[BillViewController class]]) {
            [self.vc.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    */
    UIViewController *bill = ZBill(@"BillViewController");
    [self.vc.navigationController pushViewController:bill animated:YES];
}

- (void)connectToServer {
    LoanDetailEngine *engine = [[LoanDetailEngine alloc] init];
    WS(weakSelf);
    [engine getDetail:_loanId typeid:[NSString stringWithFormat:@"%c", (char)_billType] betid:[self betid] success:^(NSDictionary *detail) {
        _model = detail;
        [weakSelf.vc setupUI];
    } failure:^(NSString *error) {
        [weakSelf.vc setupUI];
    }];
}

+(NSString *)valueForList:(NSDictionary *)detail title:(NSString *)title{
    
    if([title isEqualToString:@"发布日"]){
        return detail[@"datetime1"];
    }
    
    return @"";
}

/*
- (void)pushFromView:(UIViewController *)view{
    if (self.vc) {
        [view.navigationController pushViewController:self.view animated:YES];
    }
}

- (BillInfoViewController *)view{
    if (! _view) {
        _view = [[BillInfoViewController alloc] init];
        _view.vm = self;
    }
    return _view;
}
*/

@end
