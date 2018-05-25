//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BindBank3.h"
#import "NewBorrowViewController.h"
#import "BlueButtonViewController.h"
#import "YaoqingJilu.h"
#import "LabelsView.h"
#import "ChongzhiCell.h"
#import "ValidcodeCell.h"
#import "ProgressIndicator.h"
#import "CustomTitledAlertView.h"
#import "ShowCardViewController.h"

@interface BindBank3 () {
    NSString *orderno;
}

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (strong, nonatomic) MKNetworkOperation *op;

@property (strong, nonatomic) IBOutlet UIButton *            validateButton;
@property (strong, nonatomic) IBOutlet UILabel *             validateLabel;

@property (strong, nonatomic) NextButtonViewController *next;

@property (strong, nonatomic)  ProgressIndicator* progressIndicator;
@property (strong, nonatomic) IBOutlet UIView* progressHolder;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *largeGrayLabel;

@property (weak, nonatomic) IBOutlet UIControl *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *activationCausationButton;
@property (weak, nonatomic) IBOutlet UIButton *nextActionButton;

@end

@implementation BindBank3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.overlayView.hidden = YES;
    
    
    self.validateLabel.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.validateLabel.layer.masksToBounds = YES;
    self.validateLabel.layer.borderWidth = 1;
    self.validateLabel.layer.borderColor = ZCOLOR(COLOR_BG_GRAY).CGColor;
    self.validateLabel.textColor = ZCOLOR(COLOR_BG_GRAY);
    
    self.validateButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.validateButton.layer.masksToBounds = YES;
    self.validateButton.layer.borderWidth = 1;
    self.validateButton.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    self.validateButton.titleLabel.textColor = ZCOLOR(COLOR_LIGHT_THEME);
    
//    self.loginActionButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
//    self.loginActionButton.layer.masksToBounds = YES;
//    self.loginActionButton.titleLabel.textColor = [UIColor whiteColor];
//    self.loginActionButton.backgroundColor = ZCOLOR(COLOR_NAV_BG_RED);
    
    
    
    self.validateLabel.font =
    self.validateButton.titleLabel.font = [UtilFont systemLarge];
    
    self.tf.font = [UtilFont systemLarge];
    self.tf.keyboardType    = UIKeyboardTypeNumberPad;
    self.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self validatecode_time_update];
}

- (void)customNavBackPressed {
    [self navigationBackToBankInfo];
}

- (void)viewDidLayoutSubviews
{
    NSNumber *lowlimiteverytrade = ZAPP.myuser.userVisaInfoRespondDict[@"lowlimiteverytrade"];
    NSString *lowlimiteverytradeString = [lowlimiteverytrade stringValue];
    [Util setUILabelLargeGray:self.largeGrayLabel];
    ((UILabel *)[self.largeGrayLabel objectAtIndex:0]).text = [NSString stringWithFormat:@"\n系统发起从您的银行卡向Cashnice账户充值请求，金额为%@元。请确认来自银行的信息，并输入短信验证码。\n", lowlimiteverytradeString] ;
    ((UILabel *)[self.largeGrayLabel objectAtIndex:1]).text = @"\n请先激活您的银行卡！";
    
    self.nextActionButton.titleLabel.font = [UtilFont systemButtonTitle];
    self.activationCausationButton.titleLabel.font = [UtilFont systemSmall];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"银行卡激活"];
    [self setNavButton];
    self.title = @"激活银行卡";
    
    [self didchanged:nil];
    //[ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    //    [self validatecode_time_update];
    
    
    
    [ZAPP.zvalidation startTimer];
    [ZAPP.zvalidation sucSend];
    
    
    [self didchanged:nil];
}
- (IBAction)activationCausationAction:(id)sender {
    [self.view endEditing:YES];
    CustomTitledAlertView *alert = [[CustomTitledAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.bindBank3", nil) andInfo:CNLocalizedString(@"alert.info.bindBank3", nil)];
    [alert show];
}

- (IBAction)sendPressed {
   	[self.view endEditing:YES];
    
    //    [ZAPP.zvalidation sendChongzhiCode:@(1.01) visaid:@"1" withComplete:nil error:nil];
    //    [self validatecode_time_update];
    
    [self.delegate resendValidationCode];
}

- (void)validatecode_time_update {
    int t = [ZAPP.zvalidation getRemainTime];
    if (t <= 0) {
        self.validateButton.enabled = YES;
        self.validateButton.hidden = NO;
        self.validateLabel.hidden   = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MSG_validatecode_time_update object:self];
    }
    else {
        self.validateButton.enabled = NO;
        self.validateButton.hidden = YES;
        self.validateLabel.hidden   = NO;
        self.validateLabel.text     = [NSString stringWithFormat:@"%d秒后重发", t];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"激活银行卡"];
    [self.op cancel];
    self.op = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"完成";//充值，完成绑定
        self.next =        ((NextButtonViewController *)[segue destinationViewController]);
    }
}


- (IBAction)nextButtonPressed {
    
    [self hide];
    [self.view endEditing:YES];
    
    orderno = [ZAPP.myuser.userVisaActiveRespondDict objectForKey:NET_KEY_ORDERNO];
    //    orderno = [ZAPP.myuser.visaValidationCodeRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
        
        [self connectToCommit];
    }
    else {

        [Util toastStringOfLocalizedKey:@"tip.bamkCardBindFails"];
    }
}

- (void)setDataCheck {

    [Util toastStringOfLocalizedKey:@"tip.processing"];
    [self navigationBackToBankInfo];
}

- (void)navigationBackToBankInfo {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[ShowCardViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)connectToCommit {
    [self.op cancel];
    bugeili_net
    orderno = [ZAPP.myuser.userVisaActiveRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
        [self validatecode_time_update];
        [SVProgressHUD show];
        
        __weak __typeof__(self) weakSelf = self;
        
        self.op = [ZAPP.netEngine checkChongzhiValidateCodeWithComplete:^{
            [weakSelf setDataCheck];
            [SVProgressHUD dismiss];
        } error:^{
            [weakSelf loseData];
            [SVProgressHUD dismiss];
        } orderno:orderno code:self.tf.text];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (BOOL)lastRow:(NSIndexPath *)index {
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray =@[@"code"];
    }
    return _imageArray;
}
- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = @[@"请输入短信验证码"];
    }
    return _nameArray;
}


- (void)loseData {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ValidcodeCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    [cell.tf setEnabled:YES];
    
    cell.sepLine.hidden = YES;
    cell.tf.placeholder = [self.nameArray objectAtIndex:0];
    cell.tf.delegate    = self;
    cell.tf.tag = 1;
    
    cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:0]];
    cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
    cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    cell.delegate           = self;
    
    self.tf            = cell.tf;
    self.validateButton = cell.validButton;
    self.validateLabel  = cell.validLabel;
    [self validatecode_time_update];
    
    [self didchanged:nil];
    
    return cell;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self hide];
}

- (void)hide {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)didchanged:(UITextField *)textField {
    bool fillingCompleted = NO;
    if ([self.tf.text notEmpty]) {
        fillingCompleted = YES;
    }
    self.nextActionButton.enabled = fillingCompleted;
    [self.nextActionButton setBackgroundColor:fillingCompleted?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.55 animations:^{
        self.overlayView.alpha = .0f;
    } completion:^(BOOL finished) {
        self.overlayView.hidden = YES;
    }];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification {
    
    self.overlayView.hidden = NO;
    [UIView animateWithDuration:0.55 animations:^{
        self.overlayView.alpha = .3f;
    } completion:^(BOOL finished) {
        ;
    }];
}

@end
