//
//  GuaranteeConfirmingViewController.m
//  Cashnice
//
//  Created by a on 2018/4/11.
//  Copyright © 2018年 l. All rights reserved.
//

#import "GuaranteeConfirmingViewController.h"
#import "NewLoanProtocolViewController.h"
#import "WebDetail.h"
#import "LoanDetailEngine.h"

@interface GuaranteeConfirmingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *promptLables;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *acountLable;
@property (weak, nonatomic) IBOutlet UILabel *yuanLable;
@property (weak, nonatomic) IBOutlet UILabel *rateLable;
@property (weak, nonatomic) IBOutlet UILabel *guarAccountLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIButton *agreeActionButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeNotActionButton;

@property (strong, nonatomic) NSDictionary *model;
@property (assign, nonatomic) BOOL agreed;

@end

@implementation GuaranteeConfirmingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"担保确认";
    
    [self setNavButton];
    [self connectToServer];
    
    [self prepareUI];
    
}

- (void)prepareUI {
    for (UILabel * l in self.promptLables) {
        l.font = CNFont_24px;
    }
    self.nameLable.font = self.yuanLable.font = self.rateLable.font = CNFont_30px;
    self.acountLable.font = CNFont_40px;
    
    self.guarAccountLable.font = CNFont_34px;
    self.timeLable.font = self.dateLable.font = CNFont_24px;
    
    self.agreeActionButton.layer.cornerRadius = 4.0f;
    self.agreeActionButton.layer.masksToBounds = YES;
    
    self.agreeNotActionButton.layer.cornerRadius = 4.0f;
    self.agreeNotActionButton.layer.masksToBounds = YES;
    
    self.agreeActionButton.backgroundColor =
    self.agreeNotActionButton.backgroundColor = CN_NAV_BKCOLOR;
    
}

- (void)setupUI{
    
    //self.acountLable.text = [Util formatRMBWithoutUnit:@([self.loanInfo[@"loanmainval"] integerValue])];
    self.acountLable.text = [Util formatRMBWithoutUnit:@([self.model[@"loanmainval"] integerValue])];
    
    //self.guarAccountLable.text = [Util formatRMBWithoutUnit:@([self.loanInfo[@"warrantyval"] integerValue])];
    
    //self.timeLable.text = [NSString stringWithFormat:@"%@天",self.loanInfo[@"feeval"]];
    self.timeLable.text = [NSString stringWithFormat:@"%@天",self.model[@"interest_daycount"]];
    
    //self.dateLable.text = [self.loanInfo[@"loancreatetime"] substringToIndex:10];
    self.dateLable.text = self.model[@"datetime1"];
    
    //self.rateLable.text = [NSString stringWithFormat:@"%@%%",self.loanInfo[@"loanrate"]];
    self.rateLable.text = [NSString stringWithFormat:@"%@%%",self.model[@"loanrate"]];
    
    self.nameLable.text = EMPTYSTRING_HANDLE(self.model[@"loanusername"]);
    
    NSString *userId = [ZAPP.myuser getUserID];
    BOOL matched = NO;
    NSArray *warrantyRepayment = self.model[@"warrantyRepayment"];
    if (warrantyRepayment.count > 0) {
        for (NSDictionary *info  in warrantyRepayment) {
            NSString *wUsrId = info[@"userid"];
            if ([wUsrId isEqualToString:userId]) {
                self.guarAccountLable.text = [Util formatRMBWithoutUnit:@([info[@"ulwval"] doubleValue])];
                matched = YES;
            }
        }
    }
    if (! matched) {
        //担保状态不一致
        [self hiddenView];
    }
    
}

- (void)hiddenView{
    UIView *view = [UIView new];
    view.backgroundColor = CN_COLOR_BG_GRAY;
    UILabel *lab = [UILabel new];
    lab.font = CNFont_30px;
    lab.textColor = CN_TEXT_GRAY;
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"您的好友已经修改借款信息，您无需进行确认，\n感谢您的支持";
    
    [view addSubview:lab];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(10);
        make.center.equalTo(view);
    }];
}

- (void)connectToServer {
    NSString *loanId =  self.loanInfo[@"loanid"];
    LoanDetailEngine *engine = [[LoanDetailEngine alloc] init];
    WS(weakSelf);
    [engine getDetail:[loanId integerValue] typeid:@"L" betid:0 success:^(NSDictionary *detail) {
        _model = detail;
        [weakSelf setupUI];
    } failure:^(NSString *error) {
        [weakSelf setupUI];
    }];
}

- (void)confirmGuaranteeWithValue:(NSString *)value {
    NSString *loanId =  self.loanInfo[@"loanid"];
    LoanDetailEngine *engine = [[LoanDetailEngine alloc] init];
    WS(weakSelf);
    progress_show
    [engine postConfirmWarranty:[loanId integerValue] confirm:value success:^(NSDictionary *detail) {
        progress_hide
        [Util toast:EMPTYSTRING_HANDLE(detail[@"msg"])];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        progress_hide;
        
    }];
}

- (IBAction)guarAgreeAction:(UIButton *)sender {
    if (! _agreed) {
        [Util toast:@"请同意担保协议"];
        return;
    }
    //同意担保
    [self confirmGuaranteeWithValue:@"2"];
}

- (IBAction)grarAgreeNotAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定不同意担保？"message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    [alert show];
}

- (IBAction)agreeAction:(UIButton *)sender {
    self.agreeButton.selected = !self.agreeButton.selected;
    self.agreed = self.agreeButton.selected;
}

- (IBAction)goingViewOfProtocol {
    NewLoanProtocolViewController *vc = [[NewLoanProtocolViewController alloc]init];
    vc.type = 9;
    vc.loanId = [self.loanInfo[@"loanid"] integerValue];
    vc.preferedTitle = @"担保协议";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            // 取消担保
            [self confirmGuaranteeWithValue:@"1"];
        }
    }
    
}

@end
