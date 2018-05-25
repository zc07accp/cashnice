//
//  SinaWithdrawViewController.m
//  Cashnice
//
//  Created by a on 16/8/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SinaWithdrawViewController.h"
#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"
#import "CNActionButton.h"
#import "MyRemainMoneyInterestViewController.h"

@interface SinaWithdrawViewController () <HandleCompletetExport>
{
    
    double _balance;    //当前余额
    
    double _maxAmount;   //最大可提现金额
    
    //字符串描述
    NSString *balanceStr;
    NSString *maxAmountStr;
}

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *normalLabelCollection;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet CNActionButton *withdrawButton;
@property (weak, nonatomic) IBOutlet UILabel *paymentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *valuePromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawAllButton;
@property (weak, nonatomic) IBOutlet UILabel *jinePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanPromptLabel;

@property (strong, nonatomic) MKNetworkOperation *op;
@end

@implementation SinaWithdrawViewController

//提现

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    [self setNavButton];
    //[self setRightNavBar];
    [self setupUI];
    [self tapBackground];
    
    [self getPaymentDate];
    
    [self getWithDrawLimit:YES];
}

- (void)setupUI{
    [self.normalLabelCollection enumerateObjectsUsingBlock:^(UILabel  *lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.font = [UtilFont systemMiddleNormal];
    }];
    
    self.valuePromptLabel.font =
    self.withdrawAllButton.titleLabel.font = [UtilFont systemMiddleNormal];
    
    self.jinePromptLabel.font =
    self.yuanPromptLabel.font =
    self.valueTextField.font  =  [UtilFont systemLargeNormal];
    //self.withdrawButton.associatedTextField = self.valueTextField;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"提现"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"提现"];
}

- (void)showProgressHud:(BOOL)viewLoading{
    if (viewLoading) {
        progress_show
    }
}
- (void)hideProgressHud:(BOOL)viewLoading{
    if (viewLoading) {
        progress_hide
    }
}

- (void)getWithDrawLimit:(BOOL)viewLoading{
    [self showProgressHud:viewLoading];
    
    WS(weakSelf);

    [ZAPP.netEngine getWithDrawLimit:[self getInputedNumberValue] complete:^{
        
        [weakSelf hideProgressHud:viewLoading];
        
        NSDictionary *limtDcit = ZAPP.myuser.withdrawLimitRespondDict;
        
        
        if (viewLoading) {  //[weakSelf getInputedNumberValue] < 0.009 &&
            //当前余额
            _balance = [limtDcit[@"balance"] doubleValue];// > 0.009 ? [limtDcit[@"balance"] doubleValue] : _balance;
            balanceStr = [Util formatRMBOnlyString:@(_balance)];
            //最大可提现金额
            _maxAmount = [limtDcit[@"max_amount"] doubleValue];// > 0.009 ? [limtDcit[@"max_amount"] doubleValue] : _maxAmount;
            maxAmountStr = [Util formatRMBOnlyString:@(_maxAmount)];
        }
        
        //手续费
        double userFee = [limtDcit[@"user_fee"] doubleValue];
        NSString *userFeeStr;
        if (userFee >= 0) {
            userFeeStr = [Util formatRMBOnlyString:@(userFee)];
        }
        
        //if ([weakSelf getInputedValue].length < 1) {
        if ([weakSelf getInputedNumberValue] < 0.01) {
            //没有输入金额，
            weakSelf.valuePromptLabel.text = [NSString stringWithFormat:@"当前账户余额%@元,", [Util formatRMBOnlyString:@(_balance)]];
            weakSelf.withdrawAllButton.hidden = NO;
            weakSelf.withdrawButton.enabled = NO;
        }else if ([weakSelf getInputedNumberValue] > _balance) {
            //输入金额超出账户余额
            weakSelf.valuePromptLabel.text = [NSString stringWithFormat:@"输入金额超出账户余额"];
            weakSelf.withdrawAllButton.hidden = YES;
            weakSelf.withdrawButton.enabled = NO;
        }else if ([weakSelf getInputedNumberValue] > _maxAmount) {
            //提现额度超出提示
            weakSelf.valuePromptLabel.text = [NSString stringWithFormat:@"额外扣除%@元手续费,当前最大提现额度为%@元", userFeeStr, maxAmountStr];
            weakSelf.withdrawAllButton.hidden = YES;
            weakSelf.withdrawButton.enabled = NO;
        }else{
            if (userFee >= 0) {
                weakSelf.valuePromptLabel.text = [NSString stringWithFormat:@"额外扣除%@元手续费", userFeeStr];
                weakSelf.withdrawAllButton.hidden = YES;
                weakSelf.withdrawButton.enabled = YES;
            }
        }
    } error:^{
        [self hideProgressHud:viewLoading];
    }];
}

- (IBAction)withdrawAllAction:(id)sender {
    self.valueTextField.text = [NSString stringWithFormat:@"%@", @(_maxAmount)];
    [self getWithDrawLimit:NO];
}

- (IBAction)withdrawAction:(id)sender {
    [self tapOnce];
    
    if ([[self getInputedValue] doubleValue] <= 0) {
        [Util toastStringOfLocalizedKey:@"tip.inputtingWithdrawCount"];
        return;
    }
    [self connectToValidate];
}

- (void)connectToValidate{
    [self.op cancel];
    __weak typeof(self) weakSelf = self;
    bugeili_net
    [SVProgressHUD show];
    self.op = [ZAPP.netEngine tixianValidateWithComplete:^{
        [weakSelf connectToCommit];
    } error:^{
        [SVProgressHUD dismiss];
        //[weakSelf loseData];
    } value:[self getInputedValue]];
}

- (void)connectToCommit{
    __weak typeof(self) weakSelf = self;
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    progress_show
    [model withdraw:[self getInputedValue] success:^(NSData *contentData) {
        progress_hide
        //[weakSelf pushToSinaWebViewWithContentData:contentData];
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.loadData = contentData;
        web.titleString = @"提现";
        web.completeHandle = self;
        [weakSelf.navigationController pushViewController:web animated:YES];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

- (void)getPaymentDate{
    
    WS(ws);

    [ZAPP.netEngine getPaymentDate:^{
        ws.paymentDateLabel.text = ZAPP.myuser.paymentDate;
    } error:^{
        ;
    }];
}

- (void)complete {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyRemainMoneyInterestViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)getInputedValue {
    return [self.valueTextField.text trimmed];
}

- (double)getInputedNumberValue{
    NSString *strVal = [self getInputedValue];
    return [strVal doubleValue];
}

- (IBAction)inputChanged{
    self.valueTextField.text = [Util cutMoney:self.valueTextField.text];
    if ([self getInputedNumberValue] < 0.009) {
        self.withdrawButton.enabled = NO;
    }
    [self getWithDrawLimit:NO];
}

#pragma mark - gesture method
-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

-(void)tapOnce
{
    [self.view endEditing:YES];;
}

@end
