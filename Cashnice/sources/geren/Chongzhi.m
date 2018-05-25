//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "Chongzhi.h"
#import "NewBorrowViewController.h"
#import "BlueButtonViewController.h"
#import "YaoqingJilu.h"
#import "LabelsView.h"
#import "ChongzhiCell.h"
#import "ValidcodeCell.h"
#import "ProgressIndicator.h"
#import "CustomAutoCloseAlertView.h"
#import "CustomIOSAlertView.h"

@interface Chongzhi()  <CustomAutoCloseAlertViewDelegate, CustomIOSAlertViewDelegate> {
    NSString *visa;
    NSString *bank;
    NSString *card;
    NSString *bankname;
    
    NSString *savedVal;
    NSString *orderno;
}

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIView *textbgview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *con_textHeight;

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) UITextField *tf0;
@property (weak, nonatomic) UITextField *tf1;
@property (strong, nonatomic) UITextField *tfLimit;
@property (strong, nonatomic) UITextField *tfBank;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) UIButton *            validateButton;
@property (strong, nonatomic) UILabel *             validateLabel;
@property (strong, nonatomic) NextButtonViewController *next;

@end

@implementation Chongzhi

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

    
	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.textbgview.layer.cornerRadius = [ZAPP.zdevice getDesignScale:5];
    
    self.textview.text = @"重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明重要说明";
    self.textview.userInteractionEnabled = NO;
    self.textbgview.hidden = YES;
    
    self.textview.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.textview.font = [UtilFont systemLarge];
    CGSize textViewSize = [self.textview sizeThatFits:CGSizeMake([ZAPP.zdevice getDesignScale:390], FLT_MAX)];
    self.con_textHeight.constant = textViewSize.height ;
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"确认充值"];
[self setNavButton];
	[self setTitle:@"确认充值"];
    
    [self initInfos];
    [self ui];
    [self connectToGetBankInfo];
    [self didchanged:nil];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    [self validatecode_time_update];
    [self didchanged:nil];
}
- (void)initInfos {
    if (self.level == 1) {
        visa = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_visaid];
        card = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_visacode];
        bank = [ZAPP.myuser.gerenInfoDict objectForKey:NET_KEY_bankcode];
        bankname = bank;
    }
    else {
        visa = [ZAPP.myuser.gerenBankDict objectForKey:NET_KEY_visaid];
        card = [ZAPP.myuser.gerenBankDict objectForKey:NET_KEY_visacode];
        bank = [ZAPP.myuser.gerenBankDict objectForKey:NET_KEY_bankcode];
        bankname = [ZAPP.myuser.gerenBankDict objectForKey:NET_KEY_bankname];
    }
    
    [self.table reloadData];
}

- (void)sendPressed {
   	[self.view endEditing:YES];
    
    if ([self.tf0.text doubleValue] <= 0) {

        [Util toastStringOfLocalizedKey:@"tip.inputtingRechargeCount"];
        return;
    }
    
    /**
     * 验证 充值至少2元
    NSString *text = self.tf0.text;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    if ([f numberFromString:text])
    {
        CGFloat amount = [text doubleValue];
        if (amount < 2.0) {
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:@"亲，充值金额不能少于2元哦" closeDelegate:self buttonTitles:@[@"确定"]];
            alertView.tag = 0;
            [alertView show];
            [alertView formatAlertButton];
            
            return;
        }
    }else{
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithMessage:@"请输入充值金额" closeDelegate:self buttonTitles:@[@"确定"]];
        alertView.tag = 0;
        [alertView show];
        [alertView formatAlertButton];
    }
    */
    
    savedVal = self.tf0.text;
    
    [ZAPP.zvalidation sendChongzhiCode:savedVal visaid:visa withComplete:nil error:nil];
    [self validatecode_time_update];
}

- (void)validatecode_time_update {
    int t = [ZAPP.zvalidation getRemainTime];
    if (t <= 0) {
        self.validateButton.enabled =YES;
        self.validateButton.hidden = NO;
        
        self.validateLabel.hidden   = YES;
    }
    else {
        self.validateButton.enabled = NO;
        self.validateLabel.hidden   = NO;
        self.validateButton.hidden = YES;
        self.validateLabel.text     = [NSString stringWithFormat:@"重新发送 %d", t];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [MobClick endLogPageView:@"确认充值"];
    [self.op cancel];
    self.op = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (void)ui {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
		((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"确认充值";
        self.next =        ((NextButtonViewController *)[segue destinationViewController]);
	}
}


- (void)nextButtonPressed {
    
    [self hide];
    [self.view endEditing:YES];
    
    orderno = [ZAPP.myuser.visaValidationCodeRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
        
    }
    else {

        [Util toastStringOfLocalizedKey:@"tip.rechargeGettingValidationCode"];
        return;
    }
    
    if ([self.tf0.text isEqualToString:savedVal]) {
        
        [self connectToValidate];
    }
    else {

        [Util toastStringOfLocalizedKey:@"tip.regainGettingValidationCode"];
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(CustomIOSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView close];
}

- (void)setDataCheck {
    
    CustomAutoCloseAlertView *autoCloseAlertView = [[CustomAutoCloseAlertView alloc] initWithMessage:CNLocalizedString(@"alert.message.chongzhi", nil) closeDelegate:self timeInterval:3];
    [autoCloseAlertView show];
    [autoCloseAlertView formatAlertButton];
}

- (void)CustomAutoCloseAlertViewClosed: (id)alertView {
    [Util navPopTheTopN:self.level nav:self.navigationController];
}

- (void)connectToValidate {
    [self.op cancel];
    bugeili_net
    orderno = [ZAPP.myuser.visaValidationCodeRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
//        [ZAPP.zvalidation clearRemainTimeAndStopTimer];
        [SVProgressHUD show];
        
        __weak __typeof__(self) weakSelf = self;

        self.op = [ZAPP.netEngine checkChongzhiValidateWithComplete:^{
            [weakSelf connectToCommit];
        } error:^{
            [weakSelf loseData];
            [SVProgressHUD dismiss];
        }value:self.tf1.text];
    }
}

- (void)connectToCommit {
    [self.op cancel];
    bugeili_net
    orderno = [ZAPP.myuser.visaValidationCodeRespondDict objectForKey:NET_KEY_ORDERNO];
    if ([orderno notEmpty]) {
//        [ZAPP.zvalidation clearRemainTimeAndStopTimer];

        __weak __typeof__(self) weakSelf = self;

        self.op = [ZAPP.netEngine checkChongzhiValidateCodeWithComplete:^{
            [weakSelf setDataCheck];
            [SVProgressHUD dismiss];
        } error:^{
            [weakSelf loseData];
            [SVProgressHUD dismiss];
        } orderno:orderno code:self.tf1.text];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 1 ) ? 2 : 1;
}
- (BOOL)lastRow:(NSIndexPath *)index {
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:44];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 2) ? [ZAPP.zdevice getDesignScale:20] : [ZAPP.zdevice getDesignScale:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return (section == 1) ? [ZAPP.zdevice getDesignScale:10] : 0.01;
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 10) {
        LabelsView *v =  [[[NSBundle mainBundle] loadNibNamed:@"LabelsView" owner:self options:nil] objectAtIndex:0];
        [v setTexts:@[@"注意：请输入",@"支付密码",@"，不是登录密码！"]];
        [v setIndexColor:ZCOLOR(COLOR_BUTTON_RED) index:@[@(1)]];
        return v;
    }
    else {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [UIView new];
    v.userInteractionEnabled = NO;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray =@[@"money", @"bank_card", @"", @"code"];
    }
    return _imageArray;
}
- (NSArray *)nameArray {
    if (_nameArray == nil) {
        _nameArray = @[@"充值金额，建议充值1000以上的金额", @"建设银行 1234", @"", @"请输入短信验证码"];
    }
    return _nameArray;
}

- (void)setData {
    NSDictionary *dict = ZAPP.myuser.bankInfoRespondDict;
    
    bankname = [ZAPP.myuser.bankInfoRespondDict objectForKey:NET_KEY_bankname];
    NSString *limitSingle = [Util formatRMB:@([[dict objectForKey:NET_KEY_limiteverytrade] doubleValue])];
    NSString *limitDay =[Util formatRMB:@([[dict objectForKey:NET_KEY_limiteveryday] doubleValue])];
    self.tfBank.text = [NSString stringWithFormat:@"%@  %@", bankname, card];
    self.tfLimit.attributedText = [self getAttr:limitSingle str:limitDay];
    [self ui];
}

- (void)loseData {
    // 刷新发送验证码按钮
//    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

- (void)connectToGetBankInfo {
    [self.op cancel];
    bugeili_net
    
    WS(ws);

    
    if ([bank notEmpty]) {
        progress_show
        self.op = [ZAPP.netEngine getBankInfoWithComplete:^{
            [ws setData];
            progress_hide
        } error:^{
            [ws loseData];
            progress_hide
        }
             bankcode:bank];
    }
}

//- (void)connectToCheckValidateCode {
//    [self.op cancel];
//    bugeili_net
//    
//    if ([bank notEmpty]) {
//        self.op = [ZAPP.netEngine getBankcardInfoWithComplete:^{[self setData];} error:^{[self loseData];} bankcode:bank];
//    }
//}

- (NSAttributedString *)getAttr:(NSString *)str1 str:(NSString *)str2 {
    NSString *f = [NSString stringWithFormat:@"单笔限额%@  每日限额%@", str1, str2];
    NSAttributedString *a  = [Util getAttributedString:f font:[UtilFont systemLarge] color:ZCOLOR(COLOR_TEXT_BLACK)];
    return a;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {

    ChongzhiCell *cell;
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.txtImg.hidden = NO;
    cell.moneyImg.hidden = YES;
    [cell.tf setEnabled:YES];
    cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    cell.sepLine.hidden = [self lastRow:indexPath];
    if (indexPath.section == 1) {
        NSInteger idx = 1 + indexPath.row;
        
        
        cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:idx]];
        cell.detail.text = @"";
        cell.tf.enabled = NO;
        cell.tf.secureTextEntry = NO;
        

        
        if (indexPath.row== 1) {
            cell.tf.text = @"";
            cell.tf.attributedText = [self getAttr:@"" str:@""];
            cell.imgAspect.priority = 5;
            self.tfLimit = cell.tf;
            cell.tf.tag = 1;
        }
        else {
            cell.tf.text = [NSString stringWithFormat:@"%@  %@", bankname, card];
            cell.tf.attributedText = nil;
            self.tfBank = cell.tf;
            cell.tf.tag = 1;
        }
    }
    else if (indexPath.section == 0){
        NSInteger idx = (indexPath.section == 0 ) ? 0 : 3 + indexPath.row;
        cell.tf.placeholder = [self.nameArray objectAtIndex:idx];
        cell.tf.delegate = self;
        cell.tf.tag = indexPath.section;
        
        cell.txtImg.image = [UIImage imageNamed:[self.imageArray objectAtIndex:idx]];
        cell.detail.text = (indexPath.section == 0) ? @"元" : @"";
        cell.tf.enabled = YES;
        cell.tf.secureTextEntry = indexPath.section == 2;
        cell.tf.attributedText = nil;
        
        if (indexPath.section == 0) {
            self.tf0 = cell.tf;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;//UIKeyboardTypeDecimalPad;
            cell.tf.tag = 0;
        }

        else  if (indexPath.section== 2) {
            self.tf1 = cell.tf;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;//UIKeyboardTypeNumberPad;
            cell.tf.tag = 1;
        }
    }
        return cell;
    }
    else {
        ValidcodeCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        [cell.tf setEnabled:YES];
        
        cell.sepLine.hidden = YES;
        cell.tf.placeholder = [self.nameArray objectAtIndex:3];
        cell.tf.delegate    = self;
        cell.tf.tag = 1;
        
        cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:3]];
        cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
        cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.delegate           = self;
        
        self.tf1            = cell.tf;
        self.validateButton = cell.validButton;
        self.validateLabel  = cell.validLabel;
        [self validatecode_time_update];
        
        [self.validateButton setTitle:@"发送验证码" forState:UIControlStateDisabled];
        [self didchanged:nil];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self hide];
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tf0.text = [Util cutMoney:self.tf0.text];
}

- (IBAction)didchanged:(UITextField *)textField {
    self.tf0.text = [Util cutMoney:self.tf0.text];
    BOOL validated = ([self.tf0.text doubleValue]>0);
    
    if (validated) {
        self.validateButton.enabled = YES;
        [self.validateButton setTitleColor:ZCOLOR(COLOR_BUTTON_BLUE) forState:UIControlStateNormal];
    }else{
        self.validateButton.enabled = NO;
        [self.validateButton setTitleColor:ZCOLOR(COLOR_TEXT_GRAY) forState:UIControlStateNormal];
    }
    
    [self.next setTheEnabled:([self.tf0.text doubleValue] > 0 && [self.tf1.text notEmpty])];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tf0.text = [Util cutMoney:self.tf0.text];
}


@end
