//
//  SinaRechargeViewController.m
//  Cashnice
//
//  Created by a on 16/8/22.
//  Copyright © 2016年 l. All rights reserved.
//

#import "SinaRechargeViewController.h"
#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"
#import "CNActionButton.h"
#import "MyRemainMoneyInterestViewController.h"

@interface SinaRechargeViewController () <HandleCompletetExport>

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *yuanLable;
@property (weak, nonatomic) IBOutlet UILabel *valuePromptLabel;
@property (weak, nonatomic) IBOutlet CNActionButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *bankButton;

@property (strong, nonatomic) UIBarButtonItem *rightNavBar;
@end

// 充值

@implementation SinaRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    [self setNavButton];
    [self setNavRightBtn];
//    [self setRightNavBar];
    self.promptLabel.text = @"";
    /*
    NSString *text = @"温馨提示：\r\n根据银行相关规定，部分银行首次绑卡支付有一定的限额。详情请查看.";
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString : text];
    // 添加行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:[ZAPP.zdevice getDesignScale:10]];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.string.length)];
    self.promptLabel.font = [UtilFont systemLargeNormal];
    self.promptLabel.attributedText = attributedText;
    */
    
    self.bankButton.titleLabel.font = [UtilFont systemLargeNormal];
    self.bankButton.tintColor = ZCOLOR(COLOR_BUTTON_BLUE);
    
    self.valuePromptLabel.font =
    self.valueTextField.font =
    self.yuanLable.font = [UtilFont systemLargeNormal];
    self.confirmButton.associatedTextField = self.valueTextField;
    [self tapBackground];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"充值"];
}


-(void)setNavRightBtn{
    
    self.isRightNavBtnBorderHidden = YES;
    
    [super setNavRightBtn];
    
    [self.rightNavBtn.titleLabel setFont:CNFontNormal];
    [self.rightNavBtn setTitle:@"大额充值" forState:UIControlStateNormal];
    [self.rightNavBtn sizeToFit];
    self.rightNavBtn.left -= 5;
}

//- (UIBarButtonItem *)rightNavBar{
//    if (! _rightNavBar) {
//        UIButton *editBtn = [[UIButton alloc]init];//WithFrame:CGRectMake(0, 4, 90, 22)
//        editBtn.titleLabel.font = CNFontNormal;
//        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [editBtn addTarget:self action:@selector(wholesaleAction) forControlEvents:UIControlEventTouchUpInside];
//        [editBtn setTitle:@"大额充值" forState:UIControlStateNormal];
////        editBtn.backgroundColor = [UIColor redColor];
//        [editBtn sizeToFit];
////        editBtn.layer.borderWidth = 1;
////        editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
////        editBtn.layer.cornerRadius = 5;
////        editBtn.layer.masksToBounds = YES;
//        UIView *containerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, editBtn.width, KNAV_SUBVIEW_MAXHEIGHT)];
//        [containerView1 addSubview:editBtn];
//        _rightNavBar = [[UIBarButtonItem alloc]initWithCustomView:containerView1];
//        
//    }
//    return _rightNavBar;
//}

//- (void)setRightNavBar{
//    self.navigationItem.rightBarButtonItem = self.rightNavBar;
//}

- (void)rightNavItemAction{
    UIViewController *prompt = ZSEC(@"BigAmountPromptingViewController");
    
    UINavigationController *scannav = [[UINavigationController alloc] initWithRootViewController:prompt];
    
    [self presentViewController:scannav animated:YES completion:^{
        ;
    }];
}

- (IBAction)rechargeAction:(id)sender {
    [self tapOnce];
    
    if ([[self getInputedValue] doubleValue] <= 0) {
        [Util toastStringOfLocalizedKey:@"tip.inputtingRechargeCount"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    progress_show
    [model recharge:[self getInputedValue] success:^(NSData *contentData) {
        progress_hide
        //[weakSelf pushToSinaWebViewWithContentData:contentData];
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.loadData = contentData;
        web.titleString = @"充值";
        web.completeHandle = self;
        [weakSelf.navigationController pushViewController:web animated:YES];
    } failure:^(NSString *error) {
        progress_hide
    }];
}

- (NSString *)getInputedValue {
    return [self.valueTextField.text trimmed];
}

- (IBAction)bankButtonAction:(id)sender {
    UIViewController *vc = ZBANK(@"SupportedBankListViewController");
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)inputChanged{
   self.valueTextField.text = [Util cutMoney:self.valueTextField.text];
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
