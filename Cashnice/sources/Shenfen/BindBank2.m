//
//  NewBorrowViewController.m
//  YQS
//
//  Created by l on 3/17/15.
//  Copyright (c) 2015 l. All rights reserved.
//

#import "BindBank2.h"
 
#import "FabuJiekuanTableViewCell.h"
#import "ValidcodeCell.h"
#import "ProgressIndicator.h"
#import "BindBank3.h"
#import "BindValidcodeCell.h"
#import "CustomTitledAlertView.h"
#import "ShowCardViewController.h"
#import "SinaCashierModel.h"
#import "SinaCashierWebViewController.h"
#import "MyRemainMoneyInterestViewController.h"

@interface BindBank2 () <BindBank3Delegate, HandleCompletetExport> {
    BOOL alreadySent;
}
@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextField *tf0;
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *footer;
@property (strong, nonatomic) NextButtonViewController *next;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) IBOutlet UIButton *                validateButton;
@property (strong, nonatomic) IBOutlet UILabel *                 validateLabel;

@property (strong, nonatomic) IBOutlet UIView* progressHolder;
@property (strong, nonatomic)  ProgressIndicator* progressIndicator;

@property (weak, nonatomic) IBOutlet UIButton *unreceivedButton;
@property (weak, nonatomic) IBOutlet UIButton *nextActionButton;

@end

@implementation BindBank2

//CODE_BLOCK_PROGRESS_INDICATOR_ADD_AND_ALLOC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = ZCOLOR(COLOR_BG_GRAY);
    self.table.allowsSelection = NO;
    
    self.header.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.footer.textColor = ZCOLOR(COLOR_TEXT_GRAY);
    self.unreceivedButton.titleLabel.font =
    [UtilFont systemSmall];
    
    
    self.nextActionButton.titleLabel.font =
    self.validateButton.titleLabel.font =
    self.validateLabel.font =
    self.tf0.font =
    self.header.font =
    self.footer.font = [UtilFont systemLarge];
    self.header.text = [NSString stringWithFormat:@"绑定银行卡需要短信确认，验证码已经发送至手机：\n%@，请按提示操作。", [self formatMaskedPhoneNumber]];
    
    ////
    self.validateButton.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.validateButton.layer.masksToBounds = YES;
    self.validateButton.layer.borderWidth = 1;
    self.validateButton.layer.borderColor = ZCOLOR(COLOR_LIGHT_THEME).CGColor;
    self.validateButton.titleLabel.textColor = ZCOLOR(COLOR_LIGHT_THEME);
    
    
    self.validateLabel.layer.cornerRadius = [ZAPP.zdevice getDesignScale:4];
    self.validateLabel.layer.masksToBounds = YES;
    self.validateLabel.layer.borderWidth = 1;
    self.validateLabel.layer.borderColor = ZCOLOR(COLOR_BG_GRAY).CGColor;
    self.validateLabel.textColor = ZCOLOR(COLOR_BG_GRAY);
    
    self.footer.text = @"";
    
    //[self addProgressBar];
    self.nextActionButton.titleLabel.font = [UtilFont systemButtonTitle];
    
    if (self.hasId) {
        [self.progressIndicator setCurrentPage:1 strings:BIND_BANK_TITLES_3_STEP];
    }
    else {
        [self.progressIndicator setCurrentPage:2 strings:BIND_BANK_TITLES_4_STEP];
    }
    [self tapBackground];
    
    [self validatecode_time_update];
}

BLOCK_NAV_BACK_BUTTON

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self setNavButton];
    [MobClick beginLogPageView:@"绑定银行卡Step2"];
	self.title = @"验证手机号";
	
    [self hide];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hide];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validatecode_time_update) name:MSG_validatecode_time_update object:nil];
    [self validatecode_time_update];
    [self didChanged:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"绑定银行卡Step2"];
    
    [self hide];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
}

- (NSAttributedString *)getAtrrHeader {
    return nil;
}
- (NSAttributedString *)getAtrrFooter {
    return nil;
}

- (void)uiLabels {
    self.header.attributedText = [self getAtrrHeader];
    self.footer.attributedText = [self getAtrrFooter];
}

- (IBAction)unreceivedAction:(id)sender {
    [self.view endEditing:YES];
    CustomTitledAlertView *alert = [[CustomTitledAlertView alloc] initWithTitle:CNLocalizedString(@"alert.title.bindBank2.ValidationCode", nil)
                                                                        andInfo:CNLocalizedString(@"alert.info.bindBank2.ValidationCode", nil)];
    [alert show];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.

	if ([[segue destinationViewController] isKindOfClass:[NextButtonViewController class]]) {
        ((NextButtonViewController *)[segue destinationViewController]).delegate = self;
        ((NextButtonViewController *)[segue destinationViewController]).titleString = @"下一步";
        self.next =  ((NextButtonViewController *)[segue destinationViewController]);
    }
}



- (IBAction)nextButtonPressed {
    
    [self.view endEditing:YES];
    
#ifdef TEST_BIND_BANK_STEPS
    
    [self setDataCheck];
    return;
    
    BindBank3 *cz = ZSTORY(@"BindBank3");
    cz.hasId = self.hasId;
    cz.phone = self.phone;
    cz.card = self.card;
    cz.delegate = self;
    [self.navigationController pushViewController:cz animated:YES];
#endif
    
    if (![Util isValidCode:self.tf0.text]) {
        [Util toastStringOfLocalizedKey:@"tip.inputingRightSMSCode"];
        return;
    }
    
    [self connectToCommit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (BOOL)lastRow:(NSInteger)row {
    return row == 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZAPP.zdevice getDesignScale:50];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [ZAPP.zdevice getDesignScale:0];
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

- (void)validatecode_time_update {
    int t = [ZAPP.zvalidation getRemainTime];
    if (t <= 0) {
        self.validateButton.enabled = YES;
        self.validateButton.hidden = NO;
        self.validateLabel.hidden   = YES;
        [self.validateButton setTitle:(alreadySent? @"重新获取" : @"发送验证码") forState:UIControlStateNormal];
    }
    else {
        self.validateButton.enabled = NO;
        self.validateButton.hidden = YES;
        self.validateLabel.hidden   = NO;
        alreadySent = YES;
        self.validateLabel.text     = [NSString stringWithFormat:@"%d秒后重发", t];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ValidcodeCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    [cell.tf setEnabled:YES];
    
    cell.sepLine.hidden =  YES;
    cell.tf.placeholder = [self.nameArray objectAtIndex:indexPath.row];
    cell.tf.delegate    = self;
    
//    cell.txtImg.image       = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    cell.tf.keyboardType    = UIKeyboardTypeNumberPad;
    cell.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    cell.delegate           = self;
    
    self.tf0            = cell.tf;
    self.validateButton = cell.validButton;
    self.validateLabel  = cell.validLabel;
    
    [self didChanged:nil];
    
    return cell;

}


- (NSString *)formatMaskedPhoneNumber{

    NSString *realNum = [self.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (realNum.length > 8) {
        return [realNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        return realNum;
    }
}
-(void)tapBackground //在ViewDidLoad中调用
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

-(void)tapOnce//手势方法
{
    [self hide];
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

- (IBAction)didChanged:(id)sender {
    bool fillingCompleted = NO;
    if ([self.tf0.text notEmpty]) {
        fillingCompleted = YES;
    }
    self.nextActionButton.enabled = fillingCompleted;
    [self.nextActionButton setBackgroundColor:fillingCompleted?ZCOLOR(COLOR_NAV_BG_RED):ZCOLOR(COLOR_TEXT_LIGHT_GRAY)];
}

- (IBAction)sendPressed {
    [self.view endEditing:YES];
    
    [self.delegate resendValidationCode];
}

/////  重新  发送激活验证码   /////
- (void)resendValidationCode {
    progress_show
    [ZAPP.netEngine requestVisaActiveValidateCodeComplete:^{
        progress_hide
        [ZAPP.zvalidation sucSend];
        [ZAPP.zvalidation startTimer];
        //TODO: 将银行卡信息放入Chongzhi.m
    } error:^{
        progress_hide
    }];
}


/////  发送激活验证码   /////
- (void)sendVisaActiveValiCode {
    WS(ws);

    [ZAPP.netEngine requestVisaActiveValidateCodeComplete:^{
        
        BindBank3 *cz = ZSTORY(@"BindBank3");
        cz.hasId = self.hasId;
        cz.phone = self.phone;
        cz.card = self.card;
        cz.delegate = self;
        [ws.navigationController pushViewController:cz animated:YES];
        
        progress_hide
        //TODO: 将银行卡信息放入Chongzhi.m
    } error:^{
        progress_hide;
    }];
}

- (void)setDataCheck {
    
    //[Util toastStringOfLocalizedKey:@"tip.processing"];
    [self navigationBackToBankInfo];
}

- (void)navigationBackToBankInfo {
    //已经绑卡
    __weak typeof(self) weakSelf = self;
    SinaCashierModel *model = [[SinaCashierModel alloc] init];
    progress_show
    [model bankCardManagementWithsuccess:^(NSString *URL, NSData *Content) {
        progress_hide
        SinaCashierWebViewController *web = [[SinaCashierWebViewController alloc] init];
        web.URLPath = URL;
        web.titleString = @"管理银行卡";
        web.completeHandle = weakSelf;
        web.navigationBackHandler = ^(void){
            
            
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [weakSelf yueryouxiStackPopHandle];
        };
        [self.navigationController pushViewController:web animated:YES];
    } failure:^(NSString *error) {
        progress_hide
    }];
    /*
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[ShowCardViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
     */
    
}

-(void)yueryouxiStackPopHandle{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyRemainMoneyInterestViewController class]]) {
             [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)complete{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyRemainMoneyInterestViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setData {
    int res = [[ZAPP.myuser.checkBankValidateCodeRespondDict objectForKey:@"verified"] intValue];
    if (res == 1 || res == 0) {
        /////  发送验证码   /////
        [self sendVisaActiveValiCode];
    }
    else {
        progress_hide
        [self loseData];
    }
}

- (void)loseData {
    NSDictionary *errorDict = [AppDelegate zapp].myuser.checkBankValidateCodeRespondDict;
    if (errorDict) {
        [Util toast : errorDict[@"msg"]];
    }else{
        [Util toastStringOfLocalizedKey:@"tip.bamkCardBindFail"];
    }
    [ZAPP.zvalidation clearRemainTimeAndStopTimer];
    [self validatecode_time_update];
}

- (void)connectToCommit {
    [self.op cancel];
    bugeili_net
//#ifdef TEST_BIND_BANK_STEPS
//    [self setData];
//    return;
//#endif
    if ([self.orderno notEmpty]) {
        progress_show
        
        __weak __typeof__(self) weakSelf = self;
        
        self.op = [ZAPP.netEngine checkBankcardValidateCodeWithComplete:^{
            //去掉激活银行卡步骤
            //[weakSelf setData];
            progress_hide;
            [weakSelf setDataCheck];
        } error:^{
            [weakSelf loseData];
            progress_hide
        } orderno:self.orderno code:self.tf0.text];
        
    }
}
@end
